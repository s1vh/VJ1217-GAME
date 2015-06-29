package screens 
{
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.events.Event;
	import events.NavigationEvent;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class GameOver extends starling.display.Sprite
	{
		private var scoreText:TextField;		
		private var starBtn:Button;
		private var score:int = 0;
		
		public function GameOver() 
		{
			super();
		}
		
		public function initialize():void
		{
			this.visible = true;
			starBtn = new Button(Assets.getTexture("star"));
			starBtn.x = (stage.stageWidth/2)-200;
			starBtn.y = (stage.stageHeight / 2) - 100;
			scoreText = new TextField(100, 100, score.toString(), Assets.get48Font().name, 24, 0xffffff); //if you know how to pass score into the game over screen, assign it to this score variable
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			scoreText.y = starBtn.y + 55;
			scoreText.x = starBtn.x + starBtn.width / 2 + 40;
			this.addChild(scoreText);
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