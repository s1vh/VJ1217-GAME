package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		[Embed(source = "../media/graphics/cat0000.png")]
		public static const cat:Class;
		
		[Embed(source = "../media/graphics/invader0000.png")]
		public static const invader:Class;
		
		[Embed(source = "../media/graphics/empezarplaceholder.png")]
		public static const empezar:Class;
		
		[Embed(source = "../media/graphics/tituloplaceholder.png")]
		public static const titulo:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined) 
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}
}