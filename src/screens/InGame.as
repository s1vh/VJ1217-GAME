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
		private var previousXMin:int = -500;
		private var previousXMax:int = 1000;
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
						
						obstacleCheck();
						obstacleCreate();
						//trace(enemigoCreado);
			}
			
			
			}
		}
		private function obstacleCheck():void
		{
			var obstacleToTrack:Obstacle;
			if (enemigoCreado > 1)
			{
				for (var i:uint = 0; i < obstaclesToAnimate.length; i++)
				{
					obstacleToTrack = obstaclesToAnimate[i]
					if (obstacleToTrack.bounds.intersects(cat.bounds) && hit == false)
					{
						switch(obstacleToTrack.type) {
						case 1:
							hit = true;
							break;
						case 2: 
							hit = true;
							break;
						default: 
							timeCurrent -= 0.5
							break;
						}
						obstaclesToAnimate.splice(i, 1);
						this.removeChild(obstacleToTrack);
						enemigoCreado--;
						
					}
					if (obstacleToTrack.x < -(obstacleToTrack.width / 2)) {
					
						obstaclesToAnimate.splice(i, 1);
						this.removeChild(obstacleToTrack);
						enemigoCreado--;
					}
				}
			}
		}
		
		private function obstacleCreate():void {
			
			var obstacleCreated:Obstacle;
			var type:int;
			var stars:int;
			var preY:int;
			if (elapsed == timeCurrent + 20) {
			
				type = Math.round(Math.random() * 9) + 1;
				//trace(type);
				switch(type) {
				
					case 1:
						obstacleCreated = new Obstacle(1);
						obstacleCreated.y = Math.random() * stage.stageHeight;
						obstacleCreated.x = stage.stageWidth + obstacleCreated.width / 2;
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						enemigoCreado++;
						elapsed = 0;
						break;
						
					case 2:
						obstacleCreated = new Obstacle(1);
						obstacleCreated.y = Math.random() * stage.stageHeight;
						obstacleCreated.x = stage.stageWidth + obstacleCreated.width / 2;
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						enemigoCreado++;
						elapsed = 0;
						break;
						
					case 3:
						obstacleCreated = new Obstacle(1);
						obstacleCreated.y = Math.random() * stage.stageHeight;
						obstacleCreated.x = stage.stageWidth + obstacleCreated.width / 2;
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						enemigoCreado++;
						elapsed = 0;
						break;
					
					case 4:
						obstacleCreated = new Obstacle(1);
						obstacleCreated.y = Math.random() * stage.stageHeight;
						obstacleCreated.x = stage.stageWidth + obstacleCreated.width / 2;
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						enemigoCreado++;
						elapsed = 0;
						break;
						
					case 5:
						obstacleCreated = new Obstacle(1);
						obstacleCreated.y = Math.random() * stage.stageHeight;
						obstacleCreated.x = stage.stageWidth + obstacleCreated.width / 2;
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						enemigoCreado++;
						elapsed = 0;
						break;
						
					case 6:
						obstacleCreated = new Obstacle(1);
						obstacleCreated.y = Math.random() * stage.stageHeight;
						obstacleCreated.x = stage.stageWidth + obstacleCreated.width / 2;
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						enemigoCreado++;
						elapsed = 0;
						break;
						
					case 7:
						stars = Math.round(Math.random() * 2) + 3;
						trace(stars);
						obstacleCreated = new Obstacle(3);
						obstacleCreated.y = Math.random() * stage.stageHeight;
						preY = obstacleCreated.y;
						obstacleCreated.x = stage.stageWidth + obstacleCreated.width / 2;
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						for (var i:uint = 2; i <= stars; i++) {
							trace("urp");
							obstacleCreated = new Obstacle(3);
							obstacleCreated.y = preY;
							obstacleCreated.x = stage.stageWidth + ((obstacleCreated.width / 2) * i);
							this.addChild(obstacleCreated);
							obstaclesToAnimate.push(obstacleCreated);
						}
						enemigoCreado++;
						elapsed = 0;
						break;
						
					case 8:
						stars = Math.round(Math.random() * 2) + 3;
						trace(stars);
						obstacleCreated = new Obstacle(3);
						obstacleCreated.y = Math.random() * stage.stageHeight;
						preY = obstacleCreated.y;
						obstacleCreated.x = stage.stageWidth + obstacleCreated.width / 2;
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						for (var j:uint = 2; j <= stars; j++) {
							trace("urp");
							obstacleCreated = new Obstacle(3);
							obstacleCreated.y = preY;
							obstacleCreated.x = stage.stageWidth + ((obstacleCreated.width / 2) * j);
							this.addChild(obstacleCreated);
							obstaclesToAnimate.push(obstacleCreated);
						}
						enemigoCreado++;
						elapsed = 0;
						break;
						
					case 9:
						obstacleCreated = new Obstacle(3);
						obstacleCreated.y = Math.random() * stage.stageHeight;
						obstacleCreated.x = stage.stageWidth + obstacleCreated.width / 2;
						this.addChild(obstacleCreated);
						obstaclesToAnimate.push(obstacleCreated);
						enemigoCreado++;
						elapsed = 0;
						break;
						
					case 10:
						obstacleCreated = new Obstacle(2);
						obstacleCreated.y = Math.random() * stage.stageHeight;
					    obstacleCreated.x = stage.stageWidth + obstacleCreated.width / 2;
					    this.addChild(obstacleCreated);
					    obstaclesToAnimate.push(obstacleCreated);
					    enemigoCreado++;
					    elapsed = 0;
						break;
				}
				
			}
		}
		
		
	}
}