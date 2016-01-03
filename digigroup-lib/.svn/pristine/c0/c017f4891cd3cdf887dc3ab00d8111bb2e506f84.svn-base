package mindmaps.map.ui {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;

	import mf.framework.AbstractController;
	import mf.framework.Message;

	import mindmaps.map.ui.actions.messages.MapMessages;

	import mx.collections.ArrayCollection;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class PopUpController extends AbstractController {

		public function PopUpController(popupContainer:DisplayObjectContainer) {
			this.popupContainer = popupContainer;
		}

		private var popups:ArrayCollection = new ArrayCollection();

		private var containerResizeAwarePopups:ArrayCollection = new ArrayCollection();

		private var popupContainer:DisplayObjectContainer;

		override public function receive(m:Message):void {
			switch (m.name) {
				case MapMessages.ACTIVATE:
					onActivate(m);
					break;
				case MapMessages.DEACTIVATE:
					onDeactivate(m);
					break;
				case PopUpMessages.ADD:
					onAddPopUp(m);
					break;
				case PopUpMessages.REMOVE:
					onRemovePopUp(m);
					break;
			}
		}

		override public function uninitialize():void {
			for each (var popupDescriptor:Object in popups) {
				PopUpManager.removePopUp(popupDescriptor.popup);
			}
			popups.removeAll();
			containerResizeAwarePopups.removeAll();
			super.uninitialize();
		}

		private function onAddPopUp(m:Message):void {
			var popup:IFlexDisplayObject = IFlexDisplayObject(m.body.popup);
			PopUpManager.addPopUp(popup, popupContainer);

			var popupDescriptor:Object = { popup: popup, title: m.body.title, object: m.body.object,
					objectProperty: m.body.objectProperty, windowLocation: m.body.windowLocation };
			var titleSuffix:String = null;
			if (popupDescriptor.object != null && popupDescriptor.title != null && popupDescriptor.objectProperty != null) {
				popupDescriptor.object.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
				titleSuffix = popupDescriptor.object[popupDescriptor.objectProperty];
			}
			//update title manually for the first time
			setTitle(popupDescriptor, titleSuffix);

			if (popupDescriptor.windowLocation == null)
				PopUpManager.centerPopUp(popup);
			else {
				popupContainer.addEventListener(Event.RESIZE, onPopupContainerResize, false, 0, true);
				containerResizeAwarePopups.addItem(popupDescriptor);
				//force first update
				onPopupContainerResize(null);
			}
			popups.addItem(popupDescriptor);
			popupDescriptor.popup.addEventListener(Event.CLOSE, onPopUpClose, false, 0, true);
		}

		private function onPopupContainerResize(event:Event):void {
			for each (var popupDescriptor:Object in this.containerResizeAwarePopups) {
				//always aligns bottom right 
				//should look at window location properties - (horizontal, vertical)
				var popup:UIComponent = UIComponent(popupDescriptor.popup);
				popup.x = popupContainer.width - popup.width;
				var yOffset:int = popupContainer.localToGlobal(new Point(0, 0)).y;
				popup.y = popupContainer.height - popup.height + yOffset;
			}
		}

		private function onPropertyChange(event:PropertyChangeEvent):void {
			var object:Object = event.target;
			var popupDescriptor:Object = findPopupDescriptorFor("object", object);
			if (event.property != popupDescriptor.objectProperty) //ignore property updates on object that should affect the title
				return;
			setTitle(popupDescriptor, String(event.newValue));
		}

		private function setTitle(popupDescriptor:Object, name:String):void {
			var title:String = (name == null) ? popupDescriptor.title : StringUtil.substitute(popupDescriptor.title, name);
			//if (popupDescriptor.popup.hasOwnProperty("title"))
			popupDescriptor.popup.title = title;
		}

		private function onRemovePopUp(m:Message):void {
			removePopUp(m.body.popup);
		}

		private function removePopUp(popup:IFlexDisplayObject):void {
			var popupDescriptor:Object = findPopupDescriptorFor("popup", popup);
			if (popupDescriptor == null)
				return;

			if (popupDescriptor.object != null)
				popupDescriptor.object.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
			popups.removeItemAt(popups.getItemIndex(popupDescriptor));

			PopUpManager.removePopUp(popup);
		}

		private function onActivate(m:Message):void {
			//show popups
			for each (var popupDescriptor:Object in popups) {
				PopUpManager.addPopUp(popupDescriptor.popup, popupContainer);
			}
		}

		private function onDeactivate(m:Message):void {
			//hide popups
			for each (var popupDescriptor:Object in popups)
				PopUpManager.removePopUp(popupDescriptor.popup);
		}

		private function onPopUpClose(e:Event):void {
			var popup:IFlexDisplayObject = IFlexDisplayObject(e.target);
			removePopUp(popup);
		}

		private function findPopupDescriptorFor(property:String, propertyValue:Object):Object {
			for (var i:int = 0; i < popups.length; i++) {
				var popupDescriptor:Object = popups[i];
				if (propertyValue == popupDescriptor[property])
					return popupDescriptor;
			}
			return null;
		}
	}
}
