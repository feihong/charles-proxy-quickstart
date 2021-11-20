(import json)
(import codec)
(import sqlite3 :as sql)

(defn keep-fn [entry]
  (let [content (get-in entry [:response :content])]
    (if (or (= 0 (content :size)) (nil? (content :text)))
      nil
      {:url (get-in entry [:request :url])
       :data (buffer
               (if (= "base64" (content :encoding))
                 (codec/decode (content :text))
                 (content :text)))})))

(def dbfile "session.db")
(when (os/stat dbfile) (os/rm dbfile))

(def rows
  (with [f (file/open "session.har")]
    (as-> (file/read f :all) _
      (json/decode _ true) _
      (get-in _ [:log :entries])
      (keep keep-fn _))))

(with [db (sql/open dbfile)]
  (sql/eval db "CREATE TABLE dump (url text, data blob)")
  (each row rows
    (sql/eval db `INSERT INTO dump VALUES (:url, :data);` row)))
