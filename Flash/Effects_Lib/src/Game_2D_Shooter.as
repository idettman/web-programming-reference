package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;


	[SWF(width=465, height=465,frameRate=60)]
	public class Game_2D_Shooter extends Sprite
	{
		//画面の高さ、幅
		public var W:uint=stage.stageWidth;
		public var H:uint=stage.stageHeight;
		//プレイヤーと敵を描写するデータ
		private var c_bmp:Bitmap;
		private var c_bmpData:BitmapData;
		public var c_canvas:Sprite;
		//背景を描写するデータ
		private var background_bmp:Bitmap;
		private var background_bmpData:BitmapData;
		public var background_canvas:Sprite;
		//弾を描写するデータ
		private var tama_bmp:Bitmap;
		private var tama_bmpData:BitmapData;
		public var tama_canvas:Sprite;

		//残像っっぽいエフェクト
		private var trance:ColorTransform;
		//背景の玉
		private var ball:Vector.<Ball>=new Vector.<Ball>();
		private var i:uint;//ループ用変数
		//文字とフォント
		private var text1:TextField=new TextField();
		private var text2:TextField=new TextField();
		private var text3:TextField=new TextField();
		private var tf:TextFormat=new TextFormat();
		//プレイヤー、敵、玉
		public var player:Player;
		public var enemy:Enemy;
		public var tama:Vector.<Tama>=new Vector.<Tama>();
		public var enemy_tama:Enemy_tama;
		public var enemys:Vector.<Enemys>=new Vector.<Enemys>();

		public var keys:Array=[];//キーボード格納配列
		public var tamaN:int=16; //普通の弾の数
		public var score:uint;//撃破数
		public var explosion:Vector.<Bakuhatu>=new Vector.<Bakuhatu>();//爆発エフェクト
		public var beje:Vector.<Beje>=new Vector.<Beje>();//ホーミング弾

		//最初に呼ばれる関数
		//画面設定などを行う
		public function Game_2D_Shooter()
		{
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			gamen();//テキストなどを画面に追加
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		//画面がクリックされたらの処理
		private function onClick(e:MouseEvent):void
		{
			inits();//プレイヤーや敵の初期化
			removeChild(text1);//文字消す
			//キーボード操作を有効化
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.CLICK, onClick);
		}
		//キーを押したら、押したキーをtrueに
		private function keyDown(e:KeyboardEvent):void
		{
			keys[e.keyCode]=true;
		}
		//キーが離れたら、離れたキーをfalseに
		private function keyUp(e:KeyboardEvent):void
		{
			keys[e.keyCode]=false;
		}
		//初期化
		private function inits():void
		{
			make_objects();
			c_canvas.addChild(player);
			c_canvas.addChild(enemy);
		}
		//spriteをビットマップに変換させる
		private function canvas_init():void
		{
			trance=new ColorTransform(1.0, 1.0, 1.0, 0.8, 0, 0, 0, -20);
			c_bmpData=new BitmapData(W, H, true, 0x0);
			tama_bmpData=new BitmapData(W, H, false, 0x0);
			background_bmpData=new BitmapData(W, H, true, 0x0);
			c_bmp=new Bitmap(c_bmpData);
			tama_bmp=new Bitmap(tama_bmpData);
			background_bmp=new Bitmap(background_bmpData);
			//画面内に追加
			addChild(tama_bmp);
			addChild(c_bmp);
			addChild(background_bmp);
			//新しく作る
			c_canvas=new Sprite();
			tama_canvas=new Sprite();
			background_canvas=new Sprite();
		}

		private function gamen():void
		{
			//玉とかを作る
			before_init();
			//最初の画面の文字
			tf.size=20;
			tf.color=0xFFFFFF;
			text1.defaultTextFormat=tf;
			text1.autoSize=TextFieldAutoSize.CENTER;
			text1.text="Click to start!";
			text1.x=W / 2 - text1.width / 2;
			text1.y=H / 2;
			text2.defaultTextFormat=tf;
			text2.autoSize=TextFieldAutoSize.CENTER;
			text2.x=W / 2 - text2.width / 2;
			text2.y=H / 2 + text1.height * 2;

			addChild(text1);
			addEventListener(Event.ENTER_FRAME, background_frame);
		}
		//右上の撃破数の文字を作る
		private function gekihasuu():void
		{
			var tf2:TextFormat=new TextFormat();
			tf2.size=10;
			tf2.color=0xFFFFFF;
			text3.defaultTextFormat=tf2;
			text3.autoSize=TextFieldAutoSize.CENTER;
			text3.text="撃破数 : " + score.toString();
			text3.x=W - text3.width - 10;
			text3.y=text3.height + 5;
			addChild(text3);
		}

		//色んな初期設定
		private function before_init():void
		{
			canvas_init();//描写するためのビットマップ設定
			gekihasuu();//右上の撃破数の文字を作る
			score=0;//最初の撃破数は0
			//背景の玉
			var b:Ball;
			for (i=0; i < 100; i++)
			{
				b=new Ball();
				b.x=W * Math.random();
				b.y=H * Math.random();
				ball.push(b);
				background_canvas.addChild(ball[i]);
			}
			//普通の玉は16発
			for (i=0; i < tamaN; i++)
			{
				var t:Tama=new Tama(this);
				t.filters=[new GlowFilter(0xEE9900, 1, 4, 4, 2), new BlurFilter(2, 2)];
				tama.push(t);
			}
			//ホーミング弾は8発
			for (i=0; i < 8; i++)
			{
				beje.push(new Beje(this));
			}
		}
		//プレイヤーと敵、敵の打つ弾を作る
		private function make_objects():void
		{
			player=new Player(this, W, H);
			player.x=W / 2;
			player.y=H - 50;

			enemy=new Enemy(this);
			enemy_tama=new Enemy_tama(this);
			for (i=0; i < 10; i++)
				enemys.push(new Enemys(this, Math.random() * 4 + 3));
		}
		//背景の白い玉を動かす
		private function move_background():void
		{
			for (i=0; i < ball.length; i++)
			{
				ball[i].move();
			}
		}
		//爆発エフェクトを動かす
		private function move_bakuhatu():void
		{
			for (i=0; i < explosion.length; i++)
			{
				explosion[i].move();
				//完全に透明になったら消去
				if (explosion[i].alpha < 0)
				{
					tama_canvas.removeChild(explosion[i]);
					explosion.splice(i--, 1);
				}
			}
		}
		//プレイヤーが死んだかどうかチェック
		private function gameOverCheck():void
		{
			if (!player.flag)
				gameOver();
		}
		//右上の撃破数更新
		private function write():void
		{
			text3.text="撃破数 : " + score.toString();
		}

		//ゲームオーバーになったときの処理
		public function gameOver():void
		{
			//文字を表示
			text1.text="GameOver!\nClick To Retry";
			text2.text="撃破数 : " + score.toString() + "体";
			addChild(text1);
			addChild(text2);
			//キーボードから操作できないようにする
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			stage.addEventListener(MouseEvent.CLICK, reset);
		}
		//ゲームオーバーになったとき、プレイヤーや敵、玉の情報を初期化
		private function reset(e:MouseEvent):void
		{
			//敵に関する情報をリセット
			for (i=0; i < enemys.length; i++)
			{
				if (enemys[i].flag)
				{
					enemys[i].reset_enemy();
				}
			}
			for (i=0; i < enemy_tama.bul1.length; i++)
			{
				if (enemy_tama.bul1[i].flag)
				{
					enemy_tama.bul1[i].reset();
				}
			}
			//キーボード情報も一応初期化
			keys[Keyboard.X]=false;
			keys[Keyboard.Z]=false;
			keys[Keyboard.UP]=false;
			keys[Keyboard.DOWN]=false;
			keys[Keyboard.RIGHT]=false;
			keys[Keyboard.LEFT]=false;
			//初期値に戻す
			score=0;
			enemy.rate=50;
			removeChild(text1);
			removeChild(text2);
			//マウスクリックを有効にする
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			//プレイヤー情報リセット
			player.reset();
			stage.removeEventListener(MouseEvent.CLICK, reset);
		}
		//背景を動かす
		private function background_frame(e:Event):void
		{
			background_bmpData.draw(background_canvas);
			background_bmpData.colorTransform(background_bmpData.rect, trance);
			move_background();
		}
		private function onEnterFrame(e:Event):void
		{
			//描写
			c_bmpData.draw(c_canvas);
			c_bmpData.colorTransform(c_bmpData.rect, trance);
			tama_bmpData.draw(tama_canvas);
			tama_bmpData.colorTransform(tama_bmpData.rect, trance);
			//爆発エフェクトがあったら動かす
			move_bakuhatu();
			write();//撃破数右上に書く
			gameOverCheck();//ゲームオーバーになったかどうかをチェック
		}
	}
}

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.ui.Keyboard;


