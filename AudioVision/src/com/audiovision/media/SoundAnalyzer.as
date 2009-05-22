package com.audiovision.media
{
	//import com.flaudio.synth.AudioSine;
	
	import __AS3__.vec.Vector;
	
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class SoundAnalyzer
	{
		
		public static const CHANNEL_LEFT:String = "left";
		public static const CHANNEL_RIGHT:String = "right";
		public static const CHANNEL_MONO:String = "mono";
		
		//*******************************************************
		// Array Utilities
		//*******************************************************
		
		public static function computeSpectrum(channel:String = "mono", sampleRate:Number = 44100):Vector.<Number> {
			return getSamples(false, channel, sampleRate);
		}
		/*
		public static function computeFrequencies( bands:Array, bandwidth:Number = 1, channel:String = "mono", sampleRate:Number = 44100):Array {
			var length:Number = bands.length;
			var averages:Array = new Array(length);
			var samples = getSamples(true, channel, sampleRate);
			for (var i:int = 0; i < length; i++) {
				var rsum:Number = 0;
				var sum:Number = 0;
				var peak:Number = 0;
				var frequency:Number = bands[i];
				var reference:Number = getReference();
				if(bandwidth > 0) {
					var lowBound:int = frequencyToIndex(frequency > 0 ? frequency/(bandwidth+1) : 0, sampleRate);
					var hiBound:int = Math.min(frequencyToIndex(frequency*(bandwidth+1), sampleRate), 255);
					for (var j:int = lowBound; j <= hiBound; j++) {
						sum = samples[j];
						rsum += Math.pow(samples[j], 2);
						peak = Math.max(samples[j], peak);
					}
					var count:int = Math.max((hiBound - lowBound + 0), 1);
					var rms:Number = Math.sqrt(rsum/count); // root mean square
					var avg:Number = sum/count;
					//averages[i] = 20 * (Math.log((peak+1)/1) * Math.LOG10E) * 10; // represented in decibels!!! yay math!
					averages[i] = (peak/1.414);
				} else {
					var index:int = frequencyToIndex(frequency, sampleRate);
					averages[i] = samples[index]/1.414; // temporary
				}
			}
			return averages;
		}
		*/
		// 512 = sample size (resulting in 256 valid values below Nyquist Frequency)
		public static function getBandwidth(sampleRate:Number, sampleSize:uint = 1024):Number {
			return (2/sampleSize) * (sampleRate/2);
		}
		
		public static function getFrequencies(sampleRate:Number, sampleSize:uint = 1024):Array {
			var frequencies:Array = new Array(256);
			for(var i:int = 0; i < 256; i++) {
				frequencies[i] = indexToFrequency(i, sampleRate, sampleSize);
			}
			return frequencies;
		}
		
		//***********************************************************************************
		// Utility Functions
		//***********************************************************************************
		
		
		private static function getSamples(FFTMode:Boolean = false, channel:String = "mono", sampleRate:Number = 44100):Vector.<Number> {
			var spectrum:ByteArray = new ByteArray(); // gross, needs optimizing
			SoundMixer.computeSpectrum(spectrum, FFTMode, getStretchFactor(sampleRate));
			var samples:Vector.<Number> = new Vector.<Number>(255);			
			for(var i:int = 0; i < 256; i++) {
				samples[i] = spectrum.readFloat();
			}
			return samples;
		}
		
		private static function getStretchFactor(sampleRate:Number):uint {
			var token:uint = 0;
			while((token+1)*sampleRate < 44100) {
				token++;
			}
			return token;
		}
		
		public static function frequencyToIndex(frequency:Number, sampleRate:Number, sampleSize:uint = 1024):uint {
			var bandwidth:Number = getBandwidth(sampleRate, sampleSize);
			if ( frequency < bandwidth/2 ) { return 0; } // special case: freq is lower than the bandwidth of spectrum[0]
			if ( frequency > sampleRate/2 - bandwidth/2 ) { return sampleSize/2 - 1 }; // special case: freq is within the bandwidth of spectrum[512]
			var fraction:Number = frequency/sampleRate;
			var i:int = Math.round(sampleSize * fraction);
			return i;
		}
		
		public static function indexToFrequency(index:uint, sampleRate:Number, sampleSize:uint = 1024):Number {
			var frequency:Number = sampleRate * (index/sampleSize);
			return frequency;
		}
		
		private static function getReference():Number {
			/*var sine:AudioSine = new AudioSine(1000);
			sine.bitsPerSample = 8;
			var samples:Array = sine.readSamples(1024);
			var sum:Number = 0;
			for each(var n:Number in samples) {
				sum += Math.abs(n);
			}
			var avg:Number = sum/samples.length;*/
			return 20/1000000000000;
		}
		
	}
}