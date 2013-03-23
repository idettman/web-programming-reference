import cgitb; cgitb.enable()

import webapp2

from google.appengine.api import images


class MainPage(webapp2.RequestHandler):
	def get(self):
																
		self.response.out.write("""
		  <html>
			<body>
			  <form action="/detectbarcode" method="post">
				<div><textarea name="content" rows="3" cols="60"></textarea></div>
				<div><input type="submit" value="Sign Guestbook"></div>
			  </form>
			  <div>
				  <object id="flash1" data="swf/WebcamBarcodeScanner.swf" height="250" width="300" type="application/x-shockwave-flash">
					<param name="movie" value="swf/WebcamBarcodeScanner.swf" />
				  </object>
			   </div>
			</body>
		  </html>""")


class DetectBarcode(webapp2.RequestHandler):
	def post(self):
				
		form = self.request.POST['webcambytes']
		print form
		
		if form.file:
			linecount = 0
			while 1:
				line = form.file.readline()
				
				print linecount
				print type(line)
				print line
				
				if not line: break
				linecount += 1
		
		
#		if "webcambytes" not in form:
#			print "<H1>Error</H1>"
#			print "Please fill in the webcambytes fields."
#			return
#		print "<p>addr:", form["webcambytes"].value
		
		print '<p><img src="img/test.jpg"></img></p>'
		
#		webcam_bytes = self.request.get('webcambytes')
		webcam_bytes = self.request.POST['webcambytes']
				
		print type(webcam_bytes)
		
#		webcam_bytearray = bytearray(webcam_bytes)
#		print type(webcam_bytearray)
		
		self.response.out.write('<html><body>You wrote:<pre>')
		self.response.out.write('<img src="%s"></img>' % webcam_bytes)
#		self.response.out.write('<img src="%s"></img>' % webcam_bytearray)
		self.response.out.write('</pre></body></html>')
				

app = webapp2.WSGIApplication([
	('/', MainPage),
	('/detectbarcode', DetectBarcode)
],
	debug=True)

