package com.audiophile.synth
{
	
	import com.audiophile.core.AudioSample;
	import com.audiophile.core.IAudioEffect;
	import com.audiophile.core.IAudioInput;
	import com.audiophile.core.SampleChain;
	
	public class SineWave implements IAudioInput
	{
		
		private const PI2:Number = Math.PI*2;
		
		private var phase:Number = 0;
		private var vector:Number = 0;
		private var leftMultiplier:Number = 0.2;
		private var rightMultiplier:Number = 0.2;
		
		public function SineWave(frequency:Number = 440)
		{
			this.frequency = frequency;
			calculateMultipliers();
		}
		
		private var _frequency:Number;
		public function get frequency():Number { return _frequency; }
		public function set frequency( value:Number ):void {
			_frequency = value;
			vector = _frequency*(PI2/44100);
		}
		
		
		//******************************************************
		// IAudio Implementation
		//******************************************************
		
		//public function get type():int { return 2; }
		
		private var _effects:Array;
		public function get effects():Array { return _effects; }
		public function set effects(value:Array):void {
			_effects = value;
		}
		
		private var _volume:Number = 0.2; // default volume is low so we don't take out the speakers :-)
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void {
			_volume = value;
			calculateMultipliers();
		}
		
		private var _pan:Number = 0;
		public function get pan():Number { return _pan; }
		public function set pan(value:Number):void {
			_pan = value;
			calculateMultipliers()
		}
		
		private function calculateMultipliers():void {
			leftMultiplier = _volume * (1+_pan*-1);
			rightMultiplier = _volume * (1+_pan);
		}
		
		//*********************************************************************************
		// IAudioInput Implementation
		//*********************************************************************************
		
		private var samples:SampleChain = new SampleChain();
		public function readSamples(count:int, position:int = -1):SampleChain {
			samples.adjust(count);
			var sin:Function = Math.sin;
			var sample:AudioSample = samples.first;
			for(var i:int = 0; i < count; ++i) {
				phase += vector; // progress phase by vector
				if(phase > PI2) { phase -= PI2; } // prevent phase from overflowing.
				sample.left = sin(phase) * leftMultiplier + 1e-18 - 1e-18; // avoiding denormals
				sample.right = sin(phase) * rightMultiplier + 1e-18 - 1e-18;
				sample = sample.next;
			}
			for each(var effect:IAudioEffect in _effects) {
				effect.processSamples(samples);
			}
			return samples;
		}
		
	}
}