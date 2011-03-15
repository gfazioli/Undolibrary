package undolibrary.ui {
	/**
	 * Knob Class is part of undolibrary: Knob is a very light slider button
	 * you can customize layout and behaviour:
	 *
	 * METHODS
	 * 	refresh()			Redraw all knob layout
	 *
	 * PROPERTIES
	 *	color				Get/Set background color for knob container in 0xrrggbb
	 *	borderRadius		Get/Set border radius for knob container
	 *	knobColor			Get/Set knob color in 0xrrggbb
	 *	knobHeight			Get/Set knob height
 	 *	knobWidth			Get/Set knob width
	 *	knobBorderRadius	Get/Set border radius for knob
	 *	max					Get/Set Max value of knob
	 *	min					Get/Set Min value of knob
	 *	renderBackground	Get/Set Callback function for render background
	 *	renderKnob			Get/Set Callback function for render knob
	 *	value				Get/Set value of knob (min, max)
	 *
	 * EVENTS
	 *	CHANGE				Trigged when knob value is changed
	 *	REDRAW				Trigged when the knob layout is redraw
	 *
	 *
	 * Knob Class is released under version 3.0 of the Creative Commons 
	 * Attribution-Noncommercial-Share Alike license. This means that it is 
	 * absolutely free for personal, noncommercial use provided that you 1)
	 * make attribution to the author and 2) release any derivative work under
	 * the same or a similar license.
	 *
	 * This program is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	 *
	 * If you wish to use Knob Class for commercial purposes, licensing information
	 * can be found at http://www.undolog.com	 
	 *
	 * @author			Giovambattista Fazioli <g.fazioli@undolog.com>
	 * @web				http://www.undolog.com
	 * @version			1.1.0
	 *
	 * CHANGE LOG
	 *	1.2.5			Add renderKnob callback render function for knob
	 *	1.2.0			Fix bugs, rev namespace and code. Add and remove some new properties
	 *	1.0.1			first release
	 *
	 */
	
	import flash.display.*;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;

	public class Knob extends MovieClip {
		
		// _______________________________________________________________ STATIC
		
		static public const NAME			:String				= "Knob Class";
		static public const VERSION			:String 			= "1.2.5";
		static public const AUTHOR			:String 			= "Giovambattista Fazioli <g.fazioli@undolog.com>";
		
		static private const COLOR			:Number				= 0x444444;			// default color of background container
		static private const WIDTH			:Number				= 200;				// default with of container
		static private const HEIGHT			:Number				= 10;				// default height of container
		static private const BORDER_RADIUS	:Number				= 10;				// default border radius for background container
		
		static private const KNOB_COLOR		:Number				= 0xaaaaff;			// default color of knob
		static private const KNOB_WIDTH		:Number				= 10;				// default width of knob
		static private const KNOB_HEIGHT	:Number				= HEIGHT;			// default height of knob
		static private const KNOB_BRADIUS	:Number				= 10;				// default border radius for knob
		
		static private const MIN			:Number				= 0;				// default min value
		static private const MAX			:Number				= 100;				// default max value
	
		// ________________________________________________ INCAPSULATE PROPERTIES
		
		private var __color					:Number				= COLOR;			// set all incapsulate properties
		private var __width					:Number				= WIDTH;
		private var __borderRadius			:Number				= BORDER_RADIUS;
		private var __height				:Number				= HEIGHT;
		private var __knobColor				:Number				= KNOB_COLOR;
		private var __knobWidth				:Number				= KNOB_WIDTH;
		private var __knobHeight			:Number				= KNOB_HEIGHT;
		private var __knobBorderRadius		:Number				= KNOB_BRADIUS;
		private var __value					:Number				= MIN;
		private var __min					:Number				= MIN;
		private var __max					:Number				= MAX;
		
		private var __background			:MovieClip;								// knob (background) container
		private var __knob					:MovieClip;								// knob
		
		private var __mOffset				:Number;								// mouse move
		private var __maxMouse				:Number;								// limit knob move
		
		private var __sd					:Boolean			= false;			// Start Drag flag
		
		// __________________________________________________________ CONSTRUCTOR
		
		public function Knob ():void	{
			initProperties();
			initBackground();
			initKnob();
			addEventListener(Event.ADDED_TO_STAGE, main );
		}
		
		/**
		 * Trigged when added to stage
		 *
		 * @param		e 		(event)	can be null
		 *
		 * @private
		 */
		private function main( e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, main );
			initEvents();
			__redraw();
		}

		// _________________________________________________________________ INIT
		
		/**
		 * Init base properties of knob engine
		 *
		 * @private
		 */
		private function initProperties():void {
			__calc( __min );
			__maxMouse = __width - __knobWidth;
		}
		
		/**
		 * Call by main() for background MovieClip
		 *
		 * @private
		 */
		private function initBackground():void {
			__background = new MovieClip();
			addChild( __background );
			/**
			 * This is the default callback drawing function for
			 * background container. You can change this callback
			 * set the renderBackground property
			 */
			__background.render = function():void {
				with( this.graphics ) {
					clear();
					beginFill( __color );
					drawRoundRect(0, 0, __width, __height, __borderRadius, __borderRadius );
				}
			}			
		}
	
		/**
		 * Call by main() for init Knob MovieClip
		 *
		 * @private
		 */
		private function initKnob():void {
			__knob 					= new MovieClip();
			__knob.tw				= NaN;
			__knob.buttonMode 		= true;
			__knob.useHandCursor 	= true;
			__knob.mouseChildren	= false;
			__background.addChild( __knob );
			/**
			 * NEW in 1.2.5
			 * Add a callback function render for knob too
			 * see renderKnob property
			 */
			__knob.render = function():void {
				with( this.graphics ) {
					clear();
					beginFill( __knobColor );
					drawRoundRect(0, (__height-__knobHeight)/2, __knobWidth, __knobHeight, __knobBorderRadius, __knobBorderRadius );
				}
			}	
		}
		
		/**
		 * Init all event on background and knob movieclip
		 *
		 * @private
		 */
		private function initEvents():void {
			__background.addEventListener( MouseEvent.MOUSE_DOWN, bgMouseDown );
			__knob.addEventListener( MouseEvent.MOUSE_DOWN, knobMouseDown );
			stage.addEventListener ( MouseEvent.MOUSE_UP, knobMouseUp );
		}
		
		/**
		 * Redraw all object
		 *
		 * @private
		 */
		private function __redraw():void {
			__maxMouse = __width - __knobWidth;
			__background.render();
			__knob.render();
			dispatchEvent( new KnobEvent( KnobEvent.REDRAW ) );
		}
		
		/**
		 * Trigged when mouse is pressed on background (mc)
		 *
		 * @event
		 */
		private function bgMouseDown( e:MouseEvent ):void {
			var vf:Number =  mouseX - ( __knob.width / 2 );
			if( vf <= 0 ) vf = 0;
			if( vf >= __maxMouse ) vf = __maxMouse;
			try { __knob.tw.stop() } catch (error:TypeError) { }
			__knob.tw = new Tween (__knob, 'x', Strong.easeOut, __knob.x, vf, 1, true );
			dispatchEvent( new KnobEvent( KnobEvent.START_DRAG ) );
			__knob.tw.addEventListener( TweenEvent.MOTION_CHANGE,
				function ( e:TweenEvent ):void {
					__calc( e.position );
				}
			);
			__knob.tw.addEventListener( TweenEvent.MOTION_FINISH,
				function ( e:TweenEvent ):void {
					dispatchEvent( new KnobEvent( KnobEvent.STOP_DRAG ) );
				}
			);
			e.updateAfterEvent();
		}

		/**
		 * Trigged when mouse is pressed on knob (mc)
		 *
		 * @event
		 */
		private function knobMouseDown( e:MouseEvent ):void {	
			try { __knob.tw.stop() } catch (error:TypeError) { }
			e.stopImmediatePropagation();
			stage.addEventListener ( MouseEvent.MOUSE_MOVE, knobMouseMove );
			__mOffset = mouseX - __knob.x;
			dispatchEvent( new KnobEvent( KnobEvent.START_DRAG ) );
			__sd = true;
			e.updateAfterEvent();
		}
		
		/**
		 * Trigged when mouse is up on stage
		 *
		 * @event
		 */
		private function knobMouseUp( e:MouseEvent ):void {
			stage.removeEventListener ( MouseEvent.MOUSE_MOVE, knobMouseMove );
			if(__sd) { __sd=false; dispatchEvent( new KnobEvent( KnobEvent.STOP_DRAG ) ); }
			e.updateAfterEvent();	
		}

		/**
		 * Trigged when mouse is moving relative to stage
		 *
		 * @event
		 */
		private function knobMouseMove( e:MouseEvent ):void {
			var vf:Number 				= mouseX - __mOffset;
			if( vf <= 0 ) 			vf	= 0;
			if( vf >= __maxMouse )	vf	= __maxMouse;
			__knob.x 					= vf; 
			__calc( vf );
			e.updateAfterEvent();
		}

		/**
		 * Convert Knob position (0,n) in value from params min and max
		 * the algoritmic is:
		 * v = ((d-c)/(b-a))*(n-a)+c;
		 * n change from (a) to (b)
		 * v(x=a) = c; v(x=b) = d;
		 *
		 * @param		n			(number) Mouse coordinate (x/y)
		 * @return					(number) Converted value
		 *
		 * @private
		 */
		private function __calc( n:Number, stopEvent:Boolean = true ):Number {
			var a:Number = 0;
			var b:Number = __maxMouse;
			var c:Number = __min;
			var d:Number = __max;
			__value = ((d-c)/(b-a))*(n-a)+c;
			if( stopEvent) dispatchEvent( new KnobEvent( KnobEvent.CHANGE, false, true, __value ) );
			return __value;
		}
		
		// ______________________________________________________________ METHODS
		
		/**
		 * Wrap protected __redraw() method. Refresh all layout
		 */
		public function refresh():void {
			__redraw();
		}
		
		// ___________________________________________________________ PROPERTIES
		
		/**
		 * Get/Set Value (position) of knob
		*/
		public function get value():Number 			{ return __value; }
		public function set value(v:Number):void 	{ 
			if(v >= __min && v <= __max ) {
				__value		= v;
				__knob.x 	= (__value-__min)/( (__max-__min)/(__maxMouse) );	// inverse function
				__calc( __knob.x, false )
			}
		}
		
		/**
		 * Get/Set Max value of Knob
		 */
		public function get max():Number 			{ return __max; }
		public function set max(v:Number):void		{ __max = v; __calc(__min, false); }
		
		/**
		 * Get/Set Min value of knob
		 */
		public function get min():Number 			{ return __min; }
		public function set min(v:Number):void 		{ __min = v; __calc(__min); }

		/**
		 * Get/Set color
		 */
		public function get color():Number 			{ return __color; }
		public function set color(v:Number):void 	{ __color = v; __redraw(); }

		/**
		 * Get/Set width
		 */
		override public function get width():Number 		{ return __width; }
		override public function set width(v:Number):void 	{ __width = v; __redraw(); }

		/**
		 * Get/Set height
		 */
		override public function get height():Number 		{ return __height; }
		override public function set height(v:Number):void 	{ __height = v; __redraw(); }

		/**
		 * Get/Set knobColor
		 */
		public function get knobColor():Number 			{ return __knobColor; }
		public function set knobColor(v:Number):void 	{ __knobColor = v; __redraw(); }

		/**
		 * Get/Set knobWidth
		 */
		public function get knobWidth():Number 			{ return __knobWidth; }
		public function set knobWidth(v:Number):void 	{ __knobWidth = v; __redraw(); }

		/**
		 * Get/Set knobHeight
		 */
		public function get knobHeight():Number 		{ return __knobHeight; }
		public function set knobHeight(v:Number):void 	{ __knobHeight = v; __redraw(); }

		/**
		 * Get/Set backgroundClip
		 */
		public function get backgroundClip():MovieClip 			{ return __background; }
		public function set backgroundClip(v:MovieClip):void 	{ __background = v; __redraw(); }

		/**
		 * Get/Set knobClip
		 */
		public function get knobClip():MovieClip 		{ return __knob; }
		public function set knobClip(v:MovieClip):void 	{ __knob = v; __redraw(); }

		/**
		 * Get/Set borderRadius
		 */
		public function get borderRadius():Number 		{ return __borderRadius; }
		public function set borderRadius(v:Number):void { __borderRadius = v; __redraw(); }

		/**
		 * Get/Set knobBorderRadius
		 */
		public function get knobBorderRadius():Number 		{ return __knobBorderRadius; }
		public function set knobBorderRadius(v:Number):void	{ __knobBorderRadius = v; __redraw(); }
		
		/**
		 * Get/Set renderBackground callback function
		 */
		public function get renderBackground():Function 		{ return __background.render; }
		public function set renderBackground(v:Function):void 	{ __background.render = v; __redraw(); }

		/**
		 * Get/Set renderKnob callback function
		 */
		public function get renderKnob():Function 		{ return __knob.render; }
		public function set renderKnob(v:Function):void 	{ __knob.render = v; __redraw(); }
		
	}
}