package com.audiophile.audio
{
	
	import com.audiophile.core.AudioSample;
	import com.audiophile.core.IAudio;
	import com.audiophile.core.IAudioEffect;
	import com.audiophile.core.IAudioInput;
	import com.audiophile.core.IAudioTime;
	import com.audiophile.core.SampleChain;
	
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	
	public class AudioSound implements IAudio, IAudioInput, IAudioTime
	{
		
		private var _sound:Sound; [Bindable]
		public function get sound():Sound { return _sound; }
		public function set sound(value:Sound):void {
			_sound = value;
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
			// changing behavior to best guess length while loading
			return sound.length * (sound.bytesTotal/sound.bytesLoaded);
		}
		
		//******************************************************
		// IAudio Implementation
		//******************************************************
		
		private var leftMultiplier:Number = 1;
		private var rightMultiplier:Number = 1;
		
		private var _effects:Array; [Bindable]
		public function get effects():Array { return _effects; }
		public function set effects(value:Array):void {
			_effects = value;
		}
		
		private var _volume:Number = 1;
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void {
			_volume = value;
			calculateMultipliers()
		}
		
		private var _pan:Number = 0;
		public function get pan():Number { return _pan; }
		public function set pan(value:Number):void {
			_pan = value;
			calculateMultipliers()
		}
		
		public function AudioSound(stream:URLRequest = null) {
			//super(stream, null);
			sound = new Sound(stream);
		}
		
		//*********************************************************************************
		// IAudioInput Implementation
		//*********************************************************************************
		
		//private var bufferLength:int = 0;
		private var samplePosition:int = 0;
		
		private function get multiplier():Number {
			var m:Number = 1;
			for each(var e:IAudioEffect in effects) {
				m *= e.multiplier;
			}
			return m;
		}
		
		private function calculateMultipliers():void {
			leftMultiplier = _volume*(1+_pan*-1);
			rightMultiplier = _volume*(1+_pan);
		}
		
		private var bytes:ByteArray = new ByteArray();
		private var samples:SampleChain = new SampleChain();
		public function readSamples(count:int, position:int = -1):SampleChain {
			count = count*multiplier;
			samples.adjust(count); // needs some renaming
			
			bytes.position = 0;
			_sound.extract(bytes, Math.abs(count), (count < 0) ? samplePosition + count : position);
			bytes.position = 0;
			
			var lastSample:AudioSample;
			var length:Number = Math.abs(count);
			var sample:AudioSample = samples.first;
			for(var i:int = 0; i < length; ++i) {
				sample.left = bytes.readFloat() * leftMultiplier;
				sample.right = bytes.readFloat() * rightMultiplier;
				if(count > 0) {
					sample = sample.next;
				} else {
					var temp:AudioSample = sample.next;
					sample.next = lastSample;
					lastSample = sample;
					sample = temp;
				}
			}
			if(count < 0) { samples.first = lastSample; }
			
			var output:SampleChain = samples;
			for each(var effect:IAudioEffect in effects) {
				output = effect.processSamples(output);
			}
			
			if(position > -1) {
				samplePosition = position + count;
			} else { samplePosition += count; }
			
			return output;
		}
		
	}
}