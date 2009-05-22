package com.audiovision.utils
{
	
	import flash.display.*;
	import flash.geom.Rectangle;
	
	import mx.graphics.GradientEntry;
	import mx.graphics.IFill;
	import mx.graphics.LinearGradient;
	
	public class PaletteMapUtil
	{
		
		public static function createBlankPalette():Array {
			var palette:Array = new Array(256);
			for(var i:int = 0; i < 256; i++) {
				palette[i] = 0;
			}
			return palette;
		}
		
		public static function convertColorsToPalette(colors:Array, alphas:Array):Array {
			var fill:LinearGradient = new LinearGradient();
			var entries:Array = new Array(colors.length);
			for(var i:int = 0; i < colors.length; i++) {
				entries[i] = new GradientEntry(colors[i], -1, alphas[i]);
			}
			fill.entries = entries;
			return convertFillToPalette(fill);
		}
		
		public static function convertFillToPalette(fill:IFill):Array {
			var sprite:Sprite = new Sprite();
			var graphics:Graphics = sprite.graphics;
			var rectangle:Rectangle = new Rectangle(0, 0, 256, 256);
			fill.begin(graphics, rectangle);
			graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
			fill.end(graphics);
			return convertDrawableToPalette(sprite);
		}
		
		public static function convertDrawableToPalette(display:IBitmapDrawable):Array {
			var bitmapData:BitmapData = new BitmapData(256, 256, true, 0x00000000);
			bitmapData.draw(display);
			return convertBitmapToPalette(bitmapData);
		}
		
		public static function convertBitmapToPalette(bitmapData:BitmapData):Array {
			var palette:Array = new Array(256);
			for(var i:int = 0; i < 256; i++) {
				var percent:Number = i/256;
				var vectorX:uint = percent > 0 ? percent * bitmapData.width : 0;
				var vectorY:uint = percent > 0 ? percent * bitmapData.height : 0;
				var pixel:uint = bitmapData.getPixel32(vectorX, vectorY);
				palette[i] = pixel;
			}
			palette[0] = 0;
			return palette;
		}
		
	}
}