//背景の白い玉
class Ball extends Sprite
{
	private var vy:Number;
	private var g:Graphics;

	public function Ball()
	{
		vy=Math.random() * 0.4 + 0.1;
		g=this.graphics;
		draw();
	}
	//描写
	private function draw():void
	{
		var r:Number=Math.random() + 0.5;
		g.beginFill(0xFFFFFF);
		g.drawCircle(0, 0, r);
		g.endFill();
	}
	//動かす
	public function move():void
	{
		this.y+=vy;
		//画面の下から出たら画面の上に再配置
		if (this.y > 475)
		{
			this.y=-10;
		}
	}
}
//オブジェクトクラスを定義
//弾や自分、敵は速さやフラグ、カウンターがあるのでとりあえず定義しておいた
class Obj extends Shape
{
	protected var field:Game_2D_Shooter;
	public var vx:Number;//ｘ方向の速さ
	public var vy:Number;//ｙ方向の速さ
	public var hp:Number;//HP
	protected var count:uint=0;//カウンター
	public var flag:Boolean;

	public function Obj(field:Game_2D_Shooter)
	{
		this.field=field;
	}
	//描写関数
	protected function draw():void
	{
	}
	//状態更新関数
	protected function update():void
	{
	}
	//削除
	public function deletObj():void
	{
		removeEventListener(Event.ENTER_FRAME, enterFrame);
		parent.removeChild(this);
	}
	//実際に動かす
	protected function enterFrame(e:Event):void
	{
		this.count++;
		if(field.player.flag==false)
			count=1;
		update();
	}
}


