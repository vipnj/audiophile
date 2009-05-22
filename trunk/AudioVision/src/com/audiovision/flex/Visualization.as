package com.audiovision.flex
{
	import com.audiovision.filters.ICustomFilter;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.*;
	
	import mx.core.UIComponent;
	
	public class Visualization extends UIComponent
	{
		
		private var point:Point;
		private var bitmap:BitmapData; // holds animated bitmap (pre filters)
		private var composite:Bitmap; // holds final composite
		
		private var _animations:Array;
		public function get animations():Array { return _animations; }
		public function set animations(value:Array):void {
			_animations = value;
		}
		
		private var _filters:Array;
		override public function get filters():Array { return _filters; }
		override public function set filters(value:Array):void {
			_filters = value;
		}
		
		private var _target:IBitmapDrawable;
		public function get target():IBitmapDrawable { return _target; }
		public function set target(value:IBitmapDrawable):void {
			_target = value;
		}
		
		public function Visualization( start:Boolean = true ) {
			super();
			start ? this.start() : 0;
			point = new Point(0, 0);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			composite = new Bitmap( null );
			addChild( composite );
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			var temp:BitmapData = bitmap;
			bitmap = new BitmapData(Math.max(unscaledWidth, 1), Math.max(unscaledHeight, 1), true, 0x00000000);
			if(temp) {
				bitmap.draw(temp, new Matrix(unscaledWidth/temp.width, 0, 0, unscaledHeight/temp.height, 0, 0), null, null, null, true);
			}
			composite.bitmapData = new BitmapData(Math.max(unscaledWidth, 1), Math.max(unscaledHeight, 1), true, 0x00000000);
		}
		
		/**
        * This method begins animating the component.
        */
        public function start():void {
        	addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
        }
        
        /**
        * This method stops animating the component.
        */
        public function stop():void {
        	removeEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
        }
		
		private function enterFrameHandler(event:Event):void {
			if(visible && bitmap) {
				
				bitmap.lock();
				composite.bitmapData.lock();
				
				bitmap.draw(_target, null, null, null, null, false); // copy target
	  			if(animations && animations.length > 0) { // apply animations
					for each(var animation:Object in _animations) {
						if(animation is BitmapFilter) {
							bitmap.applyFilter(bitmap, bitmap.rect, point, animation as BitmapFilter);
						} else if(animation is ICustomFilter) {
							(animation as ICustomFilter).apply(bitmap, bitmap.rect);
						}
					}
				} else {
					bitmap.fillRect(bitmap.rect, 0x00000000);
				}
				
				// copy to screen
				composite.bitmapData.fillRect(composite.bitmapData.rect, 0);
				composite.bitmapData.copyPixels(bitmap, bitmap.rect, point, null, null, true);
				
				// apply custom effects like palette mapping
				for each(var filter:Object in _filters) {
					if(filter is BitmapFilter) {
						composite.bitmapData.applyFilter(composite.bitmapData, composite.bitmapData.rect, point, filter as BitmapFilter);
					} else if(filter is ICustomFilter) {
						(filter as ICustomFilter).apply(composite.bitmapData, composite.bitmapData.rect);
					}
				}
				
				composite.bitmapData.unlock();
				bitmap.unlock();
				
			}
		}
		
	}
}