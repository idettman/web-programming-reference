var DeviceDetect;

(DeviceDetect = function () {

	/* *******************************************
	 // Copyright 2010-2012, Anthony Hand
	 //
	 // File version date: January 21, 2012
	 //		Update:
	 //		- Moved Windows Phone 7 to the iPhone Tier. WP7.5's IE 9-based browser is good enough now.
	 //		- Added a new variable for 2 versions of the new BlackBerry Bold Touch (9900 and 9930): deviceBBBoldTouch.
	 //		- Updated DetectBlackBerryTouch() to support the 2 versions of the new BlackBerry Bold Touch (9900 and 9930).
	 //		- Updated DetectKindle() to focus on eInk devices only. The Kindle Fire should be detected as a regular Android device.
	 //
	 // File version date: August 22, 2011
	 //		Update:
	 //		- Updated DetectAndroidTablet() to fix a bug introduced in the last fix! The true/false returns were mixed up.
	 //
	 // File version date: August 16, 2011
	 //		Update:
	 //		- Updated DetectAndroidTablet() to exclude Opera Mini, which was falsely reporting as running on a tablet device when on a phone.
	 //		- Updated the user agent (uagent) init technique to handle spiders and such with null values.
	 //
	 // File version date: August 7, 2011
	 //		Update:
	 //		- The Opera for Android browser doesn't follow Google's recommended useragent string guidelines, so some fixes were needed.
	 //		- Updated DetectAndroidPhone() and DetectAndroidTablet() to properly detect devices running Opera Mobile.
	 //		- Created 2 new methods: DetectOperaAndroidPhone() and DetectOperaAndroidTablet().
	 //		- Updated DetectTierIphone(). Removed the call to DetectMaemoTablet(), an obsolete mobile OS.
	 //
	 //
	 // LICENSE INFORMATION
	 // Licensed under the Apache License, Version 2.0 (the "License");
	 // you may not use this file except in compliance with the License.
	 // You may obtain a copy of the License at
	 //        http://www.apache.org/licenses/LICENSE-2.0
	 // Unless required by applicable law or agreed to in writing,
	 // software distributed under the License is distributed on an
	 // "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
	 // either express or implied. See the License for the specific
	 // language governing permissions and limitations under the License.
	 //
	 //
	 // ABOUT THIS PROJECT
	 //   Project Owner: Anthony Hand
	 //   Email: anthony.hand@gmail.com
	 //   Web Site: http://www.mobileesp.com
	 //   Source Files: http://code.google.com/p/mobileesp/
	 //
	 //   Versions of this code are available for:
	 //      PHP, JavaScript, Java, ASP.NET (C#), and Ruby
	 //
	 //
	 // WARNING:
	 //   These JavaScript-based device detection features may ONLY work
	 //   for the newest generation of smartphones, such as the iPhone,
	 //   Android and Palm WebOS devices.
	 //   These device detection features may NOT work for older smartphones
	 //   which had poor support for JavaScript, including
	 //   older BlackBerry, PalmOS, and Windows Mobile devices.
	 //   Additionally, because JavaScript support is extremely poor among
	 //   'feature phones', these features may not work at all on such devices.
	 //   For better results, consider using a server-based version of this code,
	 //   such as Java, APS.NET, PHP, or Ruby.
	 //
	 // *******************************************
	 */

//Optional: Store values for quickly accessing same info multiple times.
//Note: These values are not set automatically.
//Stores whether the device is an iPhone or iPod Touch.
	this.isIphone = false;
//Stores whether the device is an Android phone or multi-media player.
	this.isAndroidPhone = false;
//Stores whether is the Tablet (HTML5-capable, larger screen) tier of devices.
	this.isTierTablet = false;
//Stores whether is the iPhone tier of devices.
	this.isTierIphone = false;
//Stores whether the device can probably support Rich CSS, but JavaScript support is not assumed. (e.g., newer BlackBerry, Windows Mobile)
	this.isTierRichCss = false;
//Stores whether it is another mobile device, which cannot be assumed to support CSS or JS (eg, older BlackBerry, RAZR)
	this.isTierGenericMobile = false;

//Initialize some initial string variables we'll look for later.
	this.engineWebKit = "webkit";
	this.deviceIphone = "iphone";
	this.deviceIpod = "ipod";
	this.deviceIpad = "ipad";
	this.deviceMacPpc = "macintosh"; //Used for disambiguation

	this.deviceAndroid = "android";
	this.deviceGoogleTV = "googletv";
	this.deviceXoom = "xoom"; //Motorola Xoom
	this.deviceHtcFlyer = "htc_flyer"; //HTC Flyer

	this.deviceNuvifone = "nuvifone"; //Garmin Nuvifone

	this.deviceSymbian = "symbian";
	this.deviceS60 = "series60";
	this.deviceS70 = "series70";
	this.deviceS80 = "series80";
	this.deviceS90 = "series90";

	this.deviceWinPhone7 = "windows phone os 7";
	this.deviceWinMob = "windows ce";
	this.deviceWindows = "windows";
	this.deviceIeMob = "iemobile";
	this.devicePpc = "ppc"; //Stands for PocketPC
	this.enginePie = "wm5 pie";  //An old Windows Mobile

	this.deviceBB = "blackberry";
	this.vndRIM = "vnd.rim"; //Detectable when BB devices emulate IE or Firefox
	this.deviceBBStorm = "blackberry95"; //Storm 1 and 2
	this.deviceBBBold = "blackberry97"; //Bold 97x0 (non-touch)
	this.deviceBBBoldTouch = "blackberry 99"; //Bold 99x0 (touchscreen)
	this.deviceBBTour = "blackberry96"; //Tour
	this.deviceBBCurve = "blackberry89"; //Curve 2
	this.deviceBBTorch = "blackberry 98"; //Torch
	this.deviceBBPlaybook = "playbook"; //PlayBook tablet

	this.devicePalm = "palm";
	this.deviceWebOS = "webos"; //For Palm's line of WebOS devices
	this.deviceWebOShp = "hpwos"; //For HP's line of WebOS devices

	this.engineBlazer = "blazer"; //Old Palm browser
	this.engineXiino = "xiino";

	this.deviceKindle = "kindle"; //Amazon Kindle, eInk one.

//Initialize variables for mobile-specific content.
	this.vndwap = "vnd.wap";
	this.wml = "wml";

//Initialize variables for random devices and mobile browsers.
//Some of these may not support JavaScript
	this.deviceTablet = "tablet"; //Generic term for slate and tablet devices
	this.deviceBrew = "brew";
	this.deviceDanger = "danger";
	this.deviceHiptop = "hiptop";
	this.devicePlaystation = "playstation";
	this.deviceNintendoDs = "nitro";
	this.deviceNintendo = "nintendo";
	this.deviceWii = "wii";
	this.deviceXbox = "xbox";
	this.deviceArchos = "archos";

	this.engineOpera = "opera"; //Popular browser
	this.engineNetfront = "netfront"; //Common embedded OS browser
	this.engineUpBrowser = "up.browser"; //common on some phones
	this.engineOpenWeb = "openweb"; //Transcoding by OpenWave server
	this.deviceMidp = "midp"; //a mobile Java technology
	this.uplink = "up.link";
	this.engineTelecaQ = 'teleca q'; //a modern feature phone browser

	this.devicePda = "pda";
	this.mini = "mini";  //Some mobile browsers put 'mini' in their names.
	this.mobile = "mobile"; //Some mobile browsers put 'mobile' in their user agent strings.
	this.mobi = "mobi"; //Some mobile browsers put 'mobi' in their user agent strings.

//Use Maemo, Tablet, and Linux to test for Nokia's Internet Tablets.
	this.maemo = "maemo";
	this.linux = "linux";
	this.qtembedded = "qt embedded"; //for Sony Mylo and others
	this.mylocom2 = "com2"; //for Sony Mylo also

//In some UserAgents, the only clue is the manufacturer.
	this.manuSonyEricsson = "sonyericsson";
	this.manuericsson = "ericsson";
	this.manuSamsung1 = "sec-sgh";
	this.manuSony = "sony";
	this.manuHtc = "htc"; //Popular Android and WinMo manufacturer

//In some UserAgents, the only clue is the operator.
	this.svcDocomo = "docomo";
	this.svcKddi = "kddi";
	this.svcVodafone = "vodafone";

//Disambiguation strings.
	this.disUpdate = "update"; //pda vs. update


//Initialize our user agent string.
	this.uagent = "";
	if (navigator && navigator.userAgent)
		this.uagent = navigator.userAgent.toLowerCase();


//**************************
// Detects if the current device is an iPhone.
	this.DetectIphone = function () {
		if (this.uagent.search(this.deviceIphone) > -1) {
			//The iPad and iPod Touch say they're an iPhone! So let's disambiguate.
			if (this.DetectIpad() || this.DetectIpod())
				return false;
			//Yay! It's an iPhone!
			else
				return true;
		}
		else
			return false;
	}

//**************************
// Detects if the current device is an iPod Touch.
	this.DetectIpod = function () {
		if (this.uagent.search(this.deviceIpod) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current device is an iPad tablet.
	this.DetectIpad = function () {
		if (this.uagent.search(this.deviceIpad) > -1 && this.DetectWebkit())
			return true;
		else
			return false;
	}

//**************************
// Detects if the current device is an iPhone or iPod Touch.
	this.DetectIphoneOrIpod = function () {
		//We repeat the searches here because some iPods
		//  may report themselves as an iPhone, which is ok.
		if (this.uagent.search(this.deviceIphone) > -1 ||
			this.uagent.search(this.deviceIpod) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects *any* iOS device: iPhone, iPod Touch, iPad.
	this.DetectIos = function () {
		if (this.DetectIphoneOrIpod() || this.DetectIpad())
			return true;
		else
			return false;
	}

//**************************
// Detects *any* Android OS-based device: phone, tablet, and multi-media player.
// Also detects Google TV.
	this.DetectAndroid = function () {
		if ((this.uagent.search(this.deviceAndroid) > -1) || this.DetectGoogleTV())
			return true;
		//Special check for the HTC Flyer 7" tablet. It should report here.
		if (this.uagent.search(this.deviceHtcFlyer) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current device is a (small-ish) Android OS-based device
// used for calling and/or multi-media (like a Samsung Galaxy Player).
// Google says these devices will have 'Android' AND 'mobile' in user agent.
// Ignores tablets (Honeycomb and later).
	this.DetectAndroidPhone = function () {
		if (this.DetectAndroid() && (this.uagent.search(this.mobile) > -1))
			return true;
		//Special check for Android phones with Opera Mobile. They should report here.
		if (this.DetectOperaAndroidPhone())
			return true;
		//Special check for the HTC Flyer 7" tablet. It should report here.
		if (this.uagent.search(this.deviceHtcFlyer) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current device is a (self-reported) Android tablet.
// Google says these devices will have 'Android' and NOT 'mobile' in their user agent.
	this.DetectAndroidTablet = function () {
		//First, let's make sure we're on an Android device.
		if (!this.DetectAndroid())
			return false;

		//Special check for Opera Android Phones. They should NOT report here.
		if (this.DetectOperaMobile())
			return false;
		//Special check for the HTC Flyer 7" tablet. It should NOT report here.
		if (this.uagent.search(this.deviceHtcFlyer) > -1)
			return false;

		//Otherwise, if it's Android and does NOT have 'mobile' in it, Google says it's a tablet.
		if (this.uagent.search(this.mobile) > -1)
			return false;
		else
			return true;
	}


//**************************
// Detects if the current device is an Android OS-based device and
//   the browser is based on WebKit.
	this.DetectAndroidWebKit = function () {
		if (this.DetectAndroid() && this.DetectWebkit())
			return true;
		else
			return false;
	}


//**************************
// Detects if the current device is a GoogleTV.
	this.DetectGoogleTV = function () {
		if (this.uagent.search(this.deviceGoogleTV) > -1)
			return true;
		else
			return false;
	}


//**************************
// Detects if the current browser is based on WebKit.
	this.DetectWebkit = function () {
		if (this.uagent.search(this.engineWebKit) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is the Nokia S60 Open Source Browser.
	this.DetectS60OssBrowser = function () {
		if (this.DetectWebkit()) {
			if ((this.uagent.search(this.deviceS60) > -1 ||
				this.uagent.search(this.deviceSymbian) > -1))
				return true;
			else
				return false;
		}
		else
			return false;
	}

//**************************
// Detects if the current device is any Symbian OS-based device,
//   including older S60, Series 70, Series 80, Series 90, and UIQ, 
//   or other browsers running on these devices.
	this.DetectSymbianOS = function () {
		if (this.uagent.search(this.deviceSymbian) > -1 ||
			this.uagent.search(this.deviceS60) > -1 ||
			this.uagent.search(this.deviceS70) > -1 ||
			this.uagent.search(this.deviceS80) > -1 ||
			this.uagent.search(this.deviceS90) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is a 
// Windows Phone 7 device.
	this.DetectWindowsPhone7 = function () {
		if (this.uagent.search(this.deviceWinPhone7) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is a Windows Mobile device.
// Excludes Windows Phone 7 devices. 
// Focuses on Windows Mobile 6.xx and earlier.
	this.DetectWindowsMobile = function () {
		//Exclude new Windows Phone 7.
		if (this.DetectWindowsPhone7())
			return false;
		//Most devices use 'Windows CE', but some report 'iemobile'
		//  and some older ones report as 'PIE' for Pocket IE.
		if (this.uagent.search(this.deviceWinMob) > -1 ||
			this.uagent.search(this.deviceIeMob) > -1 ||
			this.uagent.search(this.enginePie) > -1)
			return true;
		//Test for Windows Mobile PPC but not old Macintosh PowerPC.
		if ((this.uagent.search(this.devicePpc) > -1) && !(this.uagent.search(this.deviceMacPpc) > -1))
			return true;
		//Test for Windwos Mobile-based HTC devices.
		if (this.uagent.search(this.manuHtc) > -1 &&
			this.uagent.search(this.deviceWindows) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is a BlackBerry of some sort.
// Includes the PlayBook.
	this.DetectBlackBerry = function () {
		if (this.uagent.search(this.deviceBB) > -1)
			return true;
		if (this.uagent.search(this.vndRIM) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is on a BlackBerry tablet device.
//    Example: PlayBook
	this.DetectBlackBerryTablet = function () {
		if (this.uagent.search(this.deviceBBPlaybook) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is a BlackBerry device AND uses a
//    WebKit-based browser. These are signatures for the new BlackBerry OS 6.
//    Examples: Torch. Includes the Playbook.
	this.DetectBlackBerryWebKit = function () {
		if (this.DetectBlackBerry() &&
			this.uagent.search(this.engineWebKit) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is a BlackBerry Touch
//    device, such as the Storm, Torch, and Bold Touch. Excludes the Playbook.
	this.DetectBlackBerryTouch = function () {
		if (this.DetectBlackBerry() &&
			((this.uagent.search(this.deviceBBStorm) > -1) ||
				(this.uagent.search(this.deviceBBTorch) > -1) ||
				(this.uagent.search(this.deviceBBBoldTouch) > -1)))
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is a BlackBerry OS 5 device AND
//    has a more capable recent browser. Excludes the Playbook.
//    Examples, Storm, Bold, Tour, Curve2
//    Excludes the new BlackBerry OS 6 and 7 browser!!
	this.DetectBlackBerryHigh = function () {
		//Disambiguate for BlackBerry OS 6 or 7 (WebKit) browser
		if (this.DetectBlackBerryWebKit())
			return false;
		if (this.DetectBlackBerry()) {
			if (this.DetectBlackBerryTouch() ||
				this.uagent.search(this.deviceBBBold) > -1 ||
				this.uagent.search(this.deviceBBTour) > -1 ||
				this.uagent.search(this.deviceBBCurve) > -1)
				return true;
			else
				return false;
		}
		else
			return false;
	}

//**************************
// Detects if the current browser is a BlackBerry device AND
//    has an older, less capable browser. 
//    Examples: Pearl, 8800, Curve1.
	this.DetectBlackBerryLow = function () {
		if (this.DetectBlackBerry()) {
			//Assume that if it's not in the High tier or has WebKit, then it's Low.
			if (this.DetectBlackBerryHigh() || this.DetectBlackBerryWebKit())
				return false;
			else
				return true;
		}
		else
			return false;
	}


//**************************
// Detects if the current browser is on a PalmOS device.
	this.DetectPalmOS = function () {
		//Most devices nowadays report as 'Palm',
		//  but some older ones reported as Blazer or Xiino.
		if (this.uagent.search(this.devicePalm) > -1 ||
			this.uagent.search(this.engineBlazer) > -1 ||
			this.uagent.search(this.engineXiino) > -1) {
			//Make sure it's not WebOS first
			if (this.DetectPalmWebOS())
				return false;
			else
				return true;
		}
		else
			return false;
	}

//**************************
// Detects if the current browser is on a Palm device
//   running the new WebOS.
	this.DetectPalmWebOS = function () {
		if (this.uagent.search(this.deviceWebOS) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is on an HP tablet running WebOS.
	this.DetectWebOSTablet = function () {
		if (this.uagent.search(this.deviceWebOShp) > -1 &&
			this.uagent.search(this.deviceTablet) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is a
//   Garmin Nuvifone.
	this.DetectGarminNuvifone = function () {
		if (this.uagent.search(this.deviceNuvifone) > -1)
			return true;
		else
			return false;
	}


//**************************
// Check to see whether the device is a 'smartphone'.
//   You might wish to send smartphones to a more capable web page
//   than a dumbed down WAP page. 
	this.DetectSmartphone = function () {
		if (this.DetectIphoneOrIpod()
			|| this.DetectAndroidPhone()
			|| this.DetectS60OssBrowser()
			|| this.DetectSymbianOS()
			|| this.DetectWindowsMobile()
			|| this.DetectWindowsPhone7()
			|| this.DetectBlackBerry()
			|| this.DetectPalmWebOS()
			|| this.DetectPalmOS()
			|| this.DetectGarminNuvifone())
			return true;

		//Otherwise, return false.
		return false;
	};

//**************************
// Detects if the current device is an Archos media player/Internet tablet.
	this.DetectArchos = function () {
		if (this.uagent.search(this.deviceArchos) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects whether the device is a Brew-powered device.
	this.DetectBrewDevice = function () {
		if (this.uagent.search(this.deviceBrew) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects the Danger Hiptop device.
	this.DetectDangerHiptop = function () {
		if (this.uagent.search(this.deviceDanger) > -1 ||
			this.uagent.search(this.deviceHiptop) > -1)
			return true;
		else
			return false;
	}

//**************************
// Detects if the current device is on one of 
// the Maemo-based Nokia Internet Tablets.
	this.DetectMaemoTablet = function () {
		if (this.uagent.search(this.maemo) > -1)
			return true;
		//For Nokia N810, must be Linux + Tablet, or else it could be something else.
		if ((this.uagent.search(this.linux) > -1)
			&& (this.uagent.search(this.deviceTablet) > -1)
			&& !this.DetectWebOSTablet()
			&& !this.DetectAndroid())
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is a Sony Mylo device.
	this.DetectSonyMylo = function () {
		if (this.uagent.search(this.manuSony) > -1) {
			if (this.uagent.search(this.qtembedded) > -1 ||
				this.uagent.search(this.mylocom2) > -1)
				return true;
			else
				return false;
		}
		else
			return false;
	}

//**************************
// Detects if the current browser is Opera Mobile or Mini.
	this.DetectOperaMobile = function () {
		if (this.uagent.search(this.engineOpera) > -1) {
			if (this.uagent.search(this.mini) > -1 ||
				this.uagent.search(this.mobi) > -1)
				return true;
			else
				return false;
		}
		else
			return false;
	}

//**************************
// Detects if the current browser is Opera Mobile 
// running on an Android phone.
	this.DetectOperaAndroidPhone = function () {
		if ((this.uagent.search(this.engineOpera) > -1) &&
			(this.uagent.search(this.deviceAndroid) > -1) &&
			(this.uagent.search(this.mobi) > -1))
			return true;
		else
			return false;
	}

//**************************
// Detects if the current browser is Opera Mobile 
// running on an Android tablet.
	this.DetectOperaAndroidTablet = function () {
		if ((this.uagent.search(this.engineOpera) > -1) &&
			(this.uagent.search(this.deviceAndroid) > -1) &&
			(this.uagent.search(this.deviceTablet) > -1))
			return true;
		else
			return false;
	}

//**************************
// Detects if the current device is a Sony Playstation.
	this.DetectSonyPlaystation = function () {
		if (this.uagent.search(this.devicePlaystation) > -1)
			return true;
		else
			return false;
	};

//**************************
// Detects if the current device is a Nintendo game device.
	this.DetectNintendo = function () {
		if (this.uagent.search(this.deviceNintendo) > -1 ||
			this.uagent.search(this.deviceWii) > -1 ||
			this.uagent.search(this.deviceNintendoDs) > -1)
			return true;
		else
			return false;
	};

//**************************
// Detects if the current device is a Microsoft Xbox.
	this.DetectXbox = function () {
		if (this.uagent.search(this.deviceXbox) > -1)
			return true;
		else
			return false;
	};

//**************************
// Detects if the current device is an Internet-capable game console.
	this.DetectGameConsole = function () {
		if (this.DetectSonyPlaystation())
			return true;
		if (this.DetectNintendo())
			return true;
		if (this.DetectXbox())
			return true;
		else
			return false;
	};

//**************************
// Detects if the current device is an Amazon Kindle (eInk devices only).
// Note: For the Kindle Fire, use the normal Android methods.
	this.DetectKindle = function () {
		if (this.uagent.search(this.deviceKindle) > -1 && !this.DetectAndroid())
			return true;
		else
			return false;
	}

//**************************
// Detects if the current device is a mobile device.
//  This method catches most of the popular modern devices.
//  Excludes Apple iPads and other modern tablets.
	this.DetectMobileQuick = function () {
		//Let's exclude tablets.
		if (this.DetectTierTablet())
			return false;

		//Most mobile browsing is done on smartphones
		if (this.DetectSmartphone())
			return true;

		if (this.uagent.search(this.deviceMidp) > -1 ||
			this.DetectBrewDevice())
			return true;

		if (this.DetectOperaMobile())
			return true;

		if (this.uagent.search(this.engineNetfront) > -1)
			return true;
		if (this.uagent.search(this.engineUpBrowser) > -1)
			return true;
		if (this.uagent.search(this.engineOpenWeb) > -1)
			return true;

		if (this.DetectDangerHiptop())
			return true;

		if (this.DetectMaemoTablet())
			return true;
		if (this.DetectArchos())
			return true;

		if ((this.uagent.search(this.devicePda) > -1) && !(this.uagent.search(this.disUpdate) > -1))
			return true;
		if (this.uagent.search(this.mobile) > -1)
			return true;

		if (this.DetectKindle())
			return true;

		return false;
	};


//**************************
// Detects in a more comprehensive way if the current device is a mobile device.
	this.DetectMobileLong = function () {
		if (this.DetectMobileQuick())
			return true;
		if (this.DetectGameConsole())
			return true;
		if (this.DetectSonyMylo())
			return true;

		//Detect for certain very old devices with stupid useragent strings.
		if (this.uagent.search(this.manuSamsung1) > -1 ||
			this.uagent.search(this.manuSonyEricsson) > -1 ||
			this.uagent.search(this.manuericsson) > -1)
			return true;

		if (this.uagent.search(this.svcDocomo) > -1)
			return true;
		if (this.uagent.search(this.svcKddi) > -1)
			return true;
		if (this.uagent.search(this.svcVodafone) > -1)
			return true;


		return false;
	};


//*****************************
// For Mobile Web Site Design
//*****************************

//**************************
// The quick way to detect for a tier of devices.
//   This method detects for the new generation of
//   HTML 5 capable, larger screen tablets.
//   Includes iPad, Android (e.g., Xoom), BB Playbook, WebOS, etc.
	this.DetectTierTablet = function () {
		if (this.DetectIpad()
			|| this.DetectAndroidTablet()
			|| this.DetectBlackBerryTablet()
			|| this.DetectWebOSTablet())
			return true;
		else
			return false;
	};

//**************************
// The quick way to detect for a tier of devices.
//   This method detects for devices which can 
//   display iPhone-optimized web content.
//   Includes iPhone, iPod Touch, Android, Windows Phone 7, WebOS, etc.
	this.DetectTierIphone = function () {
		if (this.DetectIphoneOrIpod())
			return true;
		if (this.DetectAndroidPhone())
			return true;
		if (this.DetectBlackBerryWebKit() && this.DetectBlackBerryTouch())
			return true;
		if (this.DetectWindowsPhone7())
			return true;
		if (this.DetectPalmWebOS())
			return true;
		if (this.DetectGarminNuvifone())
			return true;
		else
			return false;
	};

//**************************
// The quick way to detect for a tier of devices.
//   This method detects for devices which are likely to be 
//   capable of viewing CSS content optimized for the iPhone, 
//   but may not necessarily support JavaScript.
//   Excludes all iPhone Tier devices.
	this.DetectTierRichCss = function () {
		if (this.DetectMobileQuick()) {
			if (this.DetectTierIphone())
				return false;

			//The following devices are explicitly ok.
			if (this.DetectWebkit())
				return true;
			if (this.DetectS60OssBrowser())
				return true;

			//Note: 'High' BlackBerry devices ONLY
			if (this.DetectBlackBerryHigh())
				return true;

			//Older Windows 'Mobile' isn't good enough for iPhone Tier.
			if (this.DetectWindowsMobile())
				return true;

			if (this.uagent.search(this.engineTelecaQ) > -1)
				return true;

			else
				return false;
		}
		else
			return false;
	};

//**************************
// The quick way to detect for a tier of devices.
//   This method detects for all other types of phones,
//   but excludes the iPhone and RichCSS Tier devices.
// NOTE: This method probably won't work due to poor
//  support for JavaScript among other devices. 
	this.DetectTierOtherPhones = function () {
		if (this.DetectMobileLong()) {
			//Exclude devices in the other 2 categories
			if (this.DetectTierIphone() || this.DetectTierRichCss())
				return false;

			//Otherwise, it's a YES
			else
				return true;
		}
		else
			return false;
	};


//**************************
// Initialize Key Stored Values.
	this.InitDeviceScan = function () {
		//We'll use these 4 variables to speed other processing. They're super common.
		this.isIphone = this.DetectIphoneOrIpod();
		this.isAndroidPhone = this.DetectAndroidPhone();
		this.isTierIphone = this.DetectTierIphone();
		this.isTierTablet = this.DetectTierTablet();

		//Optional: Comment these out if you don't need them.
		this.isTierRichCss = this.DetectTierRichCss();
		this.isTierGenericMobile = this.DetectTierOtherPhones();
	};

//Now, run the initialization method.
	this.InitDeviceScan();

	return this;

});