class Player extends Obj
{
	private var w:int;//フィールドの横の幅
	private var h:int;//フィールドの縦の幅
	private var g:Graphics;//プレイヤーの描写先

	//プレイヤーの移動に関するパラメータ
	private var n_vx:Number;//斜め移動のときのｘ方向の速さ
	private var n_vy:Number;//斜め移動のときのｙ方向の速さ
	private var to_x:Number;//イージングのｘ方向目標値
	private var to_y:Number;//イージングのｙ方向目標値

	//プレイヤーの大きさや当たり判定のためのパラメータ
	private var p_r:int=10;//大きさ
	public var power:Number;//弾の力
	private var dx:Number;//敵の弾とのｘ方向に関する距離
	private var dy:Number;//敵の弾とのｙ方向に関する距離
	private var d:Number;//敵の弾との距離

	//プレイヤーの攻撃
	private var tama:Vector.<Tama>;//普通の弾
	private var beje:Vector.<Beje>;//ホーミング弾

	//ビットマップデータに描写したいので、stgクラスを持ってくるようにしてある
	public function Player(field:Game_2D_Shooter, w:int, h:int)
	{
		super(field);
		this.field=field;
		this.w=w;
		this.h=h;
		this.flag=true;//弾が当たったかそうでないか

		//初期位置にイージング先を設定しておく
		to_x=w / 2;
		to_y=h - 50;

		//プレイヤーデータの初期化
		power=50;
		this.vx=4.0;
		this.vy=4.0;
		this.tama=field.tama;
		this.beje=field.beje;
		g=this.graphics;
		n_vx=vx / Math.SQRT2;
		n_vy=vy / Math.SQRT2;

		//描写し、フレームに入れる
		draw();
		addEventListener(Event.ENTER_FRAME, enterFrame);
	}
	//描写関数
	override protected function draw():void
	{
		g.beginFill(0x00AAFF);
		g.moveTo(0, -p_r);
		for (var i:int=3; i >= 0; i--)
			g.lineTo(p_r * Math.cos(Math.PI / 2 + i * 2 * Math.PI / 3), -p_r * Math.sin(Math.PI / 2 + i * 2 * Math.PI / 3));
		g.endFill();
	}
	//状態更新
	override protected function update():void
	{
		keyCheck();
		player_tama();
		tama_move();
		homing_lazer_move();
		move();
	}
	//死んだとき、データを初期化する
	public function reset():void
	{
		count=0;
		this.flag=true;
		this.alpha=1;
		this.x=w / 2;
		this.y=h - 50;
		to_x=w / 2;
		to_y=h - 50;
	}
	//プレイヤーの攻撃する弾
	private function player_tama():void
	{
		var i:int=0;
		if (count % 5 == 0)
		{
			if (field.keys[Keyboard.X])//ｘキーを押したら普通の弾発射
			{
				for (i=0; i < field.tamaN; i++)
				{
					if (!tama[i].flag)//発射してもOKな弾だったら位置を調整して描写
					{
						tama[i].flag=true;
						tama[i].x=this.x - 2;
						tama[i].y=this.y - p_r;
						field.tama_canvas.addChild(tama[i]);
						break;
					}
				}
			}
			else if (field.keys[Keyboard.Z])//zキーを押したらホーミング弾を発射
			{
				for (i=0; i < field.enemys.length; i++)
				{
					if (field.enemys[i].flag)//画面内にいる敵をロックオン
					{
						for (var j:int=0; j < beje.length; j++)
						{
							if (!beje[j].flag)//発射してもOKだったら初期化
							{
								beje[j].flag=true;
								beje[j].enemy_number=i;
								beje[j].atan2=Math.atan2(this.y - field.enemys[i].y, this.x - field.enemys[i].y);
								beje[j].init_points(this.x, this.y);
								//trace("added");
								break;
							}
						}
						break;
					}
				}

			}
		}
	}
	//描写されている弾を動かす
	private function homing_lazer_move():void
	{
		for (var i:int=0; i < beje.length; i++)
		{
			if (beje[i].flag)
			{
				beje[i].move();
			}
		}
	}
	//描写されている弾を動かす
	private function tama_move():void
	{
		for (var i:int=0; i < field.tamaN; i++)
		{
			if (tama[i].flag)//動いてもいい弾だったら
			{
				tama[i].move();
				if (tama[i].y < -10)//画面外に出たら
				{
					tama[i].flag=false;
					tama[i].deletObj();
				}
				for (var j:int=0; j < field.enemys.length; j++)
				{
					if (field.enemys[j].flag && tama[i].flag)//画面内にいる敵がいたら距離を計算
					{
						dx=field.enemys[j].x - tama[i].x;
						dy=field.enemys[j].y - tama[i].y;
						d=(dx * dx) + (dy * dy);
						if (d < field.enemys[j].r * field.enemys[j].r)//敵に当たっていたら弾を決して、エフェクトを描写
						{
							tama[i].flag=false;
							tama[i].deletObj();
							for (var k:int=0; k < 6; k++)
							{
								var b:Bakuhatu=new Bakuhatu(tama[i].x, tama[i].y, Math.random() + 0.5);
								b.to_x=Math.random() * 20 - 10;
								b.to_y=Math.random() * 30;
								b.filters=[new GlowFilter(0xFFEE00, 1, 2, 2)];
								field.explosion.push(b);
								field.tama_canvas.addChild(field.explosion[field.explosion.length - 1]);
							}
							field.enemys[j].hp-=power;//ダメージを敵に与える
						}
					}
				}
			}
		}
	}
	//プレイヤーの移動
	private function move():void
	{
		//イージング
		this.x+=(to_x - this.x) / 5;
		this.y+=(to_y - this.y) / 5;

		if (this.x + p_r > w)
		{
			to_x=this.x;
			this.x=w - p_r;
		}
		if (this.x - p_r < 0)
		{
			to_x=this.x;
			this.x=p_r;
		}
		if (this.y + p_r > h)
		{
			to_y=this.y;
			this.y=h - p_r;
		}
		if (this.y - p_r < 0)
		{
			to_y=this.y;
			this.y=p_r;
		}
	}
	//キーをチェックし、イージングの目標値を設定
	private function keyCheck():void
	{
		if (field.keys[Keyboard.RIGHT] && field.keys[Keyboard.UP])
		{
			to_x+=n_vx;
			to_y-=n_vy;
		}
		else if (field.keys[Keyboard.LEFT] && field.keys[Keyboard.UP])
		{
			to_x-=n_vx;
			to_y-=n_vy;
		}
		else if (field.keys[Keyboard.RIGHT] && field.keys[Keyboard.DOWN])
		{
			to_x+=n_vx;
			to_y+=n_vy;

		}
		else if (field.keys[Keyboard.LEFT] && field.keys[Keyboard.DOWN])
		{
			to_x-=n_vx;
			to_y+=n_vy;
		}
		else if (field.keys[Keyboard.RIGHT])
			to_x+=vx;
		else if (field.keys[Keyboard.LEFT])
			to_x-=vx;
		else if (field.keys[Keyboard.UP])
			to_y-=vy;
		else if (field.keys[Keyboard.DOWN])
			to_y+=vy;

	}
}

