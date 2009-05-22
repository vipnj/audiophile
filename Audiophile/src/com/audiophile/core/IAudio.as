package com.audiophile.core
{
	
	public interface IAudio extends IAudioInput, IAudioTime
	{
		
		function get effects():Array;
		function set effects(value:Array):void;
		
		function get volume():Number;
		function set volume(value:Number):void;
		
		function get pan():Number;
		function set pan(value:Number):void;
		
	}
	
}