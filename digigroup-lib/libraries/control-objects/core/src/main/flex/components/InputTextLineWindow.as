package components {
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.core.UIComponent;

	public class InputTextLineWindow extends FloatingWindow {
		public function InputTextLineWindow() {
			super();
		}

		private var _inputText:SelfLabelingTextInput;

		private var add:Button;

		public function get input():String {
			return _inputText.text;
		}

		public function set input(value:String):void {
			_inputText.text = value;
		}

		public function get inputText():TextInput {
			return _inputText;
		}

		override public function setFocus():void {
			//super.setFocus();
			_inputText.setFocus();
		}

		override protected function createChildren():void {
			super.createChildren();

			this.height = 80;
			this.allowChildrenFocus = true;
			var container:UIComponent = new HBox();
			container.percentWidth = 100;
			_inputText = new SelfLabelingTextInput();
			_inputText.label = "Enter info";
			_inputText.percentWidth = 100;
			container.addChild(_inputText);
			add = new Button();
			add.label = "Add";

			container.addChild(add);
			this.dataContainer.addChild(container);

			add.addEventListener(MouseEvent.CLICK, onAddClick, false, 0, true);
			_inputText.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHadler, false, 0, true);
		}

		private function onAddClick(event:MouseEvent):void {
			dispatchAddToQueueEvent();
		}

		private function dispatchAddToQueueEvent():void {
			this.dispatchEvent(new InputTextLineWindowEvent(InputTextLineWindowEvent.TEXT_ADDED, this.input));
		}

		private function keyDownHadler(event:KeyboardEvent):void {
			if (event.keyCode != Keyboard.ENTER)
				return;
			dispatchAddToQueueEvent();
			//focus again
			_inputText.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN));
		}
	}
}
