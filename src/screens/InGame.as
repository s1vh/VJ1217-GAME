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
		private var enemigocreado:int = 0;
		
		private var timePrevious:Number;
		private var timeCurrent:Number = 50;
		private var elapsed:Number = 0;
		
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
			trace(stage.stageHeight);
			trace(stage.stageWidth);
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
			if (touch != null) touchY = touch.globalY;
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
						
						if (-(cat.y - touchY) < cat.height/2 && -(cat.y - touchY) > -cat.height/2)
						{
							cat.rotation = deg2rad(-(cat.y - touchY) * 0.2);
						}
						
						if (cat.y > 800 - cat.height * 0.5)
						{
							cat.y = 800 - cat.height * 0.5;
							cat.rotation = deg2rad(0);
						}
						if (cat.y < cat.height * 0.5)
						{
							cat.y = cat.height * 0.5;
							cat.rotation = deg2rad(0);
						}
						if (elapsed == timeCurrent)
						{
							obstacle = new Obstacle(1);
							obstacle.x = stage.stageWidth + obstacle.width*2;
			                obstacle.y = Math.random() * 800;
							if (obstacle.y > 800 - obstacle.height * 0.5) obstacle.y = 800 - obstacle.height*2;
						    if (obstacle.y < obstacle.height * 0.5) obstacle.y = obstacle.height*2;
			                this.addChild(obstacle);
							enemigocreado++;
							elapsed = 0;
							trace(enemigocreado);
						}
						if (enemigocreado >= 1)
						{
							if (obstacle.x < -50)
							{
								this.removeChild(obstacle);
								trace("eh! ");
								enemigocreado--;
							}
							
						}
						
					}
					else
					{
						hitObstacle--;
						cameraShake();
						trace("auch! ");
					}
					
					playerSpeed -= (playerSpeed - MIN_SPEED) * 0.01;
					
					scoreDistance += (playerSpeed * elapsed) * 0.1;
					
					break;
					
				case "over":
					trace("eh D:");
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
	}
}
