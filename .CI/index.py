import markdown, sys
import xml.etree.ElementTree as ET
xml = "<xml>" + markdown.markdown(open('README.md', encoding="utf-8").read(), extensions=['markdown.extensions.tables']) + "</xml>"
root = ET.fromstring(xml)
for elem in root.findall('.//table'):
  f = open("index.html", "w")
  f.write("<html>")
  f.write(ET.tostring(elem).decode('utf-8'))
  f.write("</html>")
  sys.exit(0)
sys.exit(1)
