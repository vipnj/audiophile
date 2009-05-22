package com.audiophile.utils
{
	import __AS3__.vec.Vector;
	
	import com.audiophile.core.SampleChain;
	
	public class AudioUtil
	{
		/*
		public static function mix(target:SampleChain, audio:Vector.<IAudioInput>):void {
			var length:int = 0;
			for each(var item:Vector.<Number> in audio) {
				if(item.length > length) {
					length = item.length;
				}
			}
			var trackCount:int = audio.length;
			for(var i:int = 0; i < length; i++) {
				var sample:Number = 0;
				for each(var samples:Vector.<Number> in audio) {
					sample += samples[i];
				}
				target[i] = sample/trackCount;
			}
		}
		*/
		public static function gain(target:Array, level:Number):void {
			var n:int = target.length;
			for(var i:int = 0; i < n; i++) {
				target[i] = target[i]*level;
			}
		}
		
		// as understood from http://www.dspguide.com/ch6/4.htm
		// does not include samples which aren't fully immersed
		public static function convolve(output:Array, input:Array, impulse:Array):void {
			var outputLength:int = output.length;
			var impulseLength:int = impulse.length;
			var paddingLength:int = (impulseLength-1); // (unusable/ignored output samples)
			for(var o:int = 0; o < outputLength; o++) {
				var sample:Number = 0;
				for(var i:int = 0; i < impulseLength; i++) {
					sample = sample + impulse[i] * input[(o+paddingLength)-i]
				}
				output[o] = sample;
			}
		}
		
	}
}