class Enemy extends Obj
{
	//敵を格納するベクター
	private var en:Vector.<Enemys>;

	protected var w:int;
	protected var h:int;
	//敵の出現頻度
	public var rate:int=50;

	public function Enemy(field:Game_2D_Shooter)
	{
		super(field);
		this.field=field;
		this.w=field.W;
		this.h=field.H;
		this.h=h;
		this.en=field.enemys;
		addEventListener(Event.ENTER_FRAME, enterFrame);
	}

	override protected function update():void
	{
		if (count % rate == 0)
		{
			//出現する敵を決める
			trace(rate);
			enemy_check();
		}
		//画面内の敵を動かす
		move_enemys();
	}

	//画面に表示されている敵を動かす
	private function move_enemys():void
	{
		for (var i:int=0; i < en.length; i++)
		{
			if (en[i].flag) //もし表示されていたら
			{
				en[i].move(i); //動く
				if (en[i].y > h + en[i].r || en[i].y < 0 - en[i].r || en[i].x > w + en[i].r * 3 || en[i].x < 0 - en[i].r * 3) //画面外に出たら
				{
					en[i].reset_enemy();
				}
				if (en[i].hp < 0) //敵が死んだら
				{
					field.score++;
					if (rate > 30)
						rate--;
					//敵が死んだときのエフェクトをキャンバスに追加
					for (var j:int=0; j < 6; j++)
					{
						//白のボールを作る
						var b:Bakuhatu=new Bakuhatu(en[i].x, en[i].y, Math.random() * 10 + 1);
						b.to_x=Math.random() * 60 - 30;
						b.to_y=Math.random() * 60 - 30;
						b.filters=[new GlowFilter(0xDC9810, 1, 8, 8, 2)]; //白のボールの周りの色
						//画面に追加
						field.explosion.push(b);
						field.tama_canvas.addChild(field.explosion[field.explosion.length - 1]);

					}
					en[i].reset_enemy();
				}
			}
		}
	}

