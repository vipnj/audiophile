package com.audiophile.core
{
	
	public interface IAudioEffect
	{
		function get multiplier():Number;
		function processSamples(samples:SampleChain):SampleChain;
		function reset():void;
	}
}