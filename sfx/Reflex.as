package undolibrary.sfx {
	/**
	 * Reflex è una classe che permette di creare un effetto riflessione
	 * su un qualsiasi MovieClip.
	 *
	 * @author			Giovambattista Fazioli <g.fazioli@undolog.com>
	 * @web				http://www.undolog.com
	 * @version			1.0.2
	 */
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.events.*;
	
	public class Reflex extends MovieClip {
		private var _mc:MovieClip;
		private var __bmpd:BitmapData;
		private var __bmp:Bitmap;
		private var __mask:Shape;
		private var __oWidth:Number
		private var __oHeight:Number;
		private var __gradientRadial:Boolean	= false;
		private var __reflexOffset:Number		= 0;
		private var __gradientOffset:Number		= 128;
		private var __alphaOffset:Number		= .5;
		private var __matrix:Matrix;
		/**
		 * Class Constructor
		 */
		public function Reflex(mc:MovieClip):void {
			_mc  = mc;
			init();
		}
		
		/**
		 * Trigged from constructor. Init all properties
		 *
		 * @param	{event}		Event (can be null)
		 * @return	void
		 * @private
		 */
		private function init(e:Event = null):void {
			// save original clip dimension
			__oWidth				= _mc.width;
			__oHeight				= _mc.height;
			// bitmapdata/bitmap reflex
			__bmpd					= new BitmapData( _mc.width, _mc.height, true, 0x000000);
			__bmpd.draw( _mc );
			__bmp					= new Bitmap( __bmpd );
			_mc.addChild( __bmp );
			__bmp.scaleY			= -1;
			__bmp.y					= __oHeight*2 + __reflexOffset;
			__bmp.cacheAsBitmap		= true;
			// gradient
			__mask					= new Shape();
			__mask.cacheAsBitmap	= true;
			__mask.y				= __oHeight + __reflexOffset;
			__matrix 				= new Matrix();
			__matrix.createGradientBox(__oWidth, __oHeight, Math.PI/2);
			doGradient();
			_mc.addChild( __mask );
			__bmp.mask				= __mask;
		}
		
		/**
		 * Draw original MovieClip into a Bitmap for reflection
		 *
		 * @param	{event}		Event (can be null)
		 * @return	void
		 * @private
		 */
		private function render(e:Event = null):void {
			__bmpd.draw( _mc );
		}
		
		/**
		 * Create a gradient fill in mask movieclip 
		 *
		 * @param	void
		 * @return	void
		 * @private
		 */
		private function doGradient():void {
			with( __mask.graphics ) {
				clear();
				beginGradientFill( (__gradientRadial?GradientType.RADIAL:GradientType.LINEAR), [0x000000,0x000000], [__alphaOffset, 0], [0, __gradientOffset], __matrix);
				drawRect(0, 0, __oWidth, __oHeight);
				endFill();
			}
		}
		
		/**
		 * Get/Set reflection offset
		 *
		 * @param	{number}		v	Offset in pixel
		 * @return	{number}		Offset in pixel
		 */
		public function get reflexOffset():Number 		{ return __reflexOffset; }
		public function set reflexOffset(v:Number):void	{
			__reflexOffset 			= v;
			__bmp.y					= __oHeight*2 + __reflexOffset;
			__mask.y				= __oHeight + __reflexOffset;
		}

		/**
		 * Get/Set gradient offset
		 *
		 * @param	{number}		v	Offset in pixel
		 * @return	{number}		Offset in pixel
		 */
		public function get gradientOffset():Number 		{ return __gradientOffset; }
		public function set gradientOffset(v:Number):void	{
			__gradientOffset		= v;
			doGradient();
		}

		/**
		 * Get/Set alpha offset
		 *
		 * @param	{number}		v	Offset in pixel
		 * @return	{number}		Offset in pixel
		 */
		public function get alphaOffset():Number 		{ return __alphaOffset; }
		public function set alphaOffset(v:Number):void	{
			__alphaOffset		= v;
			doGradient();
		}
		
		/**
		 * Get/Set reflection offset
		 *
		 * @param	{boolean}		v	true for radial, false for linear
		 * @return	{boolean}		true radial, false linear
		 */
		public function get gradientRadial():Boolean 		{ return __gradientRadial; }
		public function set gradientRadial(v:Boolean):void	{
			__gradientRadial		= v;
			doGradient();
		}
	}
}