	//画面に表示されていない敵を探す
	private function enemy_check():void
	{
		//表示されていない敵のリストを格納するためのベクター
		var false_enemy:Vector.<uint>=new Vector.<uint>();
		for (var i:int=0; i < en.length; i++)
		{
			if (!en[i].flag)
			{
				false_enemy.push(i);
			}
		}
		if (false_enemy.length != 0)
		{
			var falseNumber:uint=false_enemy.length * Math.random();
			var selectEnemy_num:uint=false_enemy[falseNumber];
			en[selectEnemy_num].set_enemy(w, h);
		}
	}
}
class Enemys extends Obj
{
	private var num:int; //何芒星か
	public var r:Number; //半径（敵の大きさ）
	public var vr:Number; //回転速度
	public var pattern:uint=0; //動きのパターン
	public var shotPattern:uint=0; //放つショットのパターン
	public var shot_time:uint; //弾を撃つまでの時間

	private var pat_func:Function; //動きの関数　patternの値によって入る関数が変わる
	private var pat:Vector.<Function>=new Vector.<Function>(); //パターンを格納するベクター
	private var g:Graphics; //描写先

	public function Enemys(field:Game_2D_Shooter, num:int)
	{
		super(field);
		this.field=field;
		this.num=num;
		this.flag=false;
		this.hp=100;
		this.vy=Math.random() * 2 + 1;
		this.vx=Math.random() * 2 - 1;
		this.vr=Math.random() * 6 - 3;
		g=this.graphics;
		count=0;
		pat.push(pat1, pat2, pat3, pat4, pat5);
		draw();
	}

	//敵を描く
	override protected function draw():void
	{
		var even:Vector.<Number>=new Vector.<Number>();
		var odd:Vector.<Number>=new Vector.<Number>();
		var color:Number=Math.random() * 0xFFFFFF;
		this.filters=[new GlowFilter(color, 1, 3, 3, 2), new BlurFilter(2, 2, 1)];
		r=Math.random() * 10 + 10;
		for (var i:int=0; i < num; i++)
		{
			if (!(i % 2))
				even.push(i * 2 * Math.PI / num);
			else if (i % 2)
				odd.push(i * 2 * Math.PI / num);
		}
		g.lineStyle(2, 0xFFFFFF);

		if (!(num % 2))
		{
			g.moveTo(r * Math.cos(even[0]), r * Math.sin(even[0]));
			for (var k:int=even.length - 1; k >= 0; k--)
			{
				g.lineTo(r * Math.cos(even[k]), r * Math.sin(even[k]));
			}
			g.moveTo(r * Math.cos(odd[0]), r * Math.sin(odd[0]));
			for (k=odd.length - 1; k >= 0; k--)
			{
				g.lineTo(r * Math.cos(odd[k]), r * Math.sin(odd[k]));
			}
		}
		else if (num % 2)
		{
			var points:Vector.<Number>=even.concat(odd);
			g.moveTo(r * Math.cos(points[0]), r * Math.sin(points[0]));
			for (var n:int=points.length - 1; n >= 0; n--)
				g.lineTo(r * Math.cos(points[n]), r * Math.sin(points[n]));
		}
	}

	//画面から消す
	override public function deletObj():void
	{
		parent.removeChild(this);
	}

	//敵を画面に追加するときの設定
	public function set_enemy(w:int, h:int):void
	{
		this.x=25 + (w - 50) * Math.random();
		this.y=-this.r;
		this.vy=Math.random() * 2 + 1;
		this.vx=Math.random() * 2 - 1;
		this.vr=Math.random() * 6 - 3;
		this.flag=true;
		this.shot_time=20;
		this.pattern=(uint)(Math.random() * pat.length);
		this.shotPattern=(uint)(Math.random() * field.enemy_tama.bul1[0].set_pat.length);
		var color:Number=Math.random() * 0xFFFFFF;
		this.filters=[new GlowFilter(color, 1, 3, 3, 2), new BlurFilter(2, 2, 1)];
		count=0;
		pat_func=pat[this.pattern];
		field.c_canvas.addChild(this);
	}

	//敵が消えたとき、リセット
	public function reset_enemy():void
	{
		count=0;
		this.hp=100;
		this.flag=false;
		this.deletObj();
	}

