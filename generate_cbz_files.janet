(import sqlite3 :as sql)
(import json)

(def db (sql/open "session.db"))

(def comics
  (let [row->comic |(-> $0 (get :data) (json/decode true) (get :data))
        comic->pair |[($0 :id) $0]]
    (as-> (sql/eval db "select data from dump where url like '%ComicDetail%';") _
      (mapcat |(-> $0 row->comic comic->pair) _)
      (table ;_))))

#(each comic comics (pp (type comic)))

(def episodes
  (let [path-peg (peg/compile ~{:number (cmt (<- :d+) ,scan-number)
                                :main (sequence "/bfs/manga/" :number "/" :number)})
        row->episode (fn [row]
          (when-let [episode (-> row (get :data) (json/decode true) (get :data))
                     path (episode :path)
                     [comic-id episode-id] (peg/match path-peg path)]
            (put episode :comic (comics comic-id))
            (put episode :id episode-id)
            episode))
        episode->pair |[($0 :id) $0]]
    (as-> (sql/eval db "select data from dump where url like '%GetImageIndex%';") _
      (mapcat |(-> $0 row->episode episode->pair) _)
      (table ;_)
      (values _))))

#(pp (get-in episodes [0]))

(each episode episodes
  (let [comic (episode :comic)
        detail (find |(= ($0 :id) (episode :id)) (comic :ep_list))]
    (pp (episode :id))))



# Finish up
(sql/close db)
