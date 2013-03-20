import cgitb
cgitb.enable()

import webapp2

from google.appengine.api.images import Image



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
		
#		form = self.request.POST['webcambytes']
#		print form
		
#		if form.file:
#			linecount = 0
#			while 1:
#				line = form.file.readline()
#				if not line: break
#				linecount += 1
		
		webcam_img = Image(self.request.get('webcambytes'))
		self.response.out.write('<html><body>Response:<pre>')
		self.response.out.write('<div>%s %s</div>' % (webcam_img.width, webcam_img.height))
		self.response.out.write('</pre></body></html>')
		

app = webapp2.WSGIApplication([
	('/', MainPage),
	('/detectbarcode', DetectBarcode)
], debug=True)