	//動かす
	public function move(i:int):void
	{
		pat_func(); //この関数にはそれぞれ用意したパターンのどれかが入っている
		count++;
		if (count >= shot_time)
		{
			field.enemy_tama.set_bullets(i, count - shot_time);
		}
	}

	//敵の動きのパターン
	//回転して落ちてくる
	private function pat1():void
	{
		this.y+=this.vy;
		this.rotation+=vr;
	}

	//横にも動く
	private function pat2():void
	{
		this.y+=this.vy;
		this.x+=this.vx;
		this.rotation+=vr;
	}

	//半分まできたら上に戻る
	private function pat3():void
	{
		this.y+=this.vy;
		if (this.y > field.H / 2)
			this.vy*=-1;
		this.rotation+=vr;
	}

	//左右に揺れながら落ちる
	private function pat4():void
	{
		this.y+=this.vy;
		this.x+=Math.cos(Math.PI * count / 180);
		this.rotation=this.vr;
	}

	//半分まできたら左右に行く
	private function pat5():void
	{
		if (this.y < field.H / 2)
			this.y+=this.vy;
		if (this.y > field.H / 2)
		{
			if (Math.abs((uint)(this.vx)) < 1.0)
			{
				if (this.vx > 0)
					this.vx=Math.random() * 2 + 1;
				else if (this.vx < 0)
					this.vx=Math.random() * 2 - 3;
			}

			this.x+=this.vx;
		}
		this.rotation+=this.vr;
	}
}

//普通の弾の動きや初期化
class Tama extends Obj
{
	public var index:int;
	private var g:Graphics;

	public function Tama(field:Game_2D_Shooter)
	{
		super(field);
		this.flag=false;
		this.vy=8;
		g=this.graphics;
		draw();
	}

	override protected function draw():void
	{
		g.beginFill(0xFFFFFF);
		g.drawEllipse(0, 0, 4, 8);
		g.endFill();
	}

	override public function deletObj():void
	{
		parent.removeChild(this);
	}

	public function move():void
	{
		this.y-=this.vy;
	}
}
class Enemy_tama extends Obj
{
	//弾を格納するベクター
	public var bul1:Vector.<Bullet1>=new Vector.<Bullet1>();

	//実際の動き、弾のパターン
	private var set_pattern:int;
	private var move_pattern:int;
	//弾
	private var _b:Bullet1;

	public function Enemy_tama(field:Game_2D_Shooter)
	{
		super(field);
		this.field=field;
		//弾生成
		for (var i:int=0; i < 64; i++)
		{
			_b=new Bullet1(field, 2);
			_b.filters=[new GlowFilter(0xFF3300, 1, 5, 5, 2)];
			bul1.push(_b);
		}
		addEventListener(Event.ENTER_FRAME, enterFrame);
	}

	override protected function update():void
	{
		move();
	}

	//弾をセット
	public function set_bullets(n:int, cnt:uint):void
	{
		for (var i:int=0; i < bul1.length; i++)
		{
			if (!bul1[i].flag) //撃ってない弾だったら動きなどをセットする
			{
				set_pattern=(uint)(field.enemys[n].shotPattern);
				move_pattern=(uint)(Math.random() * bul1[i].move_pat.length);
				bul1[i].set_move(move_pattern);
				bul1[i].set_bullet(set_pattern, n, cnt);
				bul1[i].num=n;
				break;
			}
		}
	}
	//プレイヤーとの距離を求めるときのパラメータ
	private var d:Number;
	private var dx:Number;
	private var dy:Number;

	public function move():void
	{
		for (var i:int=0; i < bul1.length; i++)
		{
			if (bul1[i].flag) //撃っている弾だったら
			{
				bul1[i].move(); //動かす
				//画面外に出たときの処理
				if (bul1[i].x - bul1[i].r > field.W || bul1[i].x + bul1[i].r < 0 || bul1[i].y - bul1[i].r > field.H || bul1[i].y + bul1[i].r < 0)
				{
					bul1[i].reset();
				}
				//プレイヤーに当たるときの処理
				//距離を求めて当たり判定を行っている
				if (bul1[i].flag)
				{
					dx=field.player.x - bul1[i].x;
					dy=field.player.y - bul1[i].y;
					d=(dx * dx + dy * dy);
					//ちょっと当たりにくくするために4*4という距離に設定
					if (d < 16 && field.player.flag)
					{
						bul1[i].reset();
						//エフェクト
						for (var j:int=0; j < 10; j++)
						{
							var b:Bakuhatu=new Bakuhatu(field.player.x, field.player.y, Math.random() * 15 + 5);
							b.to_x=Math.random() * 100 - 50;
							b.to_y=Math.random() * 100 - 50;
							b.filters=[new GlowFilter(0xDC9810, 1, 8, 8, 2)];
							field.explosion.push(b);
							field.tama_canvas.addChild(field.explosion[field.explosion.length - 1]);
						}
						field.player.flag=false;
						field.player.alpha=0;
						count=0;
					}
				}
			}
		}
	}
}
//敵の弾
//set_patで速さや方向を設定し、move_patでその速さで動かす
class Bullet1 extends Obj
{
	public var r:int;//玉の大きさ
	//玉の動きの関数を格納ベクター
	public var set_pat:Vector.<Function>=new Vector.<Function>();
	//玉を動かす関数を格納したベクター
	public var move_pat:Vector.<Function>=new Vector.<Function>();
	public var move_func:Function;//実際に使う関数を入れるための変数
	public var set_func:Function;//実際に使う関数を入れるための変数
	public var num:int;
	private var radius:Number;//プレイヤーとの角度
	private var g:Graphics;//描写先

