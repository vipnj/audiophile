package com.audiovision.filters
{
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public interface ICustomFilter
	{
		function apply(bitmapData:BitmapData, rectangle:Rectangle):void;
	}
}