package objects
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Obstacle extends starling.display.Sprite
	{
		private var obstacleArt:Image;
		private var obstacleType:int;
		
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
			createObstacleArt();
			
		}
		
		private function createObstacleArt():void
		{
			obstacleArt = new Image(Assets.getTexture("invader"));
			obstacleArt.x = Math.ceil(-obstacleArt.width/2);
			obstacleArt.y = Math.ceil(-obstacleArt.height/2);
			this.addChild(obstacleArt);
		}
		
		private function onGameTick():void
		{
			this.x -= 10;
		}
	}
}