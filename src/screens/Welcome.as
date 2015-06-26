package screens
{
	import com.greensock.TweenLite;
	
	import events.NavigationEvent;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Welcome extends starling.display.Sprite
	{
		private var title:Image;
		private var cat:Image;
		private var rainbow:Image;
		private var subtitle:Image;
		
		private var playBtn:Button;
		
		public function Welcome()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:starling.events.Event):void
		{
			
			
			drawScreen();
		}
		
		private function drawScreen():void
		{
			rainbow = new Image(Assets.getWelcomeAtlas().getTexture("welcome_rainbow"));
			rainbow.x = 0;
			rainbow.y = 0;
			this.addChild(rainbow);
			
			subtitle = new Image(Assets.getWelcomeAtlas().getTexture("welcome_super"));
			subtitle.x = 400;
			subtitle.y = 10;
			this.addChild(subtitle);
			
			title = new Image(Assets.getWelcomeAtlas().getTexture("welcome_title"));
			title.x = 440;
			title.y = 20;
			this.addChild(title);
			
			playBtn = new Button(Assets.getWelcomeAtlas().getTexture("welcome_start"));
			playBtn.x = 440;
			playBtn.y = 500;
			this.addChild(playBtn);
			
			cat = new Image(Assets.getWelcomeAtlas().getTexture("welcome_cat"));
			cat.x = 0;
			cat.y = 200;
			this.addChild(cat);
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
		}
		
		private function onMainMenuClick(event:starling.events.Event):void
		{
			var buttonClicked:Button = event.target as Button;
			if ((buttonClicked as Button) == playBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id: "play" }, true));
			}
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
		}
		
		
	}
	
}
