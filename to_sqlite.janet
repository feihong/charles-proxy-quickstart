(import json)
(import codec)
(import sqlite3 :as sql)

(def dbfile "session.db")
(when (os/stat dbfile) (os/rm dbfile))

(def rows
  (do
    (defn keep-fn [entry]
      (if-let [content (get-in entry [:response :content])
              size-not-zero (not= 0 (content :size))
              text (content :text)
              encoding (content :encoding)
              maybe-decode |(if (= "base64" encoding) (codec/decode $0) $0)]
        {:url (get-in entry [:request :url])
        :data (-> text maybe-decode buffer)}))
    (with [f (file/open "session.har")]
      (as-> (file/read f :all) _
        (json/decode _ true) _
        (get-in _ [:log :entries])
        (keep keep-fn _)))))

(with [db (sql/open dbfile)]
  (sql/eval db "CREATE TABLE dump (url text, data blob)")
  (each row rows
    (sql/eval db `INSERT INTO dump VALUES (:url, :data);` row)))
