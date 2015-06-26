package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		private static var welcomeTextureAtlas:TextureAtlas;
		
		[Embed(source = "../media/graphics/welcomeScreen_sheet.png")]
		public static const AtlasTextureWelcome:Class;
		
		[Embed(source = "../media/graphics/star0000.png")]
		public static const star:Class;
		
		[Embed(source = "../media/graphics/welcomeScreen_sheet.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlWelcome:Class;
		
		[Embed(source = "../media/graphics/gameSprites_sheet.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source = "../media/graphics/gameSprites_sheet.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined) 
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		public static function getAtlas():TextureAtlas
		{
			if (gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		
		public static function getWelcomeAtlas():TextureAtlas
		{
			if (welcomeTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureWelcome");
				var xml:XML = XML(new AtlasXmlWelcome());
				welcomeTextureAtlas = new TextureAtlas(texture, xml);
			}
			return welcomeTextureAtlas;
		}
	}
}