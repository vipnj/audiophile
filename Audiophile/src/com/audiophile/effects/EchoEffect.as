package com.audiophile.effects
{
	import com.audiophile.core.AudioSample;
	import com.audiophile.core.IAudioEffect;
	import com.audiophile.core.SampleChain;
	
	[EffectInfo(name="Echo")]
	public class EchoEffect implements IAudioEffect
	{
		
		[Parameter(min="0", max="3000", step="1")]
		public var delay:uint;
		
		[Parameter(min="0", max="1", step="0.01")]
		public var mix:Number = 0.5;
		
		public function EchoEffect(delay:int = 500)
		{
			this.delay = delay;
			reset();
		}
		
		public function get multiplier():Number { return 1; }
		
		private var line:SampleChain;
		private var lastSample:AudioSample;
		public function processSamples(samples:SampleChain):SampleChain {
			/*var temp:Vector.<Number> = array.concat();
			if(buffer && buffer.length >= bufferSize) {
				var echo:Vector.<Number> = buffer.splice(0, array.length);
				AudioUtil.mix(array, [array, echo]);
			}
			buffer = buffer.concat(temp);*/
			var sample:AudioSample = samples.first;
			while(sample) {
				var left:Number = sample.left;
				var right:Number = sample.right;
				
				var lineSample:AudioSample = line.first;
				sample.left = (left*(2-mix) + lineSample.left*mix)/2;
				sample.right = (right*(2-mix) + lineSample.right*mix)/2;
				
				// recycle line sample
				lineSample.left = left;
				lineSample.right = right;
				line.first = lineSample.next;
				line.last.next = lineSample;
				line.last = lineSample;
				lineSample.next = null;
				
				sample = sample.next;
			}
			return samples;
		}
		
		public function reset():void {
			line = new SampleChain();
			line.adjust(delay*44.1);
		}
		
	}
}