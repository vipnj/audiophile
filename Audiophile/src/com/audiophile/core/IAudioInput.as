package com.audiophile.core
{
	/**
	 * 	Class that represents any number of audio samples, effects, etc... but has the purpose of
	 *  providing the bytes for the AudioSpikeEngine to write into a Sound SAMPLE_DATA_EVENT.data.
	 */
	public interface IAudioInput
	{
		/**
		 * 
		 * 	@param count 	The number of samples to read starting from the value in the position parameter.
		 * 	@param position The position to start reading samples from.
		 */
		function readSamples(count:int, position:int = -1):SampleChain;
	}
}