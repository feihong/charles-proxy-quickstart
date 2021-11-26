(import json)
(import codec)
(import sqlite3 :as sql)

(def harfile "session.har")
(def dbfile "session.db")
(when (os/stat dbfile) (os/rm dbfile))

(def jq-bytes
  (let [jq-query ``.log.entries[] |
                   {url: .request.url,
                    encoding: .response.content.encoding,
                    data: .response.content.text}``
        proc (os/spawn ["jq" "--compact-output" jq-query harfile] :p {:out :pipe})]
    (generate [buf :iterate (:read (proc :out) 512)
               byte :in buf]
      byte)))

(defn bytes->lines [bytes]
  (fiber-fn :y
    (var acc (buffer/new 512))
    (each byte bytes
      (if (= byte 10)
        (do
          (yield acc)
          (buffer/clear acc))
        (buffer/push-byte acc byte)))
    (unless (empty? acc)
      (yield acc))))

(defn lines->rows [lines]
  (generate [line :in lines]
    (let [item (json/decode line true)
          encoding (item :encoding)
          maybe-decode |(if (= encoding "base64") (codec/decode $0) $0)]
      {:url (item :url)
       :data (-> item (get :data) maybe-decode buffer)})))

(with [db (sql/open dbfile)]
  (sql/eval db "CREATE TABLE dump (url text, data blob)")
  (each row (-> jq-bytes bytes->lines lines->rows)
    (sql/eval db `INSERT INTO dump VALUES (:url, :data);` row)))
