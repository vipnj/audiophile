package com.audiovision.filters
{
	
	import com.audiovision.utils.PaletteMapUtil;
	
	import flash.display.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	
	public class PaletteMapFilter implements ICustomFilter
	{
		
		private var point:Point = new Point(0, 0);
		
		public var red:Array = PaletteMapUtil.createBlankPalette();
		public var green:Array = PaletteMapUtil.createBlankPalette();
		public var blue:Array = PaletteMapUtil.createBlankPalette();
		public var alpha:Array = PaletteMapUtil.createBlankPalette();
		
		public function apply(bitmapData:BitmapData, rectangle:Rectangle):void {
			bitmapData.paletteMap(bitmapData, rectangle, point, red, green, blue, alpha);
		}

	}
}