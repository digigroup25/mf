package mindmaps.map.ui
{
	import flash.display.DisplayObject;
	
	import mf.framework.Message;
	
	public class PopUpMessagesFactory
	{
		private var sender:Object;
		public function PopUpMessagesFactory(sender:Object):void {
			this.sender = sender;
		}
		public function addPopUp(popup:DisplayObject, title:String, object:Object, objectProperty:String,
			windowLocation:Object=null):Message {
			return new Message(PopUpMessages.ADD, sender, 
				{popup:popup, title:title, object:object, objectProperty:objectProperty,
					windowLocation:windowLocation});
		}
		
		public function removePopUp(popup:DisplayObject):Message {
			return new Message(PopUpMessages.REMOVE, sender, {popup:popup});
		}
	}
}