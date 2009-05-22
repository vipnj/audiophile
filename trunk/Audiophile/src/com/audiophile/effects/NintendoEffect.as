package com.audiophile.effects
{
	import com.audiophile.core.AudioSample;
	import com.audiophile.core.IAudioEffect;
	import com.audiophile.core.SampleChain;
	
	[EffectInfo(name="Nintendo")]
	public class NintendoEffect implements IAudioEffect
	{
		
		public function get multiplier():Number { return 1; }
		public function processSamples(samples:SampleChain):SampleChain {
			var sample:AudioSample = samples.first;
			while(sample) {
				var left:Number = Math.round(sample.left*127)/127;
				var right:Number = Math.round(sample.right*127)/127;
				for(var i:int = 0; i < 16; i++) {
					if(sample) {
						sample.left = left;
						sample.right = right;
						sample = sample.next;
					}
				}
			}
			return samples;
		}
		
		public function reset():void {}
		
	}
}