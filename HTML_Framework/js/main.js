/**
 * Created with IntelliJ IDEA.
 * User: Faygo
 * Date: 4/29/13
 * Time: 2:26 PM
 * To change this template use File | Settings | File Templates.
 */

var Site = {
	pageSelector: null,
	photoGallery: null,

	init: function ()
	{
		this.pageSelector = new PageSelector ();
		this.photoGallery = new PhotoGallery ();


		var imageList = $('#photos').get (0).firstChild.nodeValue;
		imageList = imageList.split (',');
		console.log (imageList, ':imgList');

		this.photoGallery.addImages (imageList);

		this.pageSelector.showPage ('home');
	}
}


function PageSelector () {}

PageSelector.prototype.showPage = function (pageID) {
	$('#'+pageID).show ();
}


function PhotoGallery () {}


PhotoGallery.prototype.photos = [];

PhotoGallery.prototype.addImages = function (imageList) {

	var BASE_PHOTO_DIRECTORY = 'images/photos/';

	var photo;
	for (var i = 0; i < imageList.length; i++) {
		photo = new Image ();
		photo.src = BASE_PHOTO_DIRECTORY + imageList[i];

		photo.onload = function () {
			console.log ('photo onload:', this);
		}

		this.photos.push (photo);
	}

}