/**
 * @author Arnaud FOUCAL - http://afoucal.free.fr - afoucal@free.fr
 * 
 * @licence
 * This component is free for use, modification and distribution under the following condition:
 * 	Just mention the name and the url of the author in a part of your product that is visible to the user ("About"/"Credits" section, documentation...)
 * 
 * You can avoid this obligation with a donation
 * 
 * @version 1.0
 * 1st release
 * 
 * @version 1.1
 * - Added the property focusEnabled, set to false
 * - Fixed : the parent is now taken into account.
 * 	The Notification is not included in the parent container (as it is a popup) but the target x/y is calculated using the coordinates of the parent container.
 * 
 * @version 1.2
 * - Added the ability to display stacked Notifications (use the property stackable that is true by default)
 * 	Notifications that are centered, left or right centered are not stackable
 * 
 * @version 1.3
 * Great contribution by Herb Morris from Okinawa, Japan !
 * - Changed calculation to ensure a Notification is correctly displayed within the parent, not clipped
 * - Fixed a bug that could hang the application when lots of Notifications are displayed
 * - Added an easing function to the default effect.
 * - Added a duration for the closing effect.
 * 
 */


package Notificacion.com.notifications
{
	
	public class NotificationStackManager 
	{
		private static var _instance:NotificationStackManager;

		
		public function NotificationStackManager( type:PrivateStackManager ) 
		{
			if ( type == null )
				throw new Error("Error: NotificationStackManager is a singleton.");
		}
		
		
		/**
		 * Get the instance of the Singleton so that properties and methods can be called
		 */
		public static function getInstance():NotificationStackManager
		{
			if (_instance == null)
				_instance = new NotificationStackManager(new PrivateStackManager());
			
			return _instance;
		}
		
		
		/**
		 * The number of currently displayed Notification
		 */
		private var _count:int = 0;
		public function get count():int { return _count; }
		
		
		/**
		 * The level of the last Notification in the stack
		 * The property is reset if Notification goes out of the parent
		 */
		private var _stackTop:int = 1;
		public function get stackTop():int { return _stackTop; }
		public function set stackTop(value:int):void 
		{
			// only increments the stackTop.
			// used by the Notification when a new notification is added to the stack
			if (value >= _stackTop )
				_stackTop++;
		}

		
		/**
		 * Add a notificaton to the counters count and stackTop
		 * @param	notification
		 */
		public function add(notification:Notification):void 
		{
			_count++;
		}
		
		
		/**
		 * Remove a notification the main counter 'count'.
		 * If count is equal to zero, the stack is reset
		 */
		public function remove():void 
		{
			_count--;
			
			// reset the top of the stack when all notifications have been removed
			if ( _count <= 0 )
				resetStack();
		}
		
		
		/**
		 * Reset the stack
		 */
		public function resetStack() :void
		{
			_stackTop = 1;
		}
		
	}
	
}

internal class PrivateStackManager
{
	public function PrivateStackManager()	{}
}