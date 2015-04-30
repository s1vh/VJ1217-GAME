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
		
		private var playBtn:Button;
		
		public function Welcome()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:starling.events.Event):void
		{
			trace("ESTA ES LA ALARMA DE QUE LA PANTALLA DE INICIO VA COMO DIOS MANDA");
			
			drawScreen();
		}
		
		private function drawScreen():void
		{
			title = new Image(Assets.getTexture("titulo"));
			title.x = 530;
			title.y = 100;
			this.addChild(title);
			
			playBtn = new Button(Assets.getTexture("empezar"));
			playBtn.x = 520;
			playBtn.y = 500;
			this.addChild(playBtn);
			
			cat = new Image(Assets.getTexture("cat"));
			this.addChild(cat);
			cat.x = -cat.width;
			cat.y = 100;
			
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
			
			if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, heroAnimation);
		}
		
		public function initialize():void
		{
			this.visible = true;
			
			cat.x = -cat.width;
			cat.y = 300;
			
			TweenLite.to(cat, 2, { x: 540 } );
			
			this.addEventListener(Event.ENTER_FRAME, heroAnimation);
		}
		
		private function heroAnimation(event:starling.events.Event):void
		{
			var currentDate:Date = new Date();
			cat.y = 300 + (Math.cos(currentDate.getTime() * 0.002) * 25);
			playBtn.y = 500 + (Math.cos(currentDate.getTime() * 0.002) * 10);
		}
	}
	
}
