package
{
	import flash.display.Sprite;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	[SWF(framerate = "60", width = "1280", height = "800", backgroundColor = "0xFFFFFF")]
	public class Main extends Sprite
	{
		
		private var stats:Stats;
		private var myStarling:Starling;
		
		public function Main()
		{
			stats = new Stats();
			this.addChild(stats);
			
			myStarling = new Starling(Game, stage);
			myStarling.antiAliasing = 1;
			myStarling.start();
		}
	}
}