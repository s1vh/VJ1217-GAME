package objects
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Cat extends starling.display.Sprite
	{
		private var catArt:Image;
		
		public function Cat()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createCatArt();
		}
		
		private function createCatArt():void
		{
			catArt = new Image(Assets.getTexture("cat"));
			catArt.x = Math.ceil(-catArt.width/2);
			catArt.y = Math.ceil(-catArt.height/2);
			this.addChild(catArt);
		}
	}
}