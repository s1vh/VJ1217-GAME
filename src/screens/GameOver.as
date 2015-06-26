package screens 
{
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.events.Event;
	import events.NavigationEvent;
	
	public class GameOver extends starling.display.Sprite
	{
		private var score:int;
		
		private var starBtn:Button;
		
		public function GameOver() 
		{
			super();
		}
		
		public function initialize():void
		{
			this.visible = true;
			starBtn = new Button(Assets.getTexture("star"));
			starBtn.x = 200;
			starBtn.y = 200;
			this.addChild(starBtn);
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
		}
		
		private function onMainMenuClick(event:Event):void
		{
			var buttonClicked:Button = event.target as Button;
			if ((buttonClicked as Button) == starBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id: "welcome" }, true));
			}
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
	}

}