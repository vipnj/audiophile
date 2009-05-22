package com.audiophile.audio
{
	import com.audiophile.core.IAudioEffect;
	import com.audiophile.core.IAudioInput;
	import com.audiophile.core.IAudioRegion;
	import com.audiophile.core.IAudioTime;
	import com.audiophile.core.SampleChain;
	
	public class AudioRegion implements IAudioInput, IAudioTime, IAudioRegion
	{
		
		private var audioTime:IAudioTime;
		
		private var _audio:IAudioInput;
		private var _begin:Number = 0;
		private var _end:Number = Number.MAX_VALUE;
		
		public function get audio():IAudioInput { return _audio; }
		public function set audio(value:IAudioInput):void {
			_audio = value;
			if(_audio is IAudioTime) {
				audioTime = _audio as IAudioTime;
			}
		}
		
		public function get begin():Number { return _begin; }
		public function set begin(value:Number):void {
			_begin = value;
		}
		
		public function get end():Number {
			return audioTime ? Math.min(_end, audioTime.length) : _end;
		}
		public function set end(value:Number):void {
			_end = value;
		}
		
		//******************************************************
		// IAudioTime Implementation
		//******************************************************
		
		public function get position():Number {
			return samplePosition/44.1;
		}
		public function set position(value:Number):void {
			samplePosition = value*44.1;
		}
		
		public function get length():Number {
			return _end-_begin;
		}
		
		private var _effects:Array; [Bindable]
		public function get effects():Array { return _effects; }
		public function set effects(value:Array):void {
			_effects = value;
		}
		
		public function clone():AudioRegion {
			var instance:AudioRegion = new AudioRegion();
			instance.audio = this.audio;
			instance.begin = this.begin;
			instance.end = this.end;
			instance.position = this.position;
			return instance;
		}
		
		private var samplePosition:Number = 0;
		public function readSamples(count:int, position:int = -1):SampleChain {
			count = count*multiplier;
			
			var output:SampleChain = _audio.readSamples(count, samplePosition + _begin*44.1);
			for each(var effect:IAudioEffect in effects) {
				output = effect.processSamples(output);
			}
			
			if(position > -1) {
				samplePosition = position + count;
			} else { samplePosition += count; }
			
			return output;
		}
		
		private function get multiplier():Number {
			var m:Number = 1;
			for each(var e:IAudioEffect in effects) {
				m *= e.multiplier;
			}
			return m;
		}
		
	}
}