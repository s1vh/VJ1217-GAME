package src
{
	import flash.display.Sprite;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60", width="1280", height="800", backgroundColor="0x000000")]
	public class StarlingProject extends Sprite
	{
		
		private var stats:Stats;
		private var myStarling:Starling;
		
		public function StarlingProject()
		{
			stats = new Stats();
			this.addChild(stats);
			
			myStarling = new Starling(Game, stage);
			myStarling.antiAliasing = 2;
			myStarling.start();
		}
	}
}