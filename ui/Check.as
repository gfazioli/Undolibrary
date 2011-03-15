package undolibrary.ui {
	/**
	 * Check Class is part of undolibrary: Check is a very light check button
	 * you can customize layout and behaviour:
	 *
	 * METHODS
	 * 	refresh()			Redraw all check layout
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
	 *	CHANGE				Trigged when check value is changed
	 *	REDRAW				Trigged when the check layout is redraw
	 *
	 *
	 * Check Class is released under version 3.0 of the Creative Commons 
	 * Attribution-Noncommercial-Share Alike license. This means that it is 
	 * absolutely free for personal, noncommercial use provided that you 1)
	 * make attribution to the author and 2) release any derivative work under
	 * the same or a similar license.
	 *
	 * This program is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	 *
	 * If you wish to use Check Class for commercial purposes, licensing information
	 * can be found at http://www.undolog.com	 
	 *
	 * @author			Giovambattista Fazioli <g.fazioli@undolog.com>
	 * @web				http://www.undolog.com
	 * @version			1.2.0
	 *
	 * CHANGE LOG
	 *	1.2.0			Fix bugs, rev namespace and code. Add and remove some new properties
	 *	1.0.1			first release
	 *
	 */

	import flash.display.*;
	import flash.events.*;
	
	public class Check extends MovieClip {
		// _______________________________________________________________ STATIC
		
		static public const NAME			:String				= "Check Class";
		static public const VERSION			:String 			= "1.2.0";
		static public const AUTHOR			:String 			= "Giovambattista Fazioli <g.fazioli@undolog.com>";
		
		static private const COLOR			:Number				= 0xeeeeee;		// default color of background container
		static private const WIDTH			:Number				= 12;			// default with of container
		static private const HEIGHT			:Number				= 12;			// default height of container

		static private const CHECK_COLOR	:Number				= 0xff9900;		//
		static private const CHECK_WIDTH	:Number				= WIDTH  - 6;
		static private const CHECK_HEIGHT	:Number				= HEIGHT - 6;
		
		/*
		** INCAPSULTATE PROPERTIES
		*/
		protected var __color:Number				= COLOR;
		protected var __width:Number				= WIDTH;
		protected var __height:Number				= HEIGHT;
		
		protected var __checkColor:Number			= CHECK_COLOR;
		protected var __checkWidth:Number			= CHECK_WIDTH;
		protected var __checkHeight:Number			= CHECK_HEIGHT;
		
		protected var __value:Boolean				= false;
		
		/*
		** PRIVATE OBJECTS
		*/
		protected var __background:MovieClip;
		protected var __check:MovieClip;

		public function Check ():void	{
			addEventListener(Event.ADDED_TO_STAGE, init );
		}
		
		/*
		** @name		: init()
		** @description	: trigged when added to stage
		*/
		protected function init( e:Event ):void {
			initProperties();
			initBackground();
			initCheck();
			initEvents();
			__redraw();
		}
		
		/*
		** @name		: initProperties()
		** @description	: call by init() - init all star properties
		*/
		protected function initProperties():void {

		}
		
		/*
		** @name		: initBackground()
		** @description	: call by init() - create/init background object
		*/
		protected function initBackground():void {
			__background 				= new MovieClip();
			addChild( __background );
			__background.useHandCursor	= true;
			__background.buttonMode		= true;
		}
	
		/*
		** @name		: initKnob()
		** @description	: call by init() - create/init knob object
		*/
		protected function initCheck():void {
			__check					= new MovieClip();
			__check.buttonMode 		= true;
			__check.useHandCursor 	= true;
			__background.addChild( __check );
		}
		
		/*
		** @name		: initEvents()
		** @description	: init all events
		*/
		protected function initEvents():void {
			__background.addEventListener( MouseEvent.CLICK, checkClick );
			//__check.addEventListener( MouseEvent.CLICK, checkClick );
		}
		
		/*
		** @name		: __redraw()
		*/
		protected function __redraw():void {
			with( __background.graphics ) {
				clear();
				beginFill(0, 1);
				drawRect(0, 0, __width, __height );
				endFill();
				beginFill(__color, 1);
				drawRect(1, 1, __width-2, __height-2 );
			}
			with( __check.graphics ) {
				clear();
				if( __value ) {
					beginFill( __checkColor );
					drawRect( (__width-__checkWidth)/2, (__height-__checkHeight)/2, __checkWidth, __checkHeight );
				}
			}
		}
		
		/*
		** @name		: chickClick();
		** @description	: trigged when check i s cliccked
		*/
		protected function checkClick( e:MouseEvent = null):void {
			__value = !__value;
			__redraw();
			dispatchEvent( new CheckEvent( CheckEvent.CHANGE, __value ) );
		}
		
		/*
		** @property		: Value
		** @description		: get/set valore della manopola
		*/
		public function get Value():Boolean 		{ return __value; }
		public function set Value(v:Boolean):void 	{ __value = v; __redraw(); }

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
		** @property		: CheckColor
		*/
		public function get CheckColor():Number 			{ return __checkColor; }
		public function set CheckColor(v:Number):void 	{ __checkColor = v; __redraw(); }

		/*
		** @property		: CheckWidth
		*/
		public function get CheckWidth():Number 			{ return __checkWidth; }
		public function set CheckWidth(v:Number):void 	{ __checkWidth = v; __redraw(); }

		/*
		** @property		: CheckHeight
		*/
		public function get CheckHeight():Number 		{ return __checkHeight; }
		public function set CheckHeight(v:Number):void 	{ __checkHeight = v; __redraw(); }

		/*
		** @property		: BackgroundClip
		*/
		public function get BackgroundClip():MovieClip 			{ return __background; }
		public function set BackgroundClip(v:MovieClip):void 	{ __background = v; __redraw(); }

		/*
		** @property		: CheckClip
		*/
		public function get CheckClip():MovieClip 		{ return __check; }
		public function set CheckClip(v:MovieClip):void 	{ __check = v; __redraw(); }
	}
}