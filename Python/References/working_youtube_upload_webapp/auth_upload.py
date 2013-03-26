#!/home/idettman/bin/python

import os
import cgi
import cgitb
import time
import random
import httplib

import httplib2
from apiclient.errors import HttpError
from apiclient.http import MediaFileUpload
from oauth2client.file import Storage
from oauth2client.client import OAuth2WebServerFlow
from apiclient.discovery import build

from auth_data import AuthData

cgitb.enable()


print 'Content-Type: text/html'


def upload_video(credentials, uploaded_filepath):

	filename = uploaded_filepath
	title = 'Test Title'
	description = 'Test Description'
	category = '22'
	keywords = 'python,developer'
	privacyStatus = 'unlisted'


	http = httplib2.Http()
	http = credentials.authorize(http)
	youtube = build('youtube', 'v3', http=http)


	insert_request = youtube.videos().insert(
		part="snippet,status",
		body=dict(
			snippet=dict(
				title=title,
				description=description,
				tags=keywords.split(','),
				categoryId=category
			),
			status=dict(
				privacyStatus=privacyStatus
			)
		),
		media_body=MediaFileUpload(filename, chunksize=-1, resumable=True)
	)
	resumable_upload(insert_request, title)


def resumable_upload(insert_request, video_title):

	print
	print """\
	<html><body>
	"""

	response = None
	error = None
	retry = 0
	while response is None:
		try:
			print "Uploading file..."
			status, response = insert_request.next_chunk()
			if 'id' in response:
				print "'%s' (video id: %s) was successfully uploaded." % (video_title, response['id'])
			else:
				exit("The upload failed with an unexpected response: %s" % response)
		except HttpError, e:
			if e.resp.status in RETRIABLE_STATUS_CODES:
				error = "A retriable HTTP error %d occurred:\n%s" % (e.resp.status, e.content)
			else:
				raise
		except RETRIABLE_EXCEPTIONS, e:
			error = "A retriable error occurred: %s" % e

		if error is not None:
			print error
			retry += 1
			if retry > MAX_RETRIES:
				exit("No longer attempting to retry.")
			max_sleep = 2 ** retry
			sleep_seconds = random.random() * max_sleep
			print "Sleeping %f seconds and then retrying..." % sleep_seconds
			time.sleep(sleep_seconds)
	print """
		</body></html>
		"""


def redirect_authorize():
	auth_uri = flow.step1_get_authorize_url()
	print "Status: 302 Moved"
	print "Location: %s" % auth_uri
	print
	print """\
	<html><body>
	</body></html>
	"""


def show_filepath_error():
	print
	print """\
	<html><body>Error: Filepath is empty
	</body></html>
	"""


httplib2.RETRIES = 1
MAX_RETRIES = 10
RETRIABLE_EXCEPTIONS = (httplib2.HttpLib2Error, IOError, httplib.NotConnected,
						httplib.IncompleteRead, httplib.ImproperConnectionState,
						httplib.CannotSendRequest, httplib.CannotSendHeader,
						httplib.ResponseNotReady, httplib.BadStatusLine)

RETRIABLE_STATUS_CODES = [500, 502, 503, 504]


form = cgi.FieldStorage()
fileitem = form['file']
complete_filepath = None


if fileitem.filename:
	fn = os.path.basename(fileitem.filename)
	open('upload_cache/' + fn, 'wb').write(fileitem.file.read())
	complete_filepath = 'upload_cache/' + fn
	message = 'The file "' + fn + '" was uploaded successfully'
else:
	message = 'No file was uploaded'


flow = OAuth2WebServerFlow(client_id=AuthData.ClientId,
						   client_secret=AuthData.ClientSecret,
						   scope=AuthData.Scope,
						   redirect_uri=AuthData.RedirectUri)


storage = Storage(AuthData.StorageFileName)
auth_credentials = storage.get()


if auth_credentials is None or auth_credentials.invalid:
	redirect_authorize()
else:
	if complete_filepath is not None:
		upload_video(auth_credentials, complete_filepath)
	else:
		show_filepath_error()