(import json)
(import codec)
(import sqlite3 :as sql)

(def jsonl-file "session.jsonl")
(def dbfile "session.db")
(when (os/stat dbfile) (os/rm dbfile))

(def lines
  (fiber-fn :y
    # Can't use `with` or `defer` inside generator function
    (let [f (file/open jsonl-file)]
      (loop [line :iterate (:read f :line)]
        (yield line))
      (:close f))))

(defn lines->rows [lines]
  (generate [line :in lines]
    (let [item (json/decode line true)
          encoding (item :encoding)
          maybe-decode |(if (= encoding "base64") (codec/decode $0) $0)]
      {:url (item :url)
       :data (-> item (get :data) maybe-decode buffer)})))

(with [db (sql/open dbfile)]
  (sql/eval db "CREATE TABLE dump (url text, data blob)")
  (each row (-> lines lines->rows)
    (sql/eval db `INSERT INTO dump VALUES (:url, :data);` row)))
