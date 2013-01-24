$(document).ready(function () {

	var detect = new DeviceDetect(),
		isMobile = detect.DetectMobileLong(),
		isTablet = detect.DetectTierTablet();

	// Show SWFs.
	$(this).find('[data-src]').each(function () {

		var path = $(this).attr('data-src'),
			id = $(this).attr('id');


		// Embed the SWF
		swfobject.embedSWF(path, id, '100%', '100%', "10.1.0", false, {}, {}, {}, function (e) {

			// Show the content
			$('.wrapper').show();

			// If we didn't load Flash, do some device detection to get the proper fallback
			if (!e.success) {

				if (isMobile) {
					$('.altContent.mobile').show();
				}
				else if (isTablet) {
					$('.altContent.tablet').show();
				}
				else {
					$('.altContent.desktop').show();
				}
			}


		});
	});
});


/**
	Facebook / Flash communication
 **/
(function(facebookAppId, facebookChannelUrl)
{

	window.flashFbApplication =	{

		fbLoggedIn: false,
		accessToken: null,
		flashInitialized: false,


		setFlashFbStatusLoggedIn: function ()
		{
			if (this.flashInitialized)
			{
				this.loadFbProfilePhoto();
				console.log("setFlashFbStatusLoggedIn: this.flashInitialized=true");
				$("#flashContent").get(0).facebookLoginStatus("loggedIn");
			}
			else
			{
				console.log("setFlashFbStatusLoggedIn: this.flashInitialized=false");
			}
		},


		setFlashFbLoggedIn: function ()
		{
			if (this.flashInitialized)
			{
				this.loadFbProfilePhoto();
				console.log("setFlashFbLoggedIn: this.flashInitialized=true");
				$("#flashContent").get(0).facebookLoginResult("loggedIn");
			}
			else
			{
				console.log("setFlashFbLoggedIn: this.flashInitialized=false");
			}
		},



		facebookJsSdkInitComplete: function ()
		{
			console.log("facebookJsSdkInitComplete");

			// init the FB JS SDK
			FB.init({
				appId: facebookAppId, // App ID from the App Dashboard
				channelUrl: facebookChannelUrl, // Channel File for x-domain communication
				status: true, // check the login status upon init?
				cookie: true, // set sessions cookies to allow your server to access the session?
				xfbml: true  // parse XFBML tags on this page?
			});

			FB.Event.subscribe("auth.login", this.logInComplete);
		},


		flashInitComplete: function ()
		{
			console.log("flashInitComplete");
			this.flashInitialized = true;
			FB.getLoginStatus(this.checkFbLogInStatusComplete);

			return false;
		},


		checkFbLogInStatusComplete: function (response)
		{
			console.log("checkFbLogInStatusComplete: status:" + response.status);


			if (response.status === "connected")
			{
				console.log("already authorized " + response.authResponse.accessToken);
				window.flashFbApplication.accessToken = response.authResponse.accessToken;
				window.flashFbApplication.fbLoggedIn = true;
				window.flashFbApplication.setFlashFbStatusLoggedIn();
			}
			else if (response.status === "not_authorized") {}
			else {}
		},


		logIn: function ()
		{
			console.log("logIn");
			FB.login(this.logInComplete, {scope: 'read_stream, publish_actions'});

			return false;
		},


		logInComplete: function (response)
		{
			console.log("logInComplete:response:" + response.status);

			if (response.status === "connected")
			{
				window.flashFbApplication.accessToken = response.authResponse.accessToken;
				window.flashFbApplication.fbLoggedIn = true;
				window.flashFbApplication.setFlashFbLoggedIn();
			}
		},


		loadFbProfilePhoto: function ()
		{
			console.log("loadFbProfilePhoto");
			FB.api("/me", this.loadFbProfilePhotoComplete);
		},


		loadFbProfilePhotoComplete: function(response)
		{
			console.log("loadFbProfilePhotoComplete");

			if (window.flashFbApplication.flashInitialized)
			{
				$("#flashContent").get(0).setFacebookUserPicture("http://graph.facebook.com/" + response.id + "/picture");
			}
		},



		postQuestionToFacebook: function (questionText)
		{
			console.log("postQuestionToFacebook: q=" + questionText);
			FB.api('/me/feed', 'post',
				{
					message: questionText,
					redirect_uri: 'http://www.sonicdrivein.com/',
					link: 'http://www.sonicdrivein.com/',
					picture: 'http://www.hookfilez.com/sonic_groundhog/2013-01-18/fb_share_thumb.jpg',
					name: 'Title Goes Here',
					caption: 'Caption Goes Here',
					description: 'Description Goes Here.'
				},
				this.postQuestionToFacebookComplete
			);

			return false;
		},


		postQuestionToFacebookComplete: function (response)
		{
			if (!response || response.error)
			{
				if (!response)
				{
					$("#flashContent").get(0).facebookPostResult("errorNoResponse");
				}
				else
				{
					if (response.error.type == "OAuthException")
					{
						// Passing "errorAutho" will notify flash that the fb user has been logged out, and update it's view accordingly
						$("#flashContent").get(0).facebookPostResult("errorLoggedOut");
					}
					else
					{
						$("#flashContent").get(0).facebookPostResult(response.error.type);
					}
				}
			}
			else
			{
				console.log("post to feed success : post id=" + response.id);
				$("#flashContent").get(0).facebookPostResult("success");
			}

			return false;
		},


		postQuestionToTwitter: function (questionText)
		{
			var shareUrl = 'http://www.sonicdrivein.com/';
			var targetAccount = '@sonicdrivein';
			var shareHashTags = '&hashtags=Predictathon,Sonic,Groundhog';

			if (questionText.indexOf(targetAccount) == -1)
			{
				questionText = targetAccount + " " + questionText;
			}

			console.log("postQuestionToTwitter: q=" + questionText);
			window.open ('https://twitter.com/intent/tweet?source=webclient&url='+shareUrl + shareHashTags + '&text=' + questionText, "twitterWindow", "height=450, width=500, top="+($(window).height()/2-225)+", left="+($(window).width()/2-250)+", status=1, toolbar=0, location=0, menubar=0, directories=0, scrollbars=0");
			$("#flashContent").get(0).twitterPostResult("success");

			return false;
		},


		shareApplicationOnFacebook: function (subject, shareText, shareUrl, shareImage, shareDescription)
		{
			FB.ui(
				{
					method: 'feed', name: subject, link: shareUrl, picture: shareImage, caption: shareText, description: shareDescription
				},
				function(response) {
					if (response && response.post_id) { } else { }
				}
			);

			return false;
		},


		shareApplicationOnTwitter: function (shareUrl, shareText, shareHashTags)
		{
			window.open ('https://twitter.com/intent/tweet?source=webclient&url='+shareUrl + shareHashTags + '&text=' + shareText, "twitterWindow", "height=450, width=500, top="+($(window).height()/2-225)+", left="+($(window).width()/2-250)+", status=1, toolbar=0, location=0, menubar=0, directories=0, scrollbars=0");

			return false;
		},


		shareApplicationByEmail: function (subject, shareUrl)
		{
			window.open("mailto:?subject="+subject+"&body="+shareUrl, "emailWindow", "height=450, width=500, top="+($(window).height()/2-225)+", left="+($(window).width()/2-250)+", status=1, toolbar=0, location=0, menubar=0, directories=0, scrollbars=0");

			return false;
		}

	};


	window.fbAsyncInit = this.flashFbApplication.facebookJsSdkInitComplete;


	// Load the SDK's source Asynchronously
	// Note that the debug version is being actively developed and might
	// contain some type checks that are overly strict.
	// Please report such bugs using the bugs tool.
	(function (d, debug)
	{
		var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
		if (d.getElementById(id)) {return;}
		js = d.createElement('script');
		js.id = id;
		js.async = true;
		js.src = "//connect.facebook.net/en_US/all" + (debug ? "/debug" : "") + ".js";
		ref.parentNode.insertBefore(js, ref);
	}(document, /*debug*/ false));

} (facebookAppId, facebookChannelUrl));