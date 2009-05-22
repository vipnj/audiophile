package com.audiovision.media
{
	public class FrequencyBands
	{
		
		// logarithmic frequency bands
		public static const FOUR_BAND_VISUAL:Array = [250, 400, 600, 800];
		public static const WINAMP:Array = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000];//[60, 170, 310, 600, 1000, 3000, 6000, 12000, 14000, 16000];
		
		public static const FOUR_BAND:Array = [125, 500, 1000, 2000]; // best guess
		public static const EIGHT_BAND:Array = [63, 125, 500, 1000, 2000, 4000, 6000, 8000]; // best guess
		public static const TEN_BAND:Array = [31.5, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]; // ISO Standard
		public static const THIRTY_ONE_BAND:Array = [20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500, 16000, 20000]; // BEHRINGER 3102
		
	}
}