package screens
{
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
		
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
		
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		
		private var gameState:String;
		private var playerSpeed:Number;
		private var hitObstacle:Number = 0;
		private const MIN_SPEED:Number = 650;
		
		private var scoreDistance:int;
		private var obstacleGapCount:int;
		
		private var gameArea:Rectangle;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		
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
									
			gameArea = new Rectangle(0, 100, stage.stageWidth, stage.stageHeight - 250);
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
			
			this.addEventListener(Event.ENTER_FRAME, checkElapsed);
			cat.x = -stage.stageWidth;
			cat.y = stage.stageHeight * 0.5;
			
			gameState = "idle";
			trace("probando probando");
			playerSpeed = 0;
			hitObstacle = 0;
			
			scoreDistance = 0;
			obstacleGapCount = 0;
			
			this.launchCat();
									
		}
		
		
		
		private function launchCat():void
		{
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(stage);
			
			touchX = touch.globalX;
			touchY = touch.globalY;
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
					
					if (hitObstacle <= 0)
					{
						cat.y -= (cat.y - touchY) * 0.1;
						
						if (-(cat.y - touchY) < 150 && -(cat.y - touchY) > -150)
						{
							cat.rotation = deg2rad(-(cat.y - touchY) * 0.2);
						}
						
						if (cat.y > gameArea.bottom - cat.height * 0.5)
						{
							cat.y = gameArea.bottom - cat.height * 0.5;
							cat.rotation = deg2rad(0);
						}
						if (cat.y < gameArea.top + cat.height * 0.5)
						{
							cat.y = gameArea.top + cat.height * 0.5;
							cat.rotation = deg2rad(0);
						}
					}
					else
					{
						hitObstacle--;
						cameraShake();
					}
					
					playerSpeed -= (playerSpeed - MIN_SPEED) * 0.01;
					
					scoreDistance += (playerSpeed * elapsed) * 0.1;
					
					break;
				case "over":
					break;
			}
		}
		
		private function cameraShake():void
		{
			if (hitObstacle > 0)
			{
				this.x = int(Math.random() * hitObstacle);
				this.y = int(Math.random() * hitObstacle);
			}
			else if (x != 0)
			{
				this.x = 0;
				this.y = 0;
			}
		}
						
		private function checkElapsed(event:Event):void
		{
			timePrevious = timeCurrent;
			timeCurrent = getTimer();
			elapsed = (timeCurrent - timePrevious) * 0.001;
		}
	}
}