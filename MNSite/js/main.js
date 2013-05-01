

var Main = {

	init: function ()
	{
//		var imageList = $('#photos').get (0).firstChild.nodeValue;

		$(function () {

//			$('#photoGallery').css ('display', 'block');

			$('#photos').responsiveSlides({
				auto: false,
				fade: 500,
				nav: true,
				pager: true,
				prevText: 'Previous',
				nextText: 'Next',
				manualControls: '#photos-pager'
			});

			$.hideAllExcept('.tab', '.box');
		});



	}
}