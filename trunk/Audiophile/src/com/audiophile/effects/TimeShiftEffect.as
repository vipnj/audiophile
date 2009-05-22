package com.audiophile.effects
{
	import com.audiophile.core.AudioSample;
	import com.audiophile.core.IAudioEffect;
	import com.audiophile.core.SampleChain;
	
	[EffectInfo(name="Speed")]
	public class TimeShiftEffect implements IAudioEffect
	{
		
		[Parameter(min="-2", max="2")]
		public function get speed():Number { return _multiplier; }
		public function set speed(value:Number):void {
			_multiplier = value;
		}
		
		private var _multiplier:Number = 1;
		public function get multiplier():Number { return _multiplier; }
		public function set multiplier(value:Number):void {
			_multiplier = value;
		}
		
		private var output:SampleChain = new SampleChain();
		public function processSamples(samples:SampleChain):SampleChain {
			if(_multiplier == 1) { return samples; }
			
			var length:Number = Math.floor(samples.length*(1/_multiplier));
			if(Math.abs(length) > output.length) {
				output.adjust(Math.abs(length)); // needs some renaming
			}
			output.length = Math.abs(length);
			
			var position:int = 0;
			var sample:AudioSample = samples.first;
			var outputSample:AudioSample = output.first;
			for(var i:int = 0; i < Math.abs(length); i++) {
				var t:int = Math.abs(int(i*_multiplier));
				for(var j:int = 0; j < t-position; j++) {
					sample = sample.next;
					position++;
				}
				outputSample.left = sample.left;
				outputSample.right = sample.right;
				outputSample = outputSample.next;
			}
			output.length = Math.abs(length);
			return output;
		}
		
		// whoa, this is doing time independant pitch shifting
		// I'm not sure how. Saving it for later
		/*
		private var output:SampleChain;
		public function processSamples(samples:SampleChain):SampleChain {
			if(_multiplier == 1) { return samples; }
			
			output = new SampleChain();
			var position:int = 0;
			var length:Number = samples.length*(1/_multiplier);
			var sample:AudioSample = output.first = samples.first;
			var outputSample:AudioSample = sample;
			for(var i:int = 1; i < length; i++) {
				var t:int = int(i*_multiplier);
				for(var j:int = 0; j < t-position; j++) {
					sample = sample.next;
					position++;
				}
				outputSample = outputSample.next = sample;
			}
			output.length = length;
			return output;
		}
		*/
		public function reset():void {}
		
	}
}