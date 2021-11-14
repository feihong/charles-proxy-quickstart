process: db cbz

db:
	#python to_sqlite.py
	janet to_sqlite.janet

cbz:
	python generate_cbz_files.py

clean:
	rm session.har; rm session.db
