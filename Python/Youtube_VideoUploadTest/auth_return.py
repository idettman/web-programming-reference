#!/home/idettman/bin/python

import cgi
import cgitb

from oauth2client.file import Storage
from oauth2client.client import OAuth2WebServerFlow

from auth_data import AuthData


cgitb.enable()


print 'Content-Type: text/html'


form = cgi.FieldStorage()
code = form['code'].value


if code:
	flow = OAuth2WebServerFlow(client_id=AuthData.ClientId,
							   client_secret=AuthData.ClientSecret,
							   scope=AuthData.Scope,
							   redirect_uri=AuthData.RedirectUri)

	storage = Storage(AuthData.StorageFileName)
	credentials = flow.step2_exchange(code)
	storage.put(credentials)


	print "Status: 302 Moved"
	print "Location: %s" % 'auth.py'
	print
	print """\
	<html><body>
	</body></html>
	"""

else:

	print
	print '<html><body>'
	print """\
	<p>%s</p>
	</body></html>
	""" % ('ERROR',)