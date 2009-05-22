package com.audiophile.core
{
	
	/**
	 * Used for audio which is not infinite.
	 * All time must be represented in milliseconds.
	 */
	public interface IAudioTime
	{
		// following the lead of the sound object
		function get position():Number;
		function set position(value:Number):void;
		function get length():Number;
	}
}