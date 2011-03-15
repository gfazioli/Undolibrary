package undolibrary.utils {
	/**
	 * The CountDown class. This class manage a simple countdown 
	 *
	 * @class			CountDown
	 * @author			Giovambattista Fazioli <g.fazioli@undolog.com>
	 * @license     	http://creativecommons.org/licenses/by-nc-sa/3.0/
	 * @web				http://www.undolog.com
	 * @version			1.0
	 *
	 * @examples
	 *
	 *	var c:CountDown = new CountDown( 2009,1,1 );
 	 *	trace( c.leftHours );
	 */

	public class CountDown {
		private var _targetTime:Number;					// target date
		private var _leftDays:Number;					// days left
		private var _leftHours:Number;					// hours left
		private var _leftMinutes:Number;				// minutes left
		private var _leftSeconds:Number;				// seconds left
		private var _leftMilliseconds:Number;			// milliseconds left
		
		/**
		 * Class constructor
		 *
		 * @param		{varargs}	... args 	used actionscript vargs method
		 * @return 		void
		 */
		public function CountDown(... args):void {	
			_setCountDown( args );
		}
		
		/**
		 * Set main properties
		 *
		 * @param		{varargs}	... args 	used actionscript vargs method
		 * @return 		void
		 */
		public function setCountDown(... args):void {
			_setCountDown( args );
		}

		/**
		 * Set main parameters via string
		 *
		 * @param		{string}	v	Year, month, day, hour, minutes and seconds
		 * @return 		void
		 */
		public function setCountDownByText(v:String):void {
			var args:Array	= v.split(',');
			_setCountDown( args );
		}
		
		/**
		 * Set main parameters via string
		 *
		 * @param		{array}		args	Year, month, day, hour, minutes and seconds
		 * @return 		void
		 * @private
		 */
		private function _setCountDown(args:Array):void {
			// target day
			var d:Array				= [0,0,0,0,0,0,0];
			for (var i:String in args ) d[i] = args[i];
			var targetDay:Date		= new Date( d[0], d[1]-1, d[2], d[3], d[4], d[5], d[6] );
			_targetTime				= targetDay.getTime();
			Refresh();
		}
		
		/**
		 * Calculate timeleft
		 *
		 * @param		void
		 * @return		void
		 */
		public function Refresh():void {
			var today:Date			= new Date();
			var currentTime:Number	= today.getTime();
			// time left
			var timeLeft:Number		= _leftMilliseconds = ( _targetTime - currentTime );
			_leftSeconds			= Math.floor( _leftMilliseconds / 1000 );
			_leftMinutes			= Math.floor( _leftSeconds / 60 );
			_leftHours 				= Math.floor( _leftMinutes / 60 );
			_leftDays 				= Math.floor( _leftHours / 24 );
		}
		
		/**
		 * Set of properties for get single value left
		 *
		 * @return		{string}	Value left
		 */
		public function get leftDays():String			{ return String( _leftDays ); }
		public function get leftHours():String			{ return String( _leftHours % 24 ); }
		public function get leftMinutes():String		{ return String( _leftMinutes % 60 ); }
		public function get leftSeconds():String		{ return String( _leftSeconds % 60); }
		public function get leftMilliseconds():String	{ return String( _leftMilliseconds % 1000 ); }
	}
}