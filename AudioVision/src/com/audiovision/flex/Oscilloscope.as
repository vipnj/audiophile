package com.audiovision.flex
{
	
	import __AS3__.vec.Vector;
	
	import com.audiovision.graphics.OscilloscopeRenderer;
	import com.audiovision.media.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.*;
	import flash.utils.*;
	
	import mx.core.UIComponent;
	import mx.graphics.*;
	
	/**
	 * The Oscilloscope component displays an audio waveform by plotting amplitude (y)
	 * over time (x) where time is an indeterminant sample period between frames.
	 */
	public class Oscilloscope extends UIComponent {
		
		private var _fill:IFill;
		private var _stroke:IStroke;
		private var _animated:Boolean = true;
		
		public function get animated():Boolean { return _animated; }
		public function set animated(value:Boolean):void {
			if(value) {
				addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, false);
			} else {
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
			}
			_animated = value;
		}
		
		[Bindable]
		public function get fill():IFill { return _fill; }
		public function set fill(value:IFill):void {
			_fill = value;
		}
		
		[Bindable]
		public function get stroke():IStroke { return _stroke; }
		public function set stroke(value:IStroke):void {
			_stroke = value;
		}
		
		// constructor
		
		private var renderer:OscilloscopeRenderer;
		private var rectangle:Rectangle;
		
		public function Oscilloscope() {
			rectangle = new Rectangle();
			renderer = new OscilloscopeRenderer();
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, false);
		}
		
		// overridden methods etc.
		
		override protected function createChildren():void {
			super.createChildren();
			if(!stroke) { stroke = new Stroke(0x000000, 1); }
			if(!fill) { fill = new SolidColor(0x000000, 0); }
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			rectangle = new Rectangle(0, 0, unscaledWidth, unscaledHeight);
		} 
		
		private function enterFrameHandler(event:Event):void {
			var samples:Vector.<Number> = SoundAnalyzer.computeSpectrum("mono", 44100);
			graphics.clear();
			stroke.apply(graphics);
			fill.begin(graphics, rectangle);
			renderer.render(samples, graphics, rectangle);
			graphics.lineStyle(0, 0, 0);
			graphics.moveTo(unscaledWidth, unscaledHeight/2)
			graphics.moveTo(0, unscaledHeight/2);
			fill.end(graphics);
		}
		
	}
}