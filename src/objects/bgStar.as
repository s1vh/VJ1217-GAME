package objects 
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.display.Graphics;
	
	public class bgStar extends Sprite
	{
		private var starArt:MovieClip;
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
			animate();
		}		
		
		private function animate():void
		{
			starArt = new MovieClip(Assets.getAtlas().getTextures("backgroundStar"), 3);
		}
		
	}

}