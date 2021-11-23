from pathlib import Path
import os
import sys
import re
from zipfile import ZipFile, ZIP_STORED

try:
  input_dir = Path(sys.argv[1])
except:
  input_dir = Path(os.getcwd())

if input_dir.is_file():
  print(f'{input_dir} is not a directory')
  sys.exit(0)

comic_title = None

def get_cbz_files():
  global comic_title

  for file in sorted(input_dir.glob('*.cbz')):
    title = file.stem.split(' ')[0]
    if comic_title is None:
      comic_title = title
    else:
      assert comic_title == title, f'Comic title is {comic_title}, which does not match {title}'

    if re.search(r'第\w+卷', file.name):
      continue
    else:
      yield file

print(f'Comic title is {comic_title}\n')

# Sort cbz files by modification time (st_ctime_ns doesn't work)
cbz_files = sorted(get_cbz_files(), key=lambda p: p.stat().st_mtime_ns)

# Return generator of bytes objects
def get_images():
  for cbz_file in cbz_files:
    print(cbz_file)
    with ZipFile(cbz_file, 'r') as zf:
      for name in sorted(zf.namelist()):
        if name.endswith('.jpg'):
          print(f'  {name}')
          yield zf.read(name)

images = get_images()

# Write all images to big cbz file
output_file = input_dir / f'{comic_title} 第xxx卷.cbz'
image_count = 0

with ZipFile(output_file, 'w') as zf:
  for i, data in enumerate(images, 1):
    zf.writestr(f'{i:03}.jpg', data, compress_type=ZIP_STORED)

  image_count = i

final_path = output_file.with_name(f'{output_file.stem} ({image_count}){output_file.suffix}')
output_file.rename(final_path)
print(f'Wrote {image_count} images to {final_path}')
