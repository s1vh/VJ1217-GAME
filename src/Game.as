package src
{
	import screens.Welcome;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var screenWelcome:Welcome;
		
		public function Game()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("Starling framework initialized! ");
			
			screenWelcome = new Welcome();
			this.addChild(screenWelcome);
		}
	}
}