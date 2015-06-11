package objects
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.display.Graphics;
	
	public class Obstacle extends starling.display.Sprite
	{
		private var obstacleArt:Image;
		private var obstacleType:int;
		private var difficulty:int;
		private var currentDate:Date = new Date();
		
		public function Obstacle(type:int)
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			obstacleType = type;
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
			createObstacleArt(this.obstacleType);
			
		}
		
		private function createObstacleArt(spriteType:int):void
		{
			obstacleArt = new Image(Assets.getTexture("sprite"+spriteType));
			obstacleArt.x = Math.ceil(-obstacleArt.width/2);
			obstacleArt.y = Math.ceil(-obstacleArt.height/2);
			this.addChild(obstacleArt);
		}
		
		private function onGameTick():void
		{
			if (this.obstacleType == 2) {
				this.x -= 10;
				this.y += Math.cos(this.x * 0.015) * 25;
			}else this.x -= 10;
				
			
			
		}
		
		public function get type():int {
			return obstacleType;
		}
		
		public function set speed(_speed:int):void {
				this.difficulty = _speed;
		}
	}
}