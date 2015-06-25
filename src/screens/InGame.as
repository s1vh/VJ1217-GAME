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
		private var invincibleTimer:int = 0;
		
		private var timePrevious:Number;
		private var timeCurrent:Number = 50;
		private var elapsed:Number = 0;
		
		private var gameState:String;
		private var playerSpeed:Number;
		private var hitObstacle:Number = 0;
		private const MIN_SPEED:Number = 650;
		
		private var scoreDistance:int;
		private var obstacleGapCount:int;
		private var hit:Boolean = false;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		private var hitpoints:int = 100;
		
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
			cat.x = stage.stageWidth/2;
			cat.y = stage.stageHeight/2;
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
			cat.y = stage.stageHeight * 0.5;
			
			gameState = "idle";
			playerSpeed = 0;
			hitObstacle = 0;
			touchY = stage.stageHeight * 0.5;
			scoreDistance = 0;
			obstacleGapCount = 0;
			
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
				case "idle":
					// Take off
					
					if (cat.x < stage.stageWidth * 0.5 * 0.5)
					{
						cat.x += ((stage.stageWidth * 0.5 * 0.5 + 10) - cat.x) * 0.05;
						cat.y = stage.stageHeight * 0.5;
						
						playerSpeed += (MIN_SPEED - playerSpeed) * 0.05;	
					}
					
					else
					{
						gameState = "flying";
					}
					
					break;
					
				case "flying":
					elapsed++;
					
					if (hitObstacle <= 0)
					{
						cat.y -= (cat.y - touchY) * 0.05;
							
						if (-(cat.y - touchY) < cat.height/2 && - (cat.y - touchY) > - cat.height/2)
						{
							cat.rotation = deg2rad(-(cat.y - touchY) * 0.2);
						}
					
					obstacleCreate();
					obstacleCheck();
					}
			}
		}
		
		private function obstacleCheck():void
		{
			var obstacleToTrack:Obstacle;
			if (hit)
			{
				if (invincibleTimer == 0)
				{
					hitpoints = hitpoints - 10;
					trace("HP="+hitpoints);
				}
				
				invincibleTimer++;
				
				if (invincibleTimer == 10)
				{        
					hit = false;                    
					invincibleTimer = 0;
				}
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
						
						case 1:
						case 2:
							hit = true;
							break;
								
						case 3:                     
							timeCurrent -= 1     
							timeCurrent = Math.max(timeCurrent, 0);
							break;
							
						}
						
						
						obstaclesToAnimate.splice(i, 1);
						this.removeChild(obstacleToTrack);
						
					}
					
					if (obstacleToTrack.x < -(obstacleToTrack.width / 2)) {
						
						obstaclesToAnimate.splice(i, 1);
						this.removeChild(obstacleToTrack);
						
					}
				}
			}
		}
		
		private function obstacleCreate():void {
			
			var obstacleCreated:Obstacle;
			var type:int;
			var starNum:int;
			var preY:int;
			//var preX:int = stage.stageWidth;
			
			if (elapsed == timeCurrent + 20) {
			
				type = 1 + Math.floor(Math.random() * 9);	// ésto devuelve un random de 1 a 10
				
				switch(type)
				{
				
					case 1:
					case 2:
					case 3:
					case 4:
						// this is the GREEN ENEMY
						obstacleCreated = new Obstacle(1);
						obstacleCreated.y = 100 + Math.floor(Math.random() * 700);	// MAGIC NUMBERS !! (where 100 is enemy.height/2 and 700 is stage.stageHeight - enemy.height/2)
						while (prevMinY < obstacleCreated.y && obstacleCreated.y < prevMaxY)
						{
							obstacleCreated.y = 100 + Math.floor(Math.random() * 700);
						}
						
						prevMinY = obstacleCreated.y - 100;	// MAGIC NUMBERS !!
						prevMaxY = obstacleCreated.y + 100;	// MAGIC NUMBERS !!
						//trace("BLOCKED RANGE: " + prevMinY + "-" + prevMaxY)
						
						obstacleCreated.x = stage.stageWidth + 100;	// // MAGIC NUMBERS !! (where 100 is enemy.widht/2)
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						elapsed = 0;
						
						redAvailable = true;
						
						break;
					
					case 5:	
					case 6:
					case 7:
						// this is the STAR
						starNum = 1 + Math.floor(Math.random() * 4);	// ésto devuelve un random de 1 a 5
						preY = Math.random() * stage.stageHeight;

						for (var ind:uint = 1; ind <= starNum; ind++)
						{
							obstacleCreated = new Obstacle(3);
							
							if (ind == 1)
							{
								while (preY - obstacleCreated.height / 2 < prevMinY && preY + obstacleCreated.height / 2 > prevMaxY && preY + obstacleCreated.height / 2 > stage.stageHeight && preY - obstacleCreated.height / 2 < 0)	//Aqui está el ultimo problema por solucionar, y que probablemente debido a que los sprites no estan como toca, no soy capaz de que funcione. Te dejo el resto a ti <3
								{
									preY = Math.floor(Math.random() * stage.stageHeight) +1;
									//trace("eh");
								}
								
								obstacleCreated.y = preY;
							}
							
							else
							{
								obstacleCreated.y = preY;
							}
							
							obstacleCreated.x = (stage.stageWidth + ind * 150 * 2/3);	// MAGIC NUMBERS !! 150 = star.width & .height
							this.addChild(obstacleCreated);
							obstaclesToAnimate.push(obstacleCreated);
							
							prevMinY = obstacleCreated.y - Math.floor(150/2);	// MAGIC NUMBERS !!
							prevMaxY = obstacleCreated.y + Math.floor(150/2);	// MAGIC NUMBERS !!
						}
						
						prevMaxY = preY - obstacleCreated.height / 2;
						prevMinY = preY + obstacleCreated.height / 2;
						elapsed = 0;
						
						redAvailable = true;
						
						break;	
					
					case 8:
					case 9:	
					case 10:
						// this is the RED ENEMY
						if (redAvailable)
						{
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
						elapsed = 0;
						
						break;
				}
			}
		}
	}
	
}