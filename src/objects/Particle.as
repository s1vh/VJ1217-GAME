package objects 
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Particle extends Sprite
	{
		private var _speedX:Number;
		private var _speedY:Number;
		private var _spin:Number;
		private var _image:Image;
		
		
		public function Particle() 
		{
			super();
			
			_image = new Image(Assets.getTexture("particle"));
			_image.x = _image.width / 2;
			_image.y = _image.height / 2;
			this.addChild(_image);
		}
		
		public function get speedX():Number 
		{
			return _speedX;
		}
		
		public function set speedX(value:Number):void 
		{
			_speedX = value;
		}
		
		public function get speedY():Number 
		{
			return _speedY;
		}
		
		public function set speedY(value:Number):void 
		{
			_speedY = value;
		}
		
		public function get spin():Number 
		{
			return _spin;
		}
		
		public function set spin(value:Number):void 
		{
			_spin = value;
		}
		
	}

}