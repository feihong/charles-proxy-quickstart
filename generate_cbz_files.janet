(import sqlite3 :as sql)
(import json)

(def db (sql/open "session.db"))

(def comics
  (let [row->comic |(-> $0 (get :data) (json/decode true) (get :data))
        comic->pair |[($0 :id) $0]]
    (as-> (sql/eval db "select data from dump where url like '%ComicDetail%';") _
      (mapcat |(-> $0 row->comic comic->pair) _)
      (table ;_))))

(each comic comics (pp (type comic)))

# Finish up
(sql/close db)
