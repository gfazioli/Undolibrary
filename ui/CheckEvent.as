package undolibrary.ui {
	/*
	** @name			: CheckEvent.as
	** @description		: Classe derivata da Event per gestire un proprio evento personalizzato
	** @author			: =undo=
	** @web				: http://www.undolog.com
	** @email			: g.fazioli@undolog.com
	** 
	** @ver				: 1.0
	*/	
	import flash.events.*;

	public class CheckEvent extends Event {
		
		public static const CHANGE:String 			= 'change';
		public static const REDRAW:String			= 'redraw';
		//
		public var Value:Boolean					= false;
		
		/*
		** Constructor function for a KnobEvent object.
		**
		** @param type 			- The event type; indicates the action that caused the event.
		** @param v 			- The value of knob
		** @param bubbles 		- Specifies whether the event can bubble up the display list hierarchy.
		** @param cancelable	- Specifies whether the behavior associated with the event can be prevented.
		**
		*/
		public function CheckEvent( type:String, v:Boolean, bubbles:Boolean=false, cancelable:Boolean=false ):void {
			super(type, bubbles, cancelable);
			this.Value = v;
		}
		
		/*
		** @override
		*/
		override public function clone():Event	{
			return new CheckEvent(this.type, this.Value, this.bubbles, this.cancelable);
		} 
	}
}