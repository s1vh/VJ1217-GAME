package screens
{
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import objects.Obstacle;
		
	import objects.Cat;
		
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	import starling.utils.deg2rad;
	
	public class InGame extends starling.display.Sprite
	{
		private var cat:Cat;
		private var obstacle:Obstacle;
		private var enemigoCreado:int = 0;
		private var obstaclesToAnimate:Vector.<Obstacle> = new Vector.<Obstacle>();
		private var prevMinY:int = 800;
		private var prevMaxY:int = 0;
		private var redAvailable:Boolean = true;
		
		//private var timePrevious:Number;
		private var spawnDelay:Number = 100;
		private var elapsed:Number = 0;
		
		private var gameState:String;
		//private var playerSpeed:Number;
		//private var hitObstacle:Number = 0;
		//private const MIN_SPEED:Number = 650;
		
		//private var scoreDistance:int;
		//private var obstacleGapCount:int;
		private var hit:Boolean = false;
		private var collect:Boolean = false;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		private var hitpoints:int = 100;
		public var score:int = 0;
		
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
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
			
			cat.x = -stage.stageWidth;
			cat.y = stage.stageHeight / 2;
			
			gameState = "idle";
			//playerSpeed = 0;
			//hitObstacle = 0;
			touchY = stage.stageHeight / 2;
			//scoreDistance = 0;
			//obstacleGapCount = 0;
			
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
					
				case "flying":	// game is runing
					
					catMoving();
					obstacleCreate();
					obstacleCheck();
					
					elapsed++;
					
					break;
					
				case "gameOver":
					
					// we should trigger a Game Over screen here, showing the score					
					trace("GAME OVER");
					trace("final score = " + score);
					
					break;
			}
		}
		
		private function catMoving():void
		{
			cat.y -= (cat.y - touchY) / 20;
			
			if ( -(cat.y - touchY) < cat.height / 2 && - (cat.y - touchY) > - cat.height / 2)
			{
				cat.rotation = deg2rad(-(cat.y - touchY) / 4);
			}
		}
		
		private function obstacleCheck():void
		{
			var obstacleToTrack:Obstacle;
			
			if (hit)	// we do not need invincibility coldown for this game!
			{
				hit = false;
				
				if (hitpoints - 10 > 0)
				{
					hitpoints = hitpoints - 10;
					trace(hitpoints + "HP");
				}
				
				else
				{
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
				trace(score);
			}
			
			if (obstaclesToAnimate.length > 0)   
			{
				for (var ind:uint = 0; ind < obstaclesToAnimate.length; ind++)
				{
					obstacleToTrack = obstaclesToAnimate[ind]
					
					if (obstacleToTrack.bounds.intersects(cat.bounds) && hit == false)
					{
						switch(obstacleToTrack.type)
						{
							// ENEMY COLLISION
							case 1:
							case 2:
								
								hit = true;
								break;
							
							// STAR COLLISION
							case 3:
								
								collect = true;
								if (spawnDelay > 50)
								{
									spawnDelay--;
									//trace(spawnDelay);
								}
								
								break;
						}
						
						obstaclesToAnimate.splice(ind, 1);
						this.removeChild(obstacleToTrack);
						
					}
					
					if (obstacleToTrack.x < -(obstacleToTrack.width / 2))
					{	
						obstaclesToAnimate.splice(ind, 1);
						this.removeChild(obstacleToTrack);
					}
					
				}
			}
		}
		
		private function obstacleCreate():void
		{
			
			var obstacleCreated:Obstacle;
			var type:int;
			var starNum:int;
			var preY:int;
			
			if (elapsed == spawnDelay)
			{
				
				type = 1 + Math.floor(Math.random() * 9);	// ésto devuelve un random de 1 a 10
				//trace("type OK");
				
				switch(type)
				{
				
					case 1:
					case 2:
					case 3:
					case 4:
						trace("GREEN incoming");
						
						// this is the GREEN ENEMY
						obstacleCreated = new Obstacle(1);
						obstacleCreated.y = 200 / 2 + Math.floor(Math.random() * 700);	// MAGIC NUMBERS !! (where 200 is enemy.height and 700 is stage.stageHeight - enemy.height/2)
						
						while (prevMinY - 200 / 2 < obstacleCreated.y && obstacleCreated.y < prevMaxY + 200 / 2)
						{
							obstacleCreated.y =200 / 2 + Math.floor(Math.random() * 700);
						}
						
						prevMinY = obstacleCreated.y - 200 / 2;	// MAGIC NUMBERS !!
						prevMaxY = obstacleCreated.y + 200 / 2;	// MAGIC NUMBERS !!
						//trace("BLOCKED RANGE: " + prevMinY + "-" + prevMaxY)
						
						obstacleCreated.x = stage.stageWidth + 200 / 2;	// // MAGIC NUMBERS !! (where 200 is enemy.widht)
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						
						redAvailable = true;
						
						break;
						
					case 5:	
					case 6:
					case 7:
						trace("STAR/s incoming");
						
						// this is the STAR
						starNum = 1 + Math.floor(Math.random() * 4);	// ésto devuelve un random de 1 a 5
						preY = Math.floor(150 / 2 + Math.random() * (stage.stageHeight - 150 / 2));	// MAGIC NUMBERS !! 150 = star.width & .height
						while (prevMinY - 150 / 2 < preY && preY < prevMaxY + 150 / 2)
						{
							preY = Math.floor(150 / 2 + Math.random() * (stage.stageHeight - 150 / 2));
						}
						
						while (starNum > 0)
						{
							obstacleCreated = new Obstacle(3);
							
							obstacleCreated.y = preY;
							
							obstacleCreated.x = Math.floor((stage.stageWidth + starNum * 150 / 2));
							this.addChild(obstacleCreated);
							obstaclesToAnimate.push(obstacleCreated);
							
							starNum--;
						}
						
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
							obstacleCreated.y = 200 + Math.floor(Math.random() * 600);	// MAGIC NUMBERS !! (where 200 is enemy.height/2 * cos(x) * A and 600 is stage.stageHeight - enemy.height/2 * cos(x) * A)
							while (prevMinY < obstacleCreated.y && obstacleCreated.y < prevMaxY)
							{
								obstacleCreated.y = 200 + Math.floor(Math.random() * 600);
							}
							
							prevMinY = obstacleCreated.y - 200;	// MAGIC NUMBERS !!
							prevMaxY = obstacleCreated.y + 200;	// MAGIC NUMBERS !!
							
							redAvailable = false;
						}
						
						else	// if previous enemy was RED it spawns a GREEN one!
						{
							trace("2nd RED not allowed; GREEN incoming");
							
							obstacleCreated = new Obstacle(1);
							obstacleCreated.y = 100 + Math.floor(Math.random() * 700);	// MAGIC NUMBERS !! (where 100 is enemy.height/2 and 700 is stage.stageHeight - enemy.height/2)
							while (prevMinY < obstacleCreated.y && obstacleCreated.y < prevMaxY)
							{
								obstacleCreated.y = 100 + Math.floor(Math.random() * 700);
							}
							
							prevMinY = obstacleCreated.y - 100;	// MAGIC NUMBERS !!
							prevMaxY = obstacleCreated.y + 100;	// MAGIC NUMBERS !!
							
							redAvailable = true;
						}
						
						//trace("BLOCKED RANGE: " + prevMinY + "-" + prevMaxY)
						obstacleCreated.x = stage.stageWidth + 100;	// // MAGIC NUMBERS !! (where 100 is enemy.widht/2)
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						
						break;
				}
					
				elapsed = 0;
			}
		}
	}
	
}