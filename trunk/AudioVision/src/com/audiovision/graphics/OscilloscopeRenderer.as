package com.audiovision.graphics
{
	import __AS3__.vec.Vector;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	public class OscilloscopeRenderer
	{
		
		public function render(samples:Vector.<Number>, graphics:Graphics, rectangle:Rectangle):void {
			
			var length:Number = samples.length;
			var center:Number = rectangle.height/2;
			var sampleWidth:Number = rectangle.width/(length-1);
			
			graphics.moveTo( rectangle.x, center + samples[i]*center );
			for (var i:uint = 1; i < length; i++) {
				graphics.lineTo(i*sampleWidth, center + samples[i]*center);
			}
			
		}
		
	}
}