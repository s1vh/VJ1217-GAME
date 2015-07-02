package 
{
	import flash.media.Sound;
	
	public class Sounds 
	{
		
		[Embed(source = "../media/Music_Sounds/NyanLoop.mp3")]
		public static const SND_BG_GAME:Class;
		
		public static var sndBgMain:Sound = new Sounds.SND_BG_GAME() as Sound;
		
		public static var muted:Boolean = false;
		
	}

}