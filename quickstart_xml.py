import xml.sax

class MyHandler(xml.sax.handler.ContentHandler):
  def __init__(self):
    super().__init__()

    self.collect = False

  def startElement(self, name, attrs):
    # print(name)
    if name == 'body':
      self.collect = True

  def characters(self, content):
    if self.collect:
      print(content.decode('utf-16'))

  def endElement(self, name):
    if name == 'body':
      self.collect = False

with open('temp.chlsx', 'r', encoding='utf-16') as fp:
  handler = MyHandler()
  xml.sax.parse(fp, handler=handler)
