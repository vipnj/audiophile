package com.audiophile
{
	import com.audiophile.core.AudioSample;
	import com.audiophile.core.IAudioInput;
	import com.audiophile.core.IAudioTime;
	import com.audiophile.core.SampleChain;
	
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	
	public class Audiophile extends EventDispatcher implements IAudioTime
	{
		
		private var sound:Sound;
		private var playing:Boolean;
		private var channel:SoundChannel;
		private var _audio:IAudioInput;
		private var audioTime:IAudioTime;
		private var _latency:Number = 1;
		private var samplePositionChanged:Boolean;
		
		public function get position():Number {
			if(audioTime) {
				return audioTime.position;
			} else {
				return 0;
			}
		}
		public function set position(value:Number):void {
			samplePosition = value*44.1;
			samplePositionChanged = true;
			if(_audio is IAudioTime) {
				(_audio as IAudioTime).position = value;
			}
			latency = 1;
		}
		
		public function get length():Number {
			if(audioTime) {
				return audioTime.length;
			} else {
				return 0;
			}
		}
		
		[Bindable]
		public function get latency():Number { return _latency; }
		public function set latency(value:Number):void {
			_latency = value;
		}
		
		public function get audio():IAudioInput { return _audio; }
		public function set audio(value:IAudioInput):void {
			_audio = value;
			if(value is IAudioTime) {
				audioTime = value as IAudioTime;
			}
		}
		
		public function Audiophile(audio:IAudioInput = null) {
			sound = new Sound();
			sound.addEventListener("sampleData", onSamples)
			//sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.audio = audio;
		}
		
		public function play():SoundChannel {
			playing = true;
			channel = sound.play();
			return channel;
		}
		/*
		public function pause():void {
			playing = false;
			if(channel) channel.stop();
		}
		
		public function stop():void {
			playing = false;
			if(channel) channel.stop();
			position = 0;
		}*/
		
		// dynamic audio!
		private var samplePosition:Number = 0;
		private function onSamples(event:SampleDataEvent):void {
			var length:int = 4096;
			/*var l:Number = channel ? (event.position/44.1) - channel.position  : 0;
			if(_latency != l) {
				latency = l;
			}*/
			//if(playing) {
				var chain:SampleChain = _audio.readSamples(length, samplePositionChanged ? samplePosition : -1);
				var sample:AudioSample = chain.first;
				var bytes:ByteArray = event.data;
				for (var i:int = 0; i < chain.length; ++i ) {
					bytes.writeFloat(sample.left);
					bytes.writeFloat(sample.right);
					sample = sample.next;
				}
				samplePosition += length;
				samplePositionChanged = false;
				/*
				if(this.position >= this.length) {
					this.position -= this.length;
					//this.stop();
				}*/
			//}
		}
		
	}
}