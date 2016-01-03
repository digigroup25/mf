package mf.framework {
	import actions.AbstractAction;

	import flash.utils.Dictionary;

	public class ActionContainerDecorator extends ContainerDecorator {

		public function ActionContainerDecorator(container:Container2) {
			super(container);
			this.actions = new Dictionary(true);
		}

		public var actions:Dictionary;

		public function setAction(model:Object, action:AbstractAction):void {
			actionz[model] = action;

			this.dispatchEvent(new ActionContainerDecoratorEvent(ActionContainerDecoratorEvent.ACTION_ADDED, action));
		}

		public function getAction(model:Object):AbstractAction {
			return actionz[model];
		}

		public function hasAction(model:Object):Boolean {
			return (actionz[model] != undefined);
		}

		public function deleteAction(model:Object):void {
			delete actionz[model];
		}

		public function get numberOfActionableObjects():uint {
			var res:uint = 0;
			for (var model:Object in actions) {
				res++;
			}
			return res;
		}

		override public function toString():String {
			return "ActionContainerDecorator";
		}

		protected function get actionz():Dictionary { //there is a problem - conflicting package name actions and actions field
			return actions;
		}

		override protected function doInitialize():void {
			super.doInitialize();

			for each (var action:AbstractAction in actionz) {
				if (action)
					action.initialize();
			}
		}

		override protected function doUninitialize():void {
			for each (var action:AbstractAction in actionz) {
				action.uninitialize();
			}

			super.doUninitialize();
		}
	}
}