	//初期化する
	public function Bullet1(field:Game_2D_Shooter, _r:int)
	{
		super(field);
		this.field=field;
		set_pat.push(set_pat1, set_pat2, set_pat3);//関数をベクターに突っ込む
		move_pat.push(move_pat1);//動き方は一つ
		g=this.graphics;
		this.vx=0;
		this.vy=0;
		this.flag=false;
		r=_r;
		draw();
	}
	//描写
	override protected function draw():void
	{
		g.beginFill(0xFFFFFF);
		g.drawCircle(0, 0, r);
		g.endFill();
	}
	//消す
	override public function deletObj():void
	{
		parent.removeChild(this);
	}
	//リセット
	public function reset():void
	{
		this.flag=false;
		this.deletObj();
	}
	//動きをセット
	public function set_move(pat:uint):void
	{
		move_func=move_pat[pat];
	}
	//玉の動き方をセット
	public function set_bullet(pat:uint, n:int, cnt:uint):void
	{
		set_func=set_pat[pat];
		set_func(n, cnt);
	}
	//玉を動かす
	public function move():void
	{
		move_func();
	}
	//動き方その一
	private function move_pat1():void
	{
		this.x+=this.vx;
		this.y+=this.vy;
	}
	//玉のパターンその一
	//下に撃つだけ
	private function set_pat1(n:int, cnt:uint):void
	{
		if (!this.flag)
		{
			if (cnt % 20 == 0 && cnt < 100)
			{
				this.flag=true;
				this.x=field.enemys[n].x;
				this.y=field.enemys[n].y;
				this.vx=0;
				this.vy=5;
				field.tama_canvas.addChild(this);
			}
		}
	}
	//玉のパターンその二
	//プレイヤー狙い
	private function set_pat2(n:int, cnt:uint):void
	{
		if (!this.flag)
		{
			if (cnt % 20 == 0 && cnt < 100)
			{
				this.flag=true;
				this.x=field.enemys[n].x;
				this.y=field.enemys[n].y;
				radius=Math.atan2(field.player.y - this.y, field.player.x - this.x);
				this.vx=3 * Math.cos(radius);
				this.vy=3 * Math.sin(radius);
				field.tama_canvas.addChild(this);
			}
		}
	}
	//玉のパターンその三
	//プレイヤー狙いで間隔が短い
	private function set_pat3(n:int, cnt:uint):void
	{

		if (!this.flag)
		{
			if (cnt % 10 == 0 && cnt < 50)
			{
				this.flag=true;
				this.x=field.enemys[n].x;
				this.y=field.enemys[n].y;
				radius=Math.atan2(field.player.y - this.y, field.player.x - this.x);
				this.vx=3 * Math.cos(radius);
				this.vy=3 * Math.sin(radius);
				field.tama_canvas.addChild(this);
			}
		}
	}
}
//ベジェ曲線を描く
class Beje extends Sprite
{
	private var field:Game_2D_Shooter;
	private var a:Point, b:Point, c:Point, d:Point;//制御点
	private var rate:Number=0.04;//通る点の数の制御
	private var p_num:int=1 / rate;//点の数
	private var points:Vector.<Sprite>=new Vector.<Sprite>();//線を描くキャンパス
	private var g:Vector.<Graphics>=new Vector.<Graphics>();//線を描くための点

	//ベジェ曲線のパラメータ
	private var t:Number, count:Number;
	private var r:Number;//プレイヤーからの距離
	private var rx:Number;
	private var ry:Number;
	private var old_rx:Number, old_ry:Number;

	//当たる敵の情報
	public var flag:Boolean;
	public var enemy_number:int;
	public var atan2:Number;

