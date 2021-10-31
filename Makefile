process: db cbz

db:
	python to_sqlite.py

cbz:
	python generate_cbz_files.py

clean:
	rm session.har; rm session.db
