package com.audiophile.synth
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Point;
	
	public class VolumeEnvelope
	{
		
		public var controls:Vector.<Point>;
		public var values:Vector.<Number>;
		
		public function VolumeEnvelope()
		{
			controls = new Vector.<Point>();
			controls[0] = new Point(0, 0);
			controls[1] = new Point(0.3, 1);
			controls[2] = new Point(0.7, 1);
			controls[3] = new Point(1, 0);
			values = new Vector.<Number>();
		}
		
		public function adjust(count:Number):void {
			count = Math.abs(count); // should reverse on negative?
			if(count != values.length) {
				generateValues(count);
			}
		}
		
		private function generateValues(count:Number):void {
			values = new Vector.<Number>(count);
			var targetIndex:int = 1;
			var marker:Point = new Point(controls[0].x*count, controls[0].y);
			var target:Point = new Point(controls[targetIndex].x*count, controls[targetIndex].y);
			for(var i:int = 0; i < count; i++) {
				// linear interpolation
				values[i] = marker.y + (i-marker.x)*(target.y-marker.y)/(target.x-marker.x);
				if(i > target.x) {
					targetIndex++;
					marker = target;
					target = new Point(controls[targetIndex].x*count, controls[targetIndex].y);
				}
			}
		}
	}
}