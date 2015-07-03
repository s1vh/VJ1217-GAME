package screens
{
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.media.SoundMixer;
	import flash.media.SoundChannel;
	import objects.Obstacle;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
		
	import objects.Cat;
		
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import events.NavigationEvent;
	
	import starling.utils.deg2rad;
	
	public class InGame extends starling.display.Sprite
	{
		private var cat:Cat;
		private var obstacle:Obstacle;
		private var enemigoCreado:int = 0;
		private var obstaclesToAnimate:Vector.<Obstacle> = new Vector.<Obstacle>();
		private var rainbowVector:Vector.<Image> = new Vector.<Image>();
		private var rainbowCheck:Image;
		private var prevMinY:int = 800;
		private var prevMaxY:int = 0;
		private var redAvailable:Boolean = true;
		private var crashDuration:int = 0;
		private var crashed:Boolean = false;
		private var star:MovieClip;
		private var channel:SoundChannel;
		
		private var spawnDelay:Number;
		private var elapsed:Number;
		
		private var gameState:String;
		
		private var hit:Boolean = false;
		private var collect:Boolean = false;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		private var scoreText:TextField;
		private var hitpoints:int;
		public static var score:int;
		
		public dynamic function getScore():int
		{
			return score;
		}
		
		public function InGame()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawGame();
		}
		
		private function drawGame():void
		{			
			cat = new Cat();
			cat.x = stage.stageWidth / 2;
			cat.y = stage.stageHeight / 2;
			this.addChild(cat);
			
			scoreText = new TextField(100, 100, score.toString(), Assets.get24Font().name, 24, 0xffffff);
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			star = new MovieClip(Assets.getAtlas().getTextures("token00"), 26);
			star.y = 10;
			star.x = 150 - star.width;
			Starling.juggler.add(star);
			this.addChild(star);
			scoreText.x = 150;
			scoreText.y = 20;
			scoreText.border = false;
			scoreText.height = scoreText.textBounds.height + 10;
			this.addChild(scoreText);
		}
		
		private function createUpdateRainbow():void
		{
			rainbowCheck = new Image(Assets.getAtlas().getTexture("RbSegment"));
			rainbowVector.push(rainbowCheck);
			rainbowCheck.y = cat.y - cat.height / 9.5;
			rainbowCheck.x = Math.floor(cat.x - cat.x / 9.5);			// it delivers always the same aproximation value, preventing tearing
			//rainbowCheck.scaleX = 0.2;
			this.addChild(rainbowCheck);
			this.setChildIndex(rainbowCheck, 0);
			
			if (rainbowVector.length > 1)
			{
				for (var i:uint = rainbowVector.length - 1; i > 0; i--)
				{
					rainbowCheck = rainbowVector[i];							// we can override this reference now
					rainbowCheck.alpha = 0.1 * -Math.floor(hitpoints * -0.1);	// it delivers the 0.1 multiple that is equal or higher (so we show always a little rainbow at least)
					rainbowCheck.x -= rainbowCheck.width;						// we put the alpha update on this loop because we want to update the whole rainbow!
					//rainbowCheck.x -= rainbowCheck.width * 5;
				}
				
				if (rainbowCheck.x < 0)
				{
					this.removeChild(rainbowCheck);						// we know this is the last segment!
				}
			}
			
			else
			{
				rainbowVector[0].visible = false;	// not the most elegant method, but I think this is the most efficient (and we have many segments and we can't reverse the array twice per frame)
			}
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
			
			// RESET VARIABLES
			hitpoints = 10;
			score = 0;
			scoreText.text = score.toString();
			spawnDelay = 100;
			elapsed = 0;
			cat.x = -stage.stageWidth;
			cat.y = (stage.stageHeight / 2) + 2;
			cat.rotation = 0;
			gameState = "idle";
			touchY = stage.stageHeight / 2;
			if (!Sounds.muted) channel = Sounds.sndBgMain.play(0, 9999);
			
			// START
			launchCat();
		}
		
		private function launchCat():void
		{
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			stage.addEventListener(Event.ENTER_FRAME, onGameTick);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(stage);
			
			if (touch != null && 50 < touch.globalY && touch.globalY < 750 )	
			{																	
				touchY = touch.globalY;											
			}																	
		}
		
		private function onGameTick(event:Event):void
		{
			switch(gameState)
			{
				case "idle":	// TAKE OFF
					
					if (cat.x < stage.stageWidth / 5)
					{
						cat.x += ((stage.stageWidth / 4 + 10) - cat.x) / 15;
						cat.y = stage.stageHeight / 2;
					}
					
					else
					{
						gameState = "flying";
					}
					
					break;
					
				case "flying":	// game is running
					
					catMoving();
					createUpdateRainbow();
					obstacleCreate();
					obstacleCheck();
					
					if (crashed)
					{
						crashDuration++;
						
						if (crashDuration == 63)	// we have 21 frames of cat crash animation so we use multiples... (x3)
						{
							crashDuration = 0;
							crashed = false;
							cat.disposeCrashArt();
						}
					}
					
					elapsed++;
					
					break;
					
				case "gameOver":
					
					// reset vectors
					for (var rb:uint = 0; rb < rainbowVector.length; rb++)
					{
						this.removeChild(rainbowVector[rb]);
					}
					
					for (var obs:uint = 0; obs < obstaclesToAnimate.length; obs++)
					{
						this.removeChild(obstaclesToAnimate[obs]);
					}
					
					break;
			}
		}
		
		private function catMoving():void
		{
			cat.y -= (cat.y - touchY) / 20;
			
			if (touchY - cat.y < cat.height / 2 && touchY - cat.y > - cat.height / 2)
			{
				cat.rotation = deg2rad((touchY - cat.y) / 3);
			}
		}
		
		private function obstacleCheck():void
		{
			var obstacleToTrack:Obstacle;
			
			if (hit)
			{
				hit = false;
				
				if (hitpoints - 10 > 0)
				{
					hitpoints = hitpoints - 10;
					crashed = true;
					cat.disposeCatArt();
					trace(hitpoints + " HP");
				}
				
				else
				{
					// we should trigger a Game Over screen here, showing the score
					trace("GAME OVER");
					channel.stop();
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id: "over" }, true));
					gameState = "gameOver";
				}
				
			}
			
			if (collect)
			{
				collect = false;
				
				if (hitpoints < 100)
				{
					hitpoints++;
				}
				
				score++;
				scoreText.text = score.toString();
			}
			
			if (obstaclesToAnimate.length > 0)   
			{
				for (var i:uint = 0; i < obstaclesToAnimate.length; i++)
				{
					obstacleToTrack = obstaclesToAnimate[i]
					
					if (obstacleToTrack.bounds.intersects(cat.bounds) && hit == false)
					{
						switch(obstacleToTrack.type)
						{
							// ENEMY COLLISION
							case 1:
							case 2:
								
								if (crashed == false)
								{
									hit = true;
								}
								
								break;
							
							// STAR COLLISION
							case 3:
								
								collect = true;
								
								if (spawnDelay > 50)
								{
									spawnDelay--;									
								}
								
								break;
						}
						
						obstaclesToAnimate.splice(i, 1);
						this.removeChild(obstacleToTrack);
						
					}
					
					if (obstacleToTrack.x < 0)
					{	
						obstaclesToAnimate.splice(i, 1);
						this.removeChild(obstacleToTrack);
					}
					
				}
			}
		}
		
		private function obstacleCreate():void
		{
			var obstacleCreated:Obstacle;
			var type:int;
			//var starNum:int;
			
			if (elapsed >= spawnDelay)
			{
				
				type = 1 + Math.round(Math.random() * 9);	// randomized object spawner
				
				switch(type)
				{
					
					case 1:
					case 2:
					case 3:
					case 4:
						// this is the GREEN ENEMY
						trace("GREEN incoming");
						
						obstacleCreated = new Obstacle(1);
						obstacleCreated.setDimensions(1);
						
						obstacleCreated.y = obstacleCreated.obstacleHeight / 2 + Math.round(Math.random() * (stage.stageHeight - obstacleCreated.obstacleHeight));
						
						while (prevMinY - obstacleCreated.obstacleHeight / 2 < obstacleCreated.y && obstacleCreated.y < prevMaxY + obstacleCreated.obstacleHeight / 2)
						{
							obstacleCreated.y = obstacleCreated.obstacleHeight / 2 + Math.round(Math.random() * (stage.stageHeight - obstacleCreated.obstacleHeight));
						}
						
						obstacleCreated.x = stage.stageWidth + obstacleCreated.obstacleWidth;
						
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						
						prevMinY = obstacleCreated.y - obstacleCreated.obstacleHeight / 2;
						prevMaxY = obstacleCreated.y + obstacleCreated.obstacleHeight / 2;
						
						redAvailable = true;
						
						break;
						
					case 5:	
					case 6:
					case 7:
						// this is the STAR
						trace("STAR row incoming");
						
						var starNum:int;
						
						starNum = 1 + Math.round(Math.random() * 4);	// size of the star row (1-5)
						
						obstacleCreated = new Obstacle(3);
						obstacleCreated.setDimensions(3);
						
						obstacleCreated.y = obstacleCreated.obstacleHeight / 2 + Math.round(Math.random() * (stage.stageHeight - obstacleCreated.obstacleHeight));
						
						while (prevMinY - obstacleCreated.obstacleHeight / 2 < obstacleCreated.y && obstacleCreated.y < prevMaxY + obstacleCreated.obstacleHeight / 2)
						{
							obstacleCreated.y = obstacleCreated.obstacleHeight / 2 + Math.round(Math.random() * (stage.stageHeight - obstacleCreated.obstacleHeight));
							break;
						}
						
						obstacleCreated.x = stage.stageWidth //+ obstacleCreated.obstacleWidth;
						
						var starY:int;
						var starX:int;
						
						starY = obstacleCreated.y;
						starX = obstacleCreated.x;						
						
						while (starNum > 0)
						{
							obstacleCreated = new Obstacle(3);
							obstacleCreated.setDimensions(3);
							
							obstacleCreated.y = starY;
							obstacleCreated.x = starX + obstacleCreated.obstacleWidth / 2;
							
							this.addChild(obstacleCreated);
							obstaclesToAnimate.push(obstacleCreated);
							
							starX = obstacleCreated.x;
							starNum--;
						}
						
						prevMinY = obstacleCreated.y - obstacleCreated.obstacleHeight / 2;
						prevMaxY = obstacleCreated.y + obstacleCreated.obstacleHeight / 2;
						
						redAvailable = true;
						
						break;
						
					case 8:
					case 9:	
					case 10:
						// this is the RED ENEMY
						
						if (redAvailable)	// we do not want two REDs to spawn in a streak!
						{
							trace("RED incoming");
							
							obstacleCreated = new Obstacle(2);
							obstacleCreated.setDimensions(2);
							obstacleCreated.y = obstacleCreated.obstacleHeight / 2 + Math.round(Math.random() * (stage.stageHeight - obstacleCreated.obstacleHeight));
							
							while (prevMinY - obstacleCreated.obstacleHeight / 2 < obstacleCreated.y && obstacleCreated.y < prevMaxY + obstacleCreated.obstacleHeight / 2)
							{
								obstacleCreated.y = obstacleCreated.obstacleHeight / 2 + Math.round(Math.random() * (stage.stageHeight - obstacleCreated.obstacleHeight));
							}
							
							prevMinY = obstacleCreated.y - obstacleCreated.obstacleHeight / 2;
							prevMaxY = obstacleCreated.y + obstacleCreated.obstacleHeight / 2;
							
							redAvailable = false;
						}
						
						else	// if previous enemy was RED it spawns a GREEN one!
						{
							trace("2nd RED not allowed; GREEN incoming");
							
							obstacleCreated = new Obstacle(1);
							obstacleCreated.setDimensions(1);
							obstacleCreated.y = obstacleCreated.obstacleHeight / 2 + Math.round(Math.random() * (stage.stageHeight - obstacleCreated.obstacleHeight));
							
							while (prevMinY - obstacleCreated.obstacleHeight / 2 < obstacleCreated.y && obstacleCreated.y < prevMaxY + obstacleCreated.obstacleHeight / 2)
							{
								obstacleCreated.y = obstacleCreated.obstacleHeight / 2 + Math.round(Math.random() * (stage.stageHeight - obstacleCreated.obstacleHeight));
							}
							
							prevMinY = obstacleCreated.y - obstacleCreated.obstacleHeight / 2;
							prevMaxY = obstacleCreated.y + obstacleCreated.obstacleHeight / 2;
							
							redAvailable = true;
						}
						
						obstacleCreated.x = stage.stageWidth + obstacleCreated.width;
						
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						
						break;
				}
					
				elapsed = 0;
			}
		}
		
	}
	
}