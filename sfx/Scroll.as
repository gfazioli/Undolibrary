package undolibrary.sfx {
	/**
	 * Scroll is a special container for scroll any DisplayObject
	 *
	 * @author			Giovambattista Fazioli <g.fazioli@undolog.com>
	 * @web				http://www.undolog.com
	 * @version			0.0.5
	 *
	 */
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.geom.Matrix;

		
	public class Scroll extends MovieClip {
		// _______________________________________________________________ STATIC

		static public const NAME				:String			= "Scroll";
		static public const VERSION				:String 		= "0.0.5";
		static public const AUTHOR				:String 		= "Giovambattista Fazioli <g.fazioli@saidmade.com>";

		// _______________________________________________________________ INTERNAL
		
		/**
		 * Contiene la lista degli oggetti da scrollare
		 */
		private var _scrollItems			:Array;
		private var _index					:uint				= 0;		// index of clip from items array
		private var _mask					:Shape;
		private var _timer					:Timer;
		private var _scrollOver				:Boolean			= false;
		
		private var _borderOut				:Shape;
		private var _borderIn				:Shape;

		// _______________________________________________________________ PROPERTIES
		
		private var _width					:Number;						// virtual width
		private var _height					:Number;						// virtual height
		private var _speed					:Number				= 25;
		private var _borderOutWidth			:Number				= 0;		// 0 off, > 0 in pixel			
		private var _borderOutColor			:Number				= 0xffffff; // gradient final color
		private var _borderInWidth			:Number				= 0;		// 0 off, > 0 in pixel			
		private var _borderInColor			:Number				= 0xffffff; // gradient final color

				
		/**
		 * Class Constructor
		 */
		public function Scroll( w:Number = NaN, h:Number = NaN ):void {
			if( isNaN( w ) || isNaN( h ) ) throw( 'No dimensions setting' );
			
			_width				= w;
			_height				= h;
			
			_scrollItems 		= new Array();			
			
			addEventListener( Event.ADDED_TO_STAGE, main );
			// @todo not used in this versione
			// addEventListener( Event.RESIZE, onResize );
		}
		
		/**
		 * init
		 */
		private function main(e:Event = null):void {
			removeEventListener( Event.ADDED_TO_STAGE, main );
			
			/**
			* debug border
			this.graphics.lineStyle( 0x000000, 1 );
			this.graphics.drawRect( 0, 0, _width-1, _height-1 );
			*/
			
			initBorders();
			initMask();
			initTimer();
		}		
		
		/**
		 * Init the Timer
		 *
		 * @param speed 	time in milliseconds
		 */
		private function initTimer():void {
			try { _timer.removeEventListener( TimerEvent.TIMER, onTimer ) } catch(e) {}
			_timer	= new Timer( _speed );
			_timer.addEventListener( TimerEvent.TIMER, onTimer );
		}
		
		
		/**
		 * Init the mask
		 */
		private function initMask():void {
			_mask = new Shape();
			redrawMask();
			addChild( _mask );
			this.mask =  _mask  ;
		}
		
		/**
		 * Draw the mask
		 */
		private function redrawMask():void {
			try {
				with( _mask.graphics ) {
					clear();
					beginFill( 0xff0000, 1 );
					drawRect( 0, 0, _width, _height );
					endFill();
				}
			}
			catch(e){}
		}
		
		/**
		 * Init the borders
		 */
		private function initBorders():void {
			_borderOut 	= new Shape(); 
			_borderOut.cacheAsBitmap = true;
			_borderIn	= new Shape(); 
			_borderIn.cacheAsBitmap = true;
			_borderIn.x	= _width - _borderInWidth;
			
			addChild( _borderOut );
			addChild( _borderIn );
			//
			redrawBorders();
		}
		
		/**
		 * Draw borders
		 */
		private function redrawBorders():void {
			try {
				var matrix:Matrix 		= new Matrix();
				matrix.createGradientBox ( _borderOutWidth, _height );

				if( borderInWidth > 0 ) {
					_borderIn.x 	= _width - _borderInWidth;
					with (_borderIn.graphics) {
						clear();
						beginGradientFill (GradientType.LINEAR, [ _borderInColor, _borderInColor ], [0, 1], [0, 255], matrix, SpreadMethod.PAD);
						drawRect (0, 0, _borderInWidth, _height);
						endFill ();
					}
				}
				
				if( borderOutWidth > 0 ) {
					with (_borderOut.graphics) {
						clear();
						beginGradientFill (GradientType.LINEAR, [ _borderOutColor, _borderOutColor ], [1, 0], [0, 255], matrix, SpreadMethod.PAD);
						drawRect (0, 0, _borderOutWidth, _height);
						endFill ();
					}
				}
			}
			catch(e) {}
			
		}

		// __________________________________________________________________________________ INTERNAL EVENTS

		/**
		 * Trigged on resize 
		 * 
		 * @todo not used in this version
		 *
		private function onResize( e:Event = null ) : void {
			trace( 'Scroll::onResize' );
		}
		 */
		
		// __________________________________________________________________________________ METHODS
		
		/**
		 * Start the scroll
		 */
		public function start():void {
			for(var i:uint = 0; i < _scrollItems.length; i++ ) {
				_scrollItems[ i ].pause = true;
				_scrollItems[ i ].x = this._width;
			}
			_scrollOver = false;
			_scrollItems[ 0 ].pause = false;
			_timer.start();
		}
		
		/**
		 * Set in pause
		 */
		public function pause():void { _timer.stop(); }
		public function resume():void {	_timer.start(); }
			
		/**
		 * Add a new Object in items array (MovieClip, Sprite, DisplayObject, ...)
		 * 
		 * @param	key		Object's key
		 * @param	clip	Object: any DisplayObject (MovieClip, Bitmap, TextField, ... )
		 *
		 * 
		 *
		 */
		public function addItem( key:String, clip:* ):* {
			var mc:MovieClip 	= new MovieClip();
			_scrollItems.push( mc );										// put in array
			mc.x 				= this._width;
			mc.pause 			= true;
			mc.y				= ( this._height - clip.height ) / 2;
			mc.addChild( clip );
			addChild( mc );
			return (clip);
		}
		
		/**
		 * Scrolling single clip. When the clip is out of parent Scroll
		 * the timer is turn off. Elsewhere, when the clip is all visible
		 * the next clip is starting.
		 */
		private function onTimer( e:TimerEvent = null ):void {
			var mc:MovieClip;
			for(var i:uint = 0; i < _scrollItems.length; i++ ) {
				mc = _scrollItems[ i ];
				if( ( mc.x + mc.width ) < 0 ) { 
					mc.x = this._width;
					mc.pause = true;
					if( _scrollOver ) {
						_scrollOver = false;
						_scrollItems[0].pause = false;
					}
				} else {
					if( !mc.pause ) mc.x--;
				}
				if( ( mc.x + mc.width ) < this._width ) {
					if ( (i+1) > _scrollItems.length-1 ) {
						//_scrollItems[0].pause = false;
						_scrollOver = true;
					} else {
						_scrollItems[ (i+1) ].pause = false;
					}
					//_scrollItems[ ( ( (i+1) > _scrollItems.length-1) ? 0 : (i+1) ) ].pause = false;
				}
			}
			e.updateAfterEvent();
		}
		
		
		// ___________________________________________________________________________ PROPERTIES
		
		/**
		 * Due the mask, return virtual movieclip width 
		 */
		override public function get width():Number 			{ return _width; }
		override public function set width(v:Number):void 		{ _width = v; redrawBorders(); redrawMask(); }

		/**
		 * Due the mask, return virtual movieclip height
		 */
		override public function get height():Number 			{ return _height; }
		override public function set height(v:Number):void 		{ _height = v; redrawBorders(); redrawMask(); }
		
		/**
		 * Get/Set scroll speed in milliseconds
		 */
		public function get speed():Number 						{ return _speed; }
		public function set speed(v:Number):void {
			_speed = v; 
			try {
				_timer.delay = _speed;
			} catch(e) {}
		}
		
		/**
		 * Fade Border (left)
		 */
		public function get borderOutWidth():Number				{ return _borderOutWidth; }
		public function set borderOutWidth(v:Number):void		{ _borderOutWidth = v; redrawBorders(); }
		
		public function get borderOutColor():Number				{ return _borderOutColor; }
		public function set borderOutColor(v:Number):void		{ _borderOutColor = v; redrawBorders(); }
		
		public function get borderInWidth():Number				{ return _borderInWidth; }
		public function set borderInWidth(v:Number):void		{ _borderInWidth = v; redrawBorders(); }
		
		public function get borderInColor():Number				{ return _borderInColor; }
		public function set borderInColor(v:Number):void		{ _borderInColor = v; redrawBorders(); }

	} 
}