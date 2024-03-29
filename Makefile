proxy:
	~/opt/charles/bin/charles &

process: jsonl db cbz

jsonl:
	jq --compact-output '.log.entries[] | {url: .request.url, encoding: .response.content.encoding, data: .response.content.text}' session.har > session.jsonl

db:
	coconut-run db.coco

cbz:
	coconut-run cbz.coco

volume:
	coconut-run volume.coco

clean:
	rm session.har; rm session.jsonl; rm session.db; rm *.cbz
