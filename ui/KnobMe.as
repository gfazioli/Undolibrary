package undolibrary.ui {
	/*
	** @name			: KnobMe.as
	** @description		: Extends a MovieClip Test
	** @author			: =undo=
	** @web				: http://www.undolog.com
	** @email			: g.fazioli@undolog.com
	** 
	** @ver				: 1.0
	**
	** @movieclip		: background_mc
	**					: knob_mc
	**					: label_txt
	**					: value_txt
	**
	*/
	import flash.display.*;
	import flash.events.*;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;

	public class Knob extends MovieClip {
		/*
		** DEFINE CONSTANT CONTAINER
		**
		** definiscono il colore e le dimensioni del contenitore della knob
		*/
		protected const COLOR:Number				= 0x444444;
		protected const WIDTH:Number				= 200;
		protected const HEIGHT:Number				= 10;
		protected const MIN:Number					= 0;
		protected const MAX:Number					= 100;

		/*
		** DEFINE CONSTANT KNOB
		**
		** definiscono il colore e le dimensioni della manopola-knob
		*/
		protected const KNOB_COLOR:Number			= 0xaaaaff;
		protected const KNOB_WIDTH:Number			= 50;
		protected const KNOB_HEIGHT:Number			= HEIGHT;
		
		/*
		** INCAPSULTATE PROPERTIES
		*/
		protected var __color:Number				= COLOR;
		protected var __width:Number				= WIDTH;
		protected var __height:Number				= HEIGHT;
		
		protected var __knobColor:Number			= KNOB_COLOR;
		protected var __knobWidth:Number			= KNOB_WIDTH;
		protected var __knobHeight:Number			= KNOB_HEIGHT;
		
		protected var __value:Number				= MIN;
		protected var __min:Number					= MIN;
		protected var __max:Number					= MAX;
		
		/*
		** PRIVATE OBJECTS
		*/
		protected var __background:MovieClip;
		protected var __knob:MovieClip;
		/*
		** PRIVATE VAR
		*/
		protected var __mOffset:Number;
		protected var __maxMouse:Number;

		public function Knob ():void	{
			addEventListener(Event.ADDED_TO_STAGE, init );
		}
		
		/*
		** @name		: init()
		** @description	: trigged when added to stage
		*/
		protected function init( e:Event ):void {
			initProperties();
			initBackground();
			initKnob();
			initEvents();
			__redraw();
		}
		
		/*
		** @name		: initProperties()
		** @description	: call by init() - init all star properties
		*/
		protected function initProperties():void {
			__calc( __min );
			__maxMouse = __width - __knobWidth;
		}
		
		/*
		** @name		: initBackground()
		** @description	: call by init() - create/init background object
		*/
		protected function initBackground():void {
			__background 			= new MovieClip();
			addChild( __background );
		}
	
		/*
		** @name		: initKnob()
		** @description	: call by init() - create/init knob object
		*/
		protected function initKnob():void {
			__knob 					= new MovieClip();
			__knob.tw				= NaN;
			__knob.buttonMode 		= true;
			__knob.useHandCursor 	= true;
			__background.addChild( __knob );
		}
		
		/*
		** @name		: initEvents()
		** @description	: init all events
		*/
		protected function initEvents():void {
			__background.addEventListener( MouseEvent.MOUSE_DOWN, bgMouseDown );
			__knob.addEventListener( MouseEvent.MOUSE_DOWN, knobMouseDown );
			stage.addEventListener ( MouseEvent.MOUSE_UP, knobMouseUp );
		}
		
		/*
		** @name		: __redraw()
		*/
		protected function __redraw():void {
			__maxMouse = __width - __knobWidth;
			with( __background.graphics ) {
				clear();
				beginFill( __color );
				drawRect(0, 0, __width, __height );
			}
			with( __knob.graphics ) {
				clear();
				beginFill( __knobColor );
				drawRect(0, (__height-__knobHeight)/2, __knobWidth, __knobHeight );
			}
			this.Value = __value;
			dispatchEvent( new KnobEvent( KnobEvent.REDRAW, __value ) );
		}

		/*
		** @name		: bgMouseDown()
		** @description	: trigged when knob is clicked
		*/
		protected function bgMouseDown( e:MouseEvent ):void {
			var vf:Number =  mouseX - ( __knob.width / 2 );
			if( vf <= 0 ) vf = 0;
			if( vf >= __maxMouse ) vf = __maxMouse;
			if( !isNaN(__knob.tw) ) __knob.tw.stop();
			__knob.tw = new Tween (__knob, 'x', Strong.easeOut, __knob.x, vf, 1, true );
			__knob.tw.addEventListener( TweenEvent.MOTION_CHANGE,
				function ( e:TweenEvent ):void {
					__calc( e.position );
				}
			);
			
			e.updateAfterEvent();
		}

		/*
		** @name		: knobMouseDown()
		** @description	: trigged when knob is clicked
		*/
		protected function knobMouseDown( e:MouseEvent ):void {
			if( !isNaN(__knob.tw) ) __knob.tw.stop();
			e.stopImmediatePropagation();
			stage.addEventListener ( MouseEvent.MOUSE_MOVE, knobMouseMove );
			__mOffset = mouseX - __knob.x;
			e.updateAfterEvent();
		}
		
		/*
		** @name		: knobMouseUp();
		** @description	: trigged when mouse is up
		*/
		protected function knobMouseUp( e:MouseEvent ):void {
			stage.removeEventListener ( MouseEvent.MOUSE_MOVE, knobMouseMove );
		}

		/*
		** @name		: knobMouseMove();
		** @description	: trigged when mouse is moving
		*/
		protected function knobMouseMove( e:MouseEvent ):void {
			var vf:Number 				= mouseX - __mOffset;
			if( vf <= 0 ) 			vf	= 0;
			if( vf >= __maxMouse )	vf	= __maxMouse;
			__knob.x 					= vf; 
			__calc( vf );
			e.updateAfterEvent();
		}


		/*
		** @name		: __calc()
		** @description	: Trasforma la posizione del knob (0,n) in valore in base ai
		**				: parametri min e max la formula utilizzata è la seguente:
		**				: v = ((d-c)/(b-a))*(n-a)+c;
		**				: n varia da (a) a (b)
		**				: v(x=a) = c; v(x=b) = d;
		*/
		protected function __calc( n:Number ):Number {
			var a:Number = 0;
			var b:Number = __maxMouse;
			var c:Number = __min;
			var d:Number = __max;
			__value = ((d-c)/(b-a))*(n-a)+c;
			dispatchEvent( new KnobEvent( KnobEvent.CHANGE, __value ) );
			return __value;
		}
		
		/*
		** @property		: Value
		** @description		: get/set valore della manopola
		*/
		public function get Value():Number 			{ return __value; }
		public function set Value(v:Number):void 	{ 
			// to do : 
			if(v >= __min && v <= __max ) {
				__value		= v;
				__knob.x 	= (__value-__min)/( (__max-__min)/(__maxMouse) );
				__calc( __knob.x )
			}
		}
		
		/*
		** @property		: Max
		*/
		public function get Max():Number 			{ return __max; }
		public function set Max(v:Number):void		{ __max = v; __calc(__min); }
		
		/*
		** @property		: Min
		*/
		public function get Min():Number 			{ return __min; }
		public function set Min(v:Number):void 		{ __min = v; __calc(__min); }

		/*
		** @property		: Color
		*/
		public function get Color():Number 			{ return __color; }
		public function set Color(v:Number):void 	{ __color = v; __redraw(); }

		/*
		** @property		: Width
		*/
		public function get Width():Number 			{ return __width; }
		public function set Width(v:Number):void 	{ __width = v; __redraw(); }

		/*
		** @property		: Height
		*/
		public function get Height():Number 		{ return __height; }
		public function set Height(v:Number):void 	{ __height = v; __redraw(); }

		/*
		** @property		: KnobColor
		*/
		public function get KnobColor():Number 			{ return __knobColor; }
		public function set KnobColor(v:Number):void 	{ __knobColor = v; __redraw(); }

		/*
		** @property		: KnobWidth
		*/
		public function get KnobWidth():Number 			{ return __knobWidth; }
		public function set KnobWidth(v:Number):void 	{ __knobWidth = v; __redraw(); }

		/*
		** @property		: KnobHeight
		*/
		public function get KnobHeight():Number 		{ return __knobHeight; }
		public function set KnobHeight(v:Number):void 	{ __knobHeight = v; __redraw(); }

		/*
		** @property		: BackgroundClip
		*/
		public function get BackgroundClip():MovieClip 			{ return __background; }
		public function set BackgroundClip(v:MovieClip):void 	{ __background = v; __redraw(); }

		/*
		** @property		: KnobClip
		*/
		public function get KnobClip():MovieClip 		{ return __knob; }
		public function set KnobClip(v:MovieClip):void 	{ __knob = v; __redraw(); }

		
	}
}