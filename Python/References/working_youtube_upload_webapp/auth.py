#!/home/idettman/bin/python

import cgitb
from string import Template

from oauth2client.file import Storage
from oauth2client.client import OAuth2WebServerFlow

from auth_data import AuthData


cgitb.enable()

print 'Content-Type: text/html'


def redirect_authorize():
	auth_uri = flow.step1_get_authorize_url()
	print "Status: 302 Moved"
	print "Location: %s" % auth_uri
	print
	print """\
	<html><body>
	</body></html>
	"""


def show_fileupload():
	print

	values = {
		'upload_handler': 'auth_upload.py'
	}
	temp = Template(open('upload_video.html').read())
	print temp.substitute(values)


flow = OAuth2WebServerFlow(client_id=AuthData.ClientId,
						   client_secret=AuthData.ClientSecret,
						   scope=AuthData.Scope,
						   redirect_uri=AuthData.RedirectUri)

storage = Storage(AuthData.StorageFileName)
credentials = storage.get()

if credentials is None or credentials.invalid:
	redirect_authorize()
else:
	show_fileupload()