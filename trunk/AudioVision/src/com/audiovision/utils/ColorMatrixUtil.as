package com.audiovision.utils
{
	public class ColorMatrixUtil
	{
		
		public static function createGreyscale(p:Number):Array {
			var matrix:Array = [0, 0, 0, 0, 0, 
								0, 0, 0, 0, 0,
								0, 0, 0, 0, 0,
								0, 0, 0, p, 0];
			return matrix;
		}
		
	}
}