/*globals $ */

$(function () {
	var s = null,

		AnimationFillCode = {
			settings : {
				field: $('#code'),
				btn: $('#submit'),
				currentValue: null,
				mwValue: null,
				sValue: null,
				complete: "",
				startWith: null,
				atValue1: null,
				atValue2: null,
				atValue3: null,
				atValue4: null,
				fieldValue: null,
				phMessage: 'Paste your single-vendor CSS3 keyframe animations code here, then press the \'Fill My Animation Code\' button to fill in the code for the other browsers, plus standard syntax.',
				helpBtn: null,
				demoBtn: null,
				closeHelp: null,
				closeDemo: null,

				venStart: '',
				ven1: '',
				ven2: '',
				ven3: '',
				venStartRegEx: null,
				ven1RegEx: null,
				ven2RegEx: null,
				ven3RegEx: null,
				myChunkCode: null,
				myBrackets: [],
				myBracketBreak: [],
				myBrackets2: [],
				venProps1: '',
				venProps2: '',
				venProps3: '',
				venPropsS: '',
				myAnimChunk: '',

				helpContent: $('#helpContent'),
				demoContent: $('#demoContent'),
				hGroup: $('hgroup'),
				error: $('#error'),
				congrats: $('#congrats'),
				errorMsg0: '<p>Before submitting, select which browser you\'re starting with (i.e. webkit, moz, etc).</p>',
				errorMsg1: '<p>Trigger happy much? Enter some code before submitting.</p>',
				errorMsg2: '<p>Are you sure that\'s CSS3 animation code? That code is whack. Try again.</p>',
				errorMsg3: '<p>It looks like this code already has all the necessary syntax, or else you\'ve selected the wrong radio button. Make sure you paste animation code that uses only one vendor prefix, then select the correct option.</p>',
				congratsMsg: '<p>Your animation code has been filled! &nbsp; &nbsp; <a href="#" onclick="selectText(); return false;">Click to Select Text</a></p>',
				speed: 1000,
				foo: 'bar'
			},

			init: function () {

				s = this.settings;

				s.helpContent.append('<a href="#" class="closeHelp" id="closeHelp">X</a>');
				$('<div class="top-box" id="error"></div>').insertAfter(s.helpContent);
				$('<div class="top-box" id="congrats"></div>').insertAfter(s.helpContent);
				$('<a href="#" class="help" id="btnHelp" title="What is this Tool?">?</a>').insertAfter(s.hGroup);

				s.demoContent.append('<a href="#" class="closeHelp" id="closeDemo">X</a>');
				$('<div class="top-box" id="error"></div>').insertAfter(s.demoContent);
				$('<div class="top-box" id="congrats"></div>').insertAfter(s.demoContent);
				$('<a href="http://www.youtube.com/watch?v=araO0Vli-j4" class="play" id="btnDemo" title="Watch a Screencast Demo">Play</a>').insertAfter(s.hGroup);
				$('.top-box').slideUp(0);

				s.btn.bind('click', function () {
					s.field.removeClass('bg');
					s.field.removeClass('bgerror');
					if (!$('input:radio[name=startWith]:checked').val()) {
						AnimationFillCode.doErrorMsg(0);
						s.field.addClass('bgerror');
					} else {

						if (!s.field.val() || s.field.val() === s.phMessage) {
							AnimationFillCode.doErrorMsg(1);
							s.field.addClass('bgerror');
						} else {
							s.currentValue = s.field.val();
							AnimationFillCode.doCheckCode();
						}

					}

				});

				//if (!Modernizr.input.placeholder) {
				//this.polyfillPlaceholder();
				//} else {
					//this.blurCleared();
				//}

				this.doHelpButton();
				this.doDemoButton();
			},

			doCheckCode: function () {
				s = this.settings;

				s.startWith = $('input:radio[name=startWith]:checked').val();

				switch (s.startWith) {
				case "webkit":
					s.atValue1 = 'moz';
					s.atValue2 = 'o';
					break;

				case "moz":
					s.atValue1 = 'webkit';
					s.atValue2 = 'o';
					break;

				case "o":
					s.atValue1 = 'webkit';
					s.atValue2 = 'moz';
					break;

				default:
					s.atValue1 = 'moz';
					s.atValue2 = 'o';
					break;
				}

				if ((s.currentValue.search("@-" + s.atValue1 + "-keyframes") === -1) && (s.currentValue.search("@-" + s.atValue2 + "-keyframes") === -1)) {

					if (s.currentValue.search('keyframes') !== -1) {

						if (s.currentValue.search('{') !== -1) {
							AnimationFillCode.doFill(s.field.val(), s.startWith, s.atValue1, s.atValue2);
						} else {
							AnimationFillCode.doErrorMsg(2);
							s.field.addClass('bgerror');
						}

					} else {
						AnimationFillCode.doErrorMsg(2);
						s.field.addClass('bgerror');
					}

				} else {
					AnimationFillCode.doErrorMsg(3);
					s.field.addClass('bgerror');
				}
			},

			doFill: function (val, ven, ven1, ven2) {
				s = this.settings;
				var i, j, k;
				s.helpContent.slideUp(s.speed);

				s.myChunkCode = val.replace(/@-/g, "||||@-");
				s.myChunkCode = s.myChunkCode.replace(/}\s*}/g, "||||}\n\n}");
				s.myChunkCode = s.myChunkCode.split("||||");

				s.venStart = "-" + ven + "-";
				s.ven1 = "-" + ven1 + "-";
				s.ven2 = "-" + ven2 + "-";
				s.venStartRegEx = new RegExp("@" + s.venStart + "keyframes", "g");
				s.ven1RegEx = "@" + s.ven1 + "keyframes";
				s.ven2RegEx = "@" + s.ven2 + "keyframes";

				// complete code, broken up here
				for (i = 0; i < s.myChunkCode.length; i += 1) {

					// deal with the non-@keyframes part of the code here
					if (s.myChunkCode[i].indexOf("@-") === -1) {

						s.myBrackets = s.myChunkCode[i].replace(/{/g, "||||{");
						s.myBrackets = s.myBrackets.replace(/}/g, "||||}");
                        s.myBrackets = s.myBrackets.split("||||");

						for (j = 0; j < s.myBrackets.length; j += 1) {

							if (s.myBrackets[j].indexOf(s.venStart + "animation") !== -1) {

								// do stuff with the vendor properties here

								s.myBrackets2 = s.myBrackets[j].split(";");

								for (k = 0; k < s.myBrackets2.length; k += 1) {

									if (s.myBrackets2[k].indexOf(s.venStart + "animation") !== -1) {
										s.venProps1 += s.myBrackets2[k].replace(s.venStart + "animation", s.ven1 + "animation") + ";";
										s.venProps2 += s.myBrackets2[k].replace(s.venStart + "animation", s.ven2 + "animation") + ";";
										s.venPropsS += s.myBrackets2[k].replace(s.venStart + "animation", "animation") + ";";
									}

								}

								s.myBrackets[j] = s.myBrackets[j] + s.venProps1.replace("{", "") + "\n" + s.venProps2.replace("{", "") + "\n" + s.venPropsS.replace("{", "") + "\n";

								s.venProps1 = "";
								s.venProps2 = "";
								s.venPropsS = "";

							}

						}

						s.myChunkCode[i] = s.myBrackets.join('');

					// otherwise, deal with the @keyframes part of the code here
					} else {

						s.myAnimChunk = s.myChunkCode[i].replace(s.venStartRegEx, s.ven1RegEx);
						s.myAnimChunk = s.myAnimChunk + "}\n\n}\n\n" + s.myChunkCode[i].replace(s.venStartRegEx, s.ven2RegEx);
						s.myAnimChunk = s.myAnimChunk + "}\n\n}\n\n" + s.myChunkCode[i].replace(s.venStartRegEx, "@keyframes");
						s.myChunkCode[i] = s.myChunkCode[i] + "}\n\n}\n\n" + s.myAnimChunk;

					}

				}

				s.complete = s.myChunkCode.join('');

				s.complete = s.complete.replace("/* try this code! */\n\n", "");

				s.field.val(s.complete);
				s.complete = "";
				this.doCongrats();
			},

			polyfillPlaceholder: function () {

				s = this.settings;
				s.field.addClass('ph');

				s.field.val(s.phMessage);

				s.fieldValue = s.field.val;
				s.field.focus(function () {
					if (s.field.val() === s.phMessage) {
						s.field.val('');
						s.field.removeClass('bg');
						s.field.removeClass('ph');
					} else {
						s.field.removeClass('bg');
					}
				});

				s.field.blur(function () {
					if (s.field.val() === '') {
						s.congrats.slideUp(s.speed);
						s.field.val(s.phMessage);
						s.field.addClass('ph');
					}
				});

			},

			blurCleared: function () {

				s = this.settings;

				s.field.blur(function () {
					if (s.field.val() === '') {
						s.congrats.slideUp(s.speed);
					}
				});

			},

			doHelpButton: function () {

				s = this.settings;
				s.error = $('#congrats');
				s.closeHelp = $('#closeHelp');
				s.helpBtn = $('#btnHelp');

				s.helpBtn.bind('click', function () {
					s.helpContent.slideToggle(s.speed);
					s.demoContent.slideUp(s.speed);
					s.congrats.slideUp(s.speed);
					AnimationFillCode.removeError();
					return false;
				});

				s.closeHelp.bind('click', function () {
					s.helpContent.slideUp(s.speed);
					s.demoContent.slideUp(s.speed);
					s.congrats.slideUp(s.speed);
					AnimationFillCode.removeError();
					return false;
				});

			},

			doDemoButton: function () {
				s = this.settings;
				s.error = $('#congrats');
				s.closeDemo = $('#closeDemo');
				s.demoBtn = $('#btnDemo');

				s.demoBtn.bind('click', function () {
					s.demoContent.slideToggle(s.speed);
					s.helpContent.slideUp(s.speed);
					s.congrats.slideUp(s.speed);
					AnimationFillCode.removeError();
					return false;
				});

				s.closeDemo.bind('click', function () {
					s.helpContent.slideUp(s.speed);
					s.demoContent.slideUp(s.speed);
					s.congrats.slideUp(s.speed);
					AnimationFillCode.removeError();
					return false;
				});
			},

			doErrorMsg: function (e) {

				s = this.settings;
				s.error = $('#error');
				s.congrats = $('#congrats');

				s.helpContent.slideUp(s.speed);
				s.congrats.slideUp(s.speed);

				switch (e) {
				case 0:
					s.error.html(s.errorMsg0);
					break;

				case 1:
					s.error.html(s.errorMsg1);
					break;

				case 2:
					s.error.html(s.errorMsg2);
					break;

				case 3:
					s.error.html(s.errorMsg3);
					break;
				}

				s.error.slideDown(s.speed);

				s.field.focus(function () {
					AnimationFillCode.removeError();
				});

			},

			doCongrats: function () {

				s = this.settings;
				s.error = $('#error');
				s.congrats = $('#congrats');
				s.field.addClass('bg');

				s.error.slideUp(s.speed);
				s.congrats.html(s.congratsMsg);
				s.congrats.slideDown(s.speed);
			},

			removeError: function () {

				s = this.settings;
				s.error = $('#error');

				s.error.slideUp(s.speed);

			}

		};

	AnimationFillCode.init();

});

function selectText() {
	$('#code').select();
}