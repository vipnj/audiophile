package com.audiovision.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	
	public class DisplacementMapUtil
	{
		
		public static function createSplit(width:Number, height:Number):BitmapData {
			if(width <= 0 || height <= 0) { return new BitmapData(1, 1, true, 0); }
			var bitmap:BitmapData = new BitmapData(width, height, false);
			var rectangle:Rectangle = new Rectangle(0, 0, width, 2);
			for (var i:int = 0; i < height/2; i++) {
				rectangle.y = i*2;
				bitmap.fillRect(rectangle, i % 2 ? 0x007F00 : 0xFF7F00);
			}
			return bitmap;
		}
		
		public static function createTunnel(width:Number, height:Number):BitmapData {
			if(width <= 0 || height <= 0) { return new BitmapData(1, 1, true, 0); }
			var sprite:Sprite = new Sprite();
			var bitmap:BitmapData = new BitmapData(width, height, false);
			var rectangle:Rectangle = new Rectangle(0, 0, width/2, height/2); // quadrant
			var fill:LinearGradient = new LinearGradient();
			
			// top left quadrant
			//fill.rotation = 45;
			fill.angle = 45
			fill.entries = [new GradientEntry(0xFFFF00), new GradientEntry(0x7F7F00)];
			fill.begin(sprite.graphics, rectangle);
			sprite.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
			fill.end(sprite.graphics);
			
			// top right quadrant
			rectangle.x = width/2;
			fill.angle = -45;
			fill.entries = [new GradientEntry(0x7F7F00), new GradientEntry(0x00FF00)]; // 0x448800, 0x00FF00
			fill.begin(sprite.graphics, rectangle);
			sprite.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
			fill.end(sprite.graphics);
			
			// bottom right quadrant
			rectangle.y = height/2;
			fill.angle = 45;
			fill.entries = [new GradientEntry(0x7F7F00), new GradientEntry(0x000000)];
			fill.begin(sprite.graphics, rectangle);
			sprite.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
			fill.end(sprite.graphics);
			
			//bottom left quadrant
			rectangle.x = 0;
			fill.angle = -45;
			fill.entries = [new GradientEntry(0xFF0000), new GradientEntry(0x7F7F00)];
			fill.begin(sprite.graphics, rectangle);
			sprite.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
			fill.end(sprite.graphics);
			
			bitmap.draw(sprite);
			return bitmap;
		}
		

	}
}