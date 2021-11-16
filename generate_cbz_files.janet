(import sqlite3 :as sql)
(import json)

(def db (sql/open "session.db"))

(def comics
  (let [row->comic |(-> $0 (get :data) (json/decode true) (get :data))
        comic->pair |[(string ($0 :id)) $0]]
    (as-> (sql/eval db "select data from dump where url like '%ComicDetail%';") _
      (mapcat |(-> $0 row->comic comic->pair) _)
      (table ;_))))

#(each comic comics (pp (type comic)))

(def path-peg (peg/compile ~{:main (sequence "/bfs/manga/" (<- :d+) "/" (<- :d+))}))

(defn row->episode-pair [row]
    (when-let [episode (-> row (get :data) (json/decode true) (get :data))
               path (episode :path)
               [comic-id episode-id] (peg/match path-peg path)]
      (put episode :comic (comics comic-id))
      (put episode :id episode-id)
      [episode-id episode]))

(def episodes
  (as-> (sql/eval db "select data from dump where url like '%GetImageIndex%';") _
    (keep row->episode-pair _)
    (flatten _)
    (table ;_)
    (values _)))

(pp (get-in episodes [0]))
#(each ep episodes (pp ep))

# Finish up
(sql/close db)
