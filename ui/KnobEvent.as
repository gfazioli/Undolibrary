package undolibrary.ui {
	/**
	 * KnobEvent is the Class Event for Knob Class
	 *
	 * @author			Giovambattista Fazioli <g.fazioli@undolog.com>
	 * @web				http://www.undolog.com
	 * @version			1.2.2
	 */	
	import flash.events.*;

	public class KnobEvent extends Event {
		
		// _______________________________________________________________ STATIC
		
		public static const CHANGE		:String 			= 'change';
		public static const START_DRAG	:String 			= 'start_drag';
		public static const STOP_DRAG	:String 			= 'stop_drag';
		public static const REDRAW		:String				= 'redraw';
		
		// _______________________________________________________________ INTERNAL
	
		protected var _value			:Number						= NaN;
		
		/**
		 * Constructor function for a KnobEvent object.
		 *
		 * @param type 			- The event type; indicates the action that caused the event.
		 * @param bubbles 		- Specifies whether the event can bubble up the display list hierarchy.
		 * @param cancelable	- Specifies whether the behavior associated with the event can be prevented.
		 * @param value			- The value of knob
		 *
		 */
		public function KnobEvent( type:String, bubbles:Boolean=false, cancelable:Boolean=false, v:Number=NaN ):void {
			super(type, bubbles, cancelable);
			_value = v;
		}
		
		/**
		 *  Gets the value
		 */
		public function get value():Number {
			return _value;
		}
		
		/**
		 * Returns a string that contains all the properties of the KnobEvent object.
		 *
		 * @override
		 */
		override public function toString():String {
			return formatToString("KnobEvent", "type", "bubbles", "value");
		}
		
		/**
		 * Creates a copy of the KnobEvent object and sets the value of each parameter to match
		 * the original.
		 *
		 * @override
		 */

		override public function clone():Event	{
			return new KnobEvent(type, bubbles, cancelable, _value);
		} 
	}
}