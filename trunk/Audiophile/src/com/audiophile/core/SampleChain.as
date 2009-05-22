package com.audiophile.core
{
	
	/**
	 * Represents a linear sequence of discrete audio samples.
	 * Note that data integrity must be maintained manually if properties of this class are modified.
	 */
	public class SampleChain
	{
		
		public var length:int;
		public var first:AudioSample;
		public var last:AudioSample;
		
		public function SampleChain() {
			length = 0;
			first = new AudioSample();
		}
		
		/**
		 * The adjust function can be used to change the size of the SampleChain.
		 * However individual AudioSample values may not be reset.
		 */
		public function adjust(size:int):void {
			// should probably create a local reference to the abs function.
			size = Math.abs(size);
			/*if(size > length) {
				expand(size - length);
			} else if(size < length) {
				trim(length - size);
			}*/
			if(size != length) {
				reset(size);
			}
		}
		
		public function reset(size:int):void {
			size = Math.abs(size);
			var sample:AudioSample = first = new AudioSample();
			for(var i:int = 0; i < size; i++) {
				sample = sample.next = new AudioSample();
			}
			last = sample;
			length = size;
		}
		
		private function expand(v:int):void {
			length += v;
			var sample:AudioSample = last; // recycle existing samples
			for(var i:int = 0; i < v; i++) {
				sample = sample.next = new AudioSample();
			}
			last = sample;
		}
		
		private function trim(v:int):void {
			length -= v;
			var sample:AudioSample = first;
			for(var i:int = 0; i < length; i++) {
				sample = sample.next;
			}
			sample.next = null;
			last = sample; // old samples will get garbage collected and could cause lag.
		}
		
	}
}