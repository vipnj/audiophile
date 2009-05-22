package com.audiophile.effects
{
	import com.audiophile.core.AudioSample;
	import com.audiophile.core.IAudioEffect;
	import com.audiophile.core.SampleChain;
	
	[EffectInfo(name="Distortion")]
	public class DistortionEffect implements IAudioEffect
	{
		
		[Parameter(min="1", max="10", step="0.1")]
		public var gain:Number = 7;
		
		[Parameter(min="0.1", max="0.9", step="0.01")]
		public var tone:Number = 0.75;
		
		[Parameter(min="0", max="1", step="0.01")]
		public var mix:Number = 0.7;
		
		//private var distortion:SampleChain = new SampleChain();
		
		public function get multiplier():Number { return 1; }
		public function processSamples(samples:SampleChain):SampleChain {
			var left:Number, right:Number;
			var sample:AudioSample = samples.first;
			var a:Number = tone/(1-tone);
			var pow:Function = Math.pow;
			while(sample) {
				left = sample.left*gain;
				if(left > tone) { left -= pow(left, a)/a; }
				if(left < -tone) { left += pow(left, a)/a; }
				
				right = sample.right*gain;
				if(right > tone) { right -= pow(right, a)/a; }
				if(right < -tone) { right += pow(right, a)/a; }
				
				sample.left = (sample.left*(2-mix) + left*mix)/2;
				sample.right = (sample.right*(2-mix) + right*mix)/2;
				
				sample = sample.next;
			}
			return samples;
		}
		
		public function reset():void {}
		
	}
}