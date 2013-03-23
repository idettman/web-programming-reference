#!/home/idettman/bin/python


import os
import cgitb
from string import Template
import httplib2

from oauth2client.file import Storage
from oauth2client.client import OAuth2WebServerFlow, AccessTokenCredentials

from auth_data import AuthData


cgitb.enable()

print 'Content-Type: text/html'


def redirect_authorize():
	flow = OAuth2WebServerFlow(client_id=AuthData.ClientId,
							   client_secret=AuthData.ClientSecret,
							   scope=AuthData.Scope,
							   redirect_uri=AuthData.RedirectUri)

	print "Status: 302 Moved"
	print "Location: %s" % flow.step1_get_authorize_url()
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


storage = Storage(AuthData.StorageFileName)
stored_credentials = storage.get()
access_token_credentials = AccessTokenCredentials(stored_credentials, os.environ.get("HTTP_USER_AGENT", "unknown"))

http = httplib2.Http()
http = access_token_credentials.authorize(http)


if access_token_credentials is None or access_token_credentials.invalid:
	redirect_authorize()
else:
	show_fileupload()