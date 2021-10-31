import sqlite3
import json
import os
from pathlib import Path
from haralyzer import HarParser
import base64

filename = 'session.db'
create_table_statement = """
CREATE TABLE dump (
  url text,
  data blob
)"""
path = Path(filename)
if path.exists():
  os.remove(path)
conn = sqlite3.connect(filename)
cur = conn.cursor()
cur.execute(create_table_statement)
conn.commit()

def get_entries():
  with open('session.har') as fp:
    for entry in json.load(fp)['log']['entries']:
      yield entry

for entry in get_entries():
  content = entry['response']['content']
  if content['size'] == 0 or 'text' not in content:
    continue

  if content.get('encoding') == 'base64':
    data = base64.b64decode(content['text'])
  else:
    data = content['text']

  cur.execute(
    'INSERT INTO dump VALUES (?, ?)', (entry['request']['url'], data)
  )
  conn.commit()

# Finish up
conn.close()
