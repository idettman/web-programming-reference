/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/29/13
 * Time: 4:24 PM
 */
package ashframework.game
{
	import ashframework.game.components.GameState;

	import away3d.containers.View3D;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.textures.BitmapCubeTexture;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;


	public class GameContainer extends Sprite
	{
		//engine variables
		private var _view:View3D;

		//scene variables
		private var _cameraLightPicker:StaticLightPicker;
		private var _lightPicker:StaticLightPicker;
		private var _cubeMap:BitmapCubeTexture;

		/*
		 private var _invawayders : GameController;
		 protected var _saveStateManager : SaveStateManager;
		 protected var _stageProperties : StageProperties;
		 */

		//interaction variables
		private var _showingMouse:Boolean = true;

		//hud variables
		private var _hudContainer:Sprite;
		private var _scoreText:TextField;
		private var _livesText:TextField;
		private var _restartButton:MovieClip;
		private var _pauseButton:MovieClip;

		//popup variables
		private var _activePopUp:MovieClip;
		private var _popUpContainer:Sprite;
		private var _splashPopUp:MovieClip;
		private var _playButton:MovieClip;
		private var _pausePopUp:MovieClip;
		private var _resumeButton:MovieClip;
		private var _gameOverPopUp:MovieClip;
		private var _goScoreText:TextField;
		private var _goHighScoreText:TextField;
		private var _playAgainButton:MovieClip;
		private var _liveIconsContainer:Sprite;
		private var _crossHair:Sprite;


		public function GameContainer ()
		{
			super ();
			init ();
		}


		public function init ():void
		{
			initStage ();
			initEngine ();
			initScene ();
			initHUD ();
			initGame ();
			addListeners ();
		}


		private function initStage ():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}


		private function initEngine ():void
		{
			_view = new View3D ();
			_view.camera.lens.near = 50;
			_view.camera.lens.far = 100000;
			_view.camera.z = -2000;
			addChild (_view);

			// add awaystats if in debug mode
			/*if( GameSettings.debugMode ) {
			 addChild( new AwayStats( _view ) );
			 _view.scene.addChild( new Trident() );
			 }*/
		}


		private function initScene ():void
		{
			// create skybox texture
			/*_cubeMap = new BitmapCubeTexture (
			 new SkyboxImagePosX ().bitmapData, new SkyboxImageNegX ().bitmapData,
			 new SkyboxImagePosY ().bitmapData, new SkyboxImageNegY ().bitmapData,
			 new SkyboxImagePosZ ().bitmapData, new SkyboxImageNegZ ().bitmapData
			 );

			 var cubeMaterial:SkyBoxMaterial = new SkyBoxMaterial (_cubeMap);
			 cubeMaterial.bothSides = true;
			 var cube:Mesh = new Mesh (new CubeGeometry (100000, 100000, 100000), cubeMaterial);
			 _view.scene.addChild (cube);*/

			// Init starfield environment map here

		}


		private function initHUD ():void
		{
			// initialise the HUD container
			_hudContainer = new Sprite ();
			addChild (_hudContainer);

			// initialise the score text
			/*var scoreClip:CustomTextField = new CustomTextField();
			 _scoreText = scoreClip.tf;
			 _hudContainer.addChild( _scoreText );

			 // initialise the lives text
			 var livesClip:CustomTextField = new CustomTextField();
			 _livesText = livesClip.tf;
			 _hudContainer.addChild( _livesText );


			 // initialise the lives icons
			 _liveIconsContainer = new Sprite();
			 _hudContainer.addChild( _liveIconsContainer );
			 for( var i:uint; i < GameSettings.playerLives; i++ ) {
			 var live:Sprite = new InvawayderLive();
			 live.x = i * ( live.width + 5 );
			 _liveIconsContainer.addChild( live );
			 }

			 // initialise the restart button
			 _restartButton = new RestartButton();
			 _restartButton.buttonMode = true;
			 _restartButton.mouseChildren = false;
			 _restartButton.stop();
			 _restartButton.addEventListener( MouseEvent.MOUSE_UP, onRestart );
			 _hudContainer.addChild( _restartButton );

			 // initialise the pause button
			 _pauseButton = new PauseButton();
			 _pauseButton.buttonMode = true;
			 _pauseButton.mouseChildren = false;
			 _pauseButton.stop();
			 _pauseButton.addEventListener( MouseEvent.MOUSE_UP, onPause );
			 _hudContainer.addChild( _pauseButton );

			 // initialise the popup container
			 _popUpContainer = new Sprite();
			 addChild(_popUpContainer);

			 // initialise the splash popup
			 _splashPopUp = new SplashPopUp();
			 _splashPopUp.visible = false;
			 _popUpContainer.addChild(_splashPopUp);
			 _playButton = _splashPopUp.playButton;
			 _playButton.buttonMode = true;
			 _playButton.mouseChildren = false;
			 _playButton.stop();
			 _playButton.addEventListener( MouseEvent.MOUSE_UP, onRestart );

			 // initialise the pause popup
			 _pausePopUp = new PausePopUp();
			 _pausePopUp.visible = false;
			 _popUpContainer.addChild(_pausePopUp);
			 _resumeButton = _pausePopUp.resumeButton;
			 _resumeButton.buttonMode = true;
			 _resumeButton.mouseChildren = false;
			 _resumeButton.stop();
			 _resumeButton.addEventListener( MouseEvent.MOUSE_UP, onResume );

			 // initialise the game over popup
			 _gameOverPopUp = new GameOverPopUp();
			 _gameOverPopUp.visible = false;
			 _popUpContainer.addChild(_gameOverPopUp);
			 _playAgainButton = _gameOverPopUp.playAgainButton;
			 _playAgainButton.buttonMode = true;
			 _playAgainButton.mouseChildren = false;
			 _playAgainButton.stop();
			 _playAgainButton.addEventListener( MouseEvent.MOUSE_UP, onRestart, false, 0, true );
			 _goScoreText = _gameOverPopUp.scoreText;
			 _goHighScoreText = _gameOverPopUp.highScoreText;

			 // set the splash popup to visible
			 showPopUp( _splashPopUp );
			 */
		}


		private function initGame ():void
		{
			/*_invawayders = new GameController( _view, _saveStateManager, _cameraLightPicker, _lightPicker, _stageProperties );
			 _invawayders.gameStateUpdated.add(onUpdateGameState);*/
		}


		private function addListeners ():void
		{

		}


		private function onUpdateGameState (gameState:GameState):void
		{
			// Update lives icons.
			/*for( var i:uint; i < GameSettings.playerLives; i++ )
			 _liveIconsContainer.getChildAt( i ).visible = gameState.lives >= i + 1;

			 // Update lives text.
			 _livesText.text = "LIVES " + gameState.lives + "";
			 _livesText.width = _livesText.textWidth * 1.05;

			 //Update score text
			 _scoreText.text = "SCORE " + StringUtils.uintToSameLengthString( gameState.score, 5 ) + "   HIGH-SCORE " + StringUtils.uintToSameLengthString( gameState.highScore, 5 );
			 _scoreText.width = int(_scoreText.textWidth * 1.05);

			 //reset layout to account for lives and score text
			 onResize();

			 if (!gameState.lives && !_stageProperties.popupVisible) {
			 //prepare game over popup
			 _goScoreText.text =     "SCORE................................... " + StringUtils.uintToSameLengthString( gameState.score, 5 );
			 _goHighScoreText = _gameOverPopUp.highScoreText;
			 _goHighScoreText.text = "HIGH-SCORE.............................. " + StringUtils.uintToSameLengthString( gameState.highScore, 5 );
			 _goScoreText.width = int(_goScoreText.textWidth * 1.05);
			 _goScoreText.x = -int(_goScoreText.width / 2);
			 _goHighScoreText.width = int(_goHighScoreText.textWidth * 1.05);
			 _goHighScoreText.x = -int(_goHighScoreText.width / 2);

			 showPopUp( _gameOverPopUp );

			 _invawayders.end();
			 }*/
		}

	}
}
