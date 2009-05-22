package com.audiophile.utils
{
	
	/**
	 * Utility to make impulse kernels for the convolution filter
	 */
	public class ImpulseUtil
	{
		
		public static const WINDOW_HAMMING:String = "hammingWindow";
		public static const WINDOW_BLACKMAN:String = "blackmanWindow";
		
		
		
		private static const PI2:Number = 2*Math.PI;
		private static const PI4:Number = 4*Math.PI;
		
		public static function createLowPass(frequency:Number, sampleRate:Number, length:uint = 100):Array {
			var m:int = length;
			var fc:Number = (frequency*2)/11025;
			var impulse:Array = new Array(length);
			for(var i:int = 0; i < length; i++) {
				var s:Number = 0;
				var t:Number = i-m/2;
				if(t!=0) {
					s = Math.sin(PI2*fc*t)/t;
				} else { s = PI2*fc; }
				impulse[i] = s * calculateBlackman(i, m);
			}
			normalize(impulse);
			return impulse;
		}
		
		public static function createHighPass(frequency:Number, sampleRate:Number, length:uint=100):Array {
			var impulse:Array = createLowPass(frequency, sampleRate, length);
			spectralInversion(impulse);
			return impulse;
		}
		
		public static function spectralInversion(impulse:Array):void {
			var n:int = impulse.length;
			for(var i:int = 0; i < n; i++) {
				impulse[i] *= -1;
			}
			impulse[int(n/2)] += 1;
		}
		
		private static function calculateBlackman(i:int, m:int):Number {
			var t:Number = i/m;
			return 0.42 - 0.5 * Math.cos(PI2*t) + 0.08 * Math.cos(PI4*t);
		}
		
		private static function calculateHamming(i:int, m:int):Number {
			var t:Number = i/m;
			return 0.54 - 0.46 * Math.cos(PI2*t);
		}
		
		private static function normalize(impulse:Array):void {
			var sum:Number = 0;
			var n:int = impulse.length;
			for(var i:int = 0; i < n; i++) {
				sum += impulse[i];
			}
			for(var j:int = 0; j < n; j++) {
				impulse[j] = impulse[j]/sum;
			}
		}
		
	}
}