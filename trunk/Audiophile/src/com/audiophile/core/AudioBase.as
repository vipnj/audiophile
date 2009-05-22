package com.audiophile.core
{
	public class AudioBase
	{
		
		private var _effects:Array;
		public function get effects():Array { return _effects; }
		public function set effects(value:Array):void {
			_effects = value;
		}
		
		private var _volume:Number = 1;
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void {
			_volume = value;
		}
		
		private var _pan:Number = 0;
		public function get pan():Number { return _pan; }
		public function set pan(value:Number):void {
			_pan = value;
		}
		
		protected function process(samples:Vector.<Number>):void {
			/*for each(var effect:IAudioEffect in effects) {
				effect.processSamples(samples);
			}*/
		}
		
	}
}