#!/home/idettman/bin/python

import os
import cgi
import cgitb

cgitb.enable()
form = cgi.FieldStorage()
fileitem = form['file']


# Test if the file was uploaded
if fileitem.filename:
	# strip leading path from file name to avoid directory traversal attacks
	fn = os.path.basename(fileitem.filename)
	open('upload_cache/' + fn, 'wb').write(fileitem.file.read())
	message = 'The file "' + fn + '" was uploaded successfully'
else:
	message = 'No file was uploaded'

print """\
Content-Type: text/html\n
<html><body>
<p>%s</p>
</body></html>
""" % (message,)


