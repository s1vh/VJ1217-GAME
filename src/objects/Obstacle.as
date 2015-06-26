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
		private var obstacleArt:MovieClip;
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
			switch(spriteType) {
				case 1:
					obstacleArt = new MovieClip(Assets.getAtlas().getTextures("invader00"), 20);
					break;
				case 2:
					obstacleArt = new MovieClip(Assets.getAtlas().getTextures("destructor00"), 20);
					break;
				case 3:
					obstacleArt = new MovieClip(Assets.getAtlas().getTextures("star00"), 20);
					break;
			}
			obstacleArt.x = Math.ceil(-obstacleArt.width/2);
			obstacleArt.y = Math.ceil(-obstacleArt.height / 2);
			starling.core.Starling.juggler.add(obstacleArt);
			this.addChild(obstacleArt);
		}
		
		private function onGameTick():void
		{
			if (this.obstacleType == 2)
			{
				this.x -= 10;
				this.y += Math.cos(this.x * 0.005) * 10;
			}
			
			else this.x -= 10;
			
		}
		
		public function get type():int {
			return obstacleType;
		}
		
		public function set speed(_speed:int):void {
				this.difficulty = _speed;
		}
	}
}