	public function Beje(field:Game_2D_Shooter)
	{
		this.field=field;
		this.flag=false;
		//制御点を作る
		a=new Point();
		b=new Point();
		c=new Point();
		d=new Point();
		for (var i:int=0; i < p_num; i++)
		{
			points.push(new Sprite);
			g.push(points[i].graphics);
			points[i].filters=[new GlowFilter(0xFFFF88, 1, 2, 2, 2), new GlowFilter(0x88FFFF, 0.8, 10, 10, 2)];
		}
	}
	//_xと_yはプレイヤーの位置
	public function init_points(_x:Number, _y:Number):void
	{
		t=0;
		count=0;
		a.x=_x;
		a.y=_y;
		//プレイヤーからある程度離れたランダムな点を元に制御点を決めていく
		r=Math.random() * 300 - 150;
		b.x=r * Math.cos(atan2 - Math.PI / 2) + 150 * Math.cos(atan2) + a.x;
		b.y=r * Math.sin(atan2 - Math.PI / 2) + 150 * Math.sin(atan2) + a.y;
		c.x=Math.random() * 300 * Math.cos(Math.random() * 2 * Math.PI) + field.enemys[enemy_number].x;
		c.y=Math.random() * 300 * Math.sin(Math.random() * 2 * Math.PI) + field.enemys[enemy_number].y;
		rx=a.x;
		ry=a.y;
	}
	//決めた制御点を元に点を移動させる
	//同時にゴールの点を毎回設定し直している
	public function move():void
	{
		//敵の位置を更新
		d.x=field.enemys[enemy_number].x;
		d.y=field.enemys[enemy_number].y;
		if (t <= 1)
		{
			//敵が死んだら爆発して線を消す
			if (!field.enemys[enemy_number].flag)
			{
				baku(rx, ry, Math.atan2(ry - old_ry, rx - old_rx));
				this.flag=false;
			}
			else
			{
				t+=rate;
				old_rx=rx;
				old_ry=ry;
				rx=a.x * (1 - t) * (1 - t) * (1 - t) + 3 * b.x * t * (1 - t) * (1 - t) + 3 * c.x * t * t * (1 - t) + d.x * t * t * t;
				ry=a.y * (1 - t) * (1 - t) * (1 - t) + 3 * b.y * t * (1 - t) * (1 - t) + 3 * c.y * t * t * (1 - t) + d.y * t * t * t;
				draw_lins();
				count++;
			}
		}
		//敵までたどり着いたらHPを減らして線を消す
		else
		{
			baku(d.x, d.y, Math.atan2(ry - old_ry, rx - old_rx));
			this.flag=false;
			field.enemys[enemy_number].hp-=field.player.power / 2;
		}
	}
	//敵が死んだときのエフェクト
	private function baku(_x:Number, _y:Number, theta:Number):void
	{
		for (var j:int=0; j < 3; j++)
		{
			var b:Bakuhatu=new Bakuhatu(_x, _y, Math.random() * 5 + 1);
			b.to_x=Math.random() * 60 * Math.cos(theta + Math.random() * Math.PI / 3 - Math.PI / 6);
			b.to_y=Math.random() * 60 * Math.sin(theta + Math.random() * Math.PI / 3 - Math.PI / 6);
			b.filters=[new GlowFilter(0x1289EF, 1, 8, 8, 2)];
			field.explosion.push(b);
			field.tama_canvas.addChild(field.explosion[field.explosion.length - 1]);
		}
	}
	//設定した点を元に線を描く
	private function draw_lins():void
	{
		g[count].moveTo(old_rx, old_ry);
		g[count].lineStyle(1, 0xFFFFFF, 1);
		g[count].lineTo(rx, ry);
		points[count].addEventListener(Event.ENTER_FRAME, lineFrame);
		field.tama_canvas.addChild(points[count]);
	}
	//線をだんだん透明にして、尾を引いているように見せる
	private function lineFrame(e:Event):void
	{
		e.currentTarget.alpha-=0.1;
		//完全に透明になったら線を消去
		if (e.currentTarget.alpha <= 0)
		{
			e.currentTarget.graphics.clear();
			e.currentTarget.alpha=1;
			field.tama_canvas.removeChild(DisplayObject(e.currentTarget));
			e.currentTarget.removeEventListener(Event.ENTER_FRAME, lineFrame);
		}
	}

}
class Bakuhatu extends Sprite
{
	public var to_x:Number;
	public var to_y:Number;

	//爆発のエフェクト
	public function Bakuhatu(_x:Number, _y:Number, r:Number)
	{
		//基本色は白
		//他の場所で呼び出す時、周りの色を設定する
		graphics.beginFill(0xFFFFFF, 1);
		graphics.drawCircle(_x, _y, r);
		graphics.endFill();
	}

	//動きはランダムな方向にイージング
	public function move():void
	{
		this.x+=(to_x - this.x) / 8;
		this.y+=(to_y - this.y) / 8;
		this.alpha-=0.04;
	}
}
