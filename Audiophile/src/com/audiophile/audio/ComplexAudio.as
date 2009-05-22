package com.audiophile.audio
{
	import __AS3__.vec.Vector;
	
	import com.audiophile.core.AudioSample;
	import com.audiophile.core.IAudioEffect;
	import com.audiophile.core.IAudioInput;
	import com.audiophile.core.IAudioTime;
	import com.audiophile.core.SampleChain;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	public class ComplexAudio implements IAudioInput, IAudioTime
	{
		
		private var source:IAudioTime;
		public function get position():Number {
			if(source) {
				return source.position;
			} else {
				return -1;
			}
		}
		public function set position(value:Number):void {
			for each(var a:IAudioInput in value) {
				(a as IAudioTime).position = value;
			}
		}
		
		public function get length():Number {
			if(source) {
				return source.length;
			} else {
				return 0;
			}
		}
		
		private var _audio:Vector.<IAudioInput>;
		public function get audio():Vector.<IAudioInput> { return _audio; }
		public function set audio(value:Vector.<IAudioInput>):void {
			_audio = value;
			updateTime(value);
			for each(var a:IAudioInput in value) {
				if(a is IEventDispatcher) {
					(a as IEventDispatcher).addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
					(a as IEventDispatcher).addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				}
			}
		}
		
		private var _effects:Array; [Bindable]
		public function get effects():Array { return _effects; }
		public function set effects(value:Array):void {
			_effects = value;
		}
		
		public function ComplexAudio(audio:Vector.<IAudioInput>) {
			this.audio = audio;
		}
		
		//private var samplePosition:Number; // for [0]
		public function readSamples(count:int, position:int = -1):SampleChain {
			var length:int = _audio.length;
			//position = source.position;
			var samples:SampleChain = _audio[0].readSamples(count, position); // reusing child chain
			
			if(length > 1) {
				for(var i:int = 1; i < length; i++) {
					var s1:AudioSample = samples.first;
					var s2:AudioSample = _audio[i].readSamples(count, position).first;
					while(s1.next) { // speed vs. for loop?
						s1.left += s2.left;
						s1.right += s2.right;
						s1 = s1.next;
						s2 = s2.next;
					}
					
				}
			}
			
			var output:SampleChain = samples;
			for each(var effect:IAudioEffect in effects) {
				output = effect.processSamples(output);
			}
			
			return output;
		}
		
		private function progressHandler(event:ProgressEvent):void {
			updateTime(audio);
		}
		
		private function completeHandler(event:Event):void {
			updateTime(audio);
		}
		
		private function updateTime(inputs:Vector.<IAudioInput>):void {
			var l:Number = 0
			for each(var a:IAudioInput in inputs) {
				if(a is IAudioTime && (a as IAudioTime).length > l) {
					source = a as IAudioTime;
					l = (a as IAudioTime).length;
				}
			}
		}
		
	}
}