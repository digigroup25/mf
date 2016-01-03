package mindmaps2.map.ui {
	import collections.TreeCollectionEx;

	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	import mx.controls.TextInput;
	import mx.controls.Tree;
	import mx.events.ListEvent;
	import mx.events.ListEventReason;
	import mx.events.PropertyChangeEvent;

	public class EditableTree extends Tree {
		//private var _selectedItem:Object;

		public function EditableTree() {
			super();

			this.editorUsesEnterKey = true;
			this.dragEnabled = true;
			this.dropEnabled = true;

			//addEventListener(ListEvent.ITEM_EDIT_BEGINNING, onTreeEditBeginning);
			addEventListener(ListEvent.ITEM_EDIT_END, onTreeEditEnd);
			addEventListener(ListEvent.CHANGE, onListChange);

		}

		private var previousSelectedItem:Object;

		private var _dataProvider:Object;

		override public function setFocus():void {
			this.editable = false;
			super.setFocus();
			this.editable = true;
		}

		override public function set dataProvider(value:Object):void {
			_dataProvider = value;
			super.dataProvider = value;
			this.callLater(this.expandItem, [ value, true ]);
		}

		override public function set selectedItem(data:Object):void {
			trace("EditableTree.selectedItem");
			/*if (data===selectedItem)
				return;*/

			expandSelectedItemAndAncestors(TreeCollectionEx(data));

			super.selectedItem = data;

			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedItem",
				previousSelectedItem, data));

			//this.dispatchEvent(new ListEvent(ListEvent.CHANGE, false, false));
		}

		override protected function keyDownHandler(event:KeyboardEvent):void {
			trace("EditableTree.keyDownHandler");
			super.keyDownHandler(event);
			if (event.keyCode == Keyboard.ENTER) {

				endEdit(ListEventReason.OTHER);
				setFocus();

			} else if (event.keyCode == Keyboard.SPACE) {
				this.editedItemPosition = { rowIndex: this.selectedIndex, columnIndex: 0 };
				//we have to explicitly expand the item, withouth this code the item children get collapsed
				this.expandItem(this.selectedItem, true);
			}

		}

		override protected function mouseUpHandler(event:MouseEvent):void {
			var saved:Boolean = editable;
			if (this.previousSelectedItem != this.selectedItem)
				editable = false;

			super.mouseUpHandler(event);

			editable = true;
		}

		private function onListChange(event:ListEvent):void {
			trace("EditableTree.onListChange");

			previousSelectedItem = selectedItem;

			var itemToExpand:TreeCollectionEx = TreeCollectionEx(selectedItem);
			expandSelectedItemAndAncestors(itemToExpand);
		}

		private function expandSelectedItemAndAncestors(node:TreeCollectionEx):void {
			var parents:Array = node.getPath(TreeCollectionEx(_dataProvider));
			for each (var parent:TreeCollectionEx in parents) {
				this.expandItem(parent, true);
			}

			this.expandItem(node, true);
			//trace(this.selectedItem);
		}

		private function onTreeEditEnd(event:ListEvent):void {
			trace("EditableTree.onTreeEditEnd");
			if (event.reason == ListEventReason.CANCELLED) {
				event.preventDefault();
				destroyItemEditor();
			} else {
				var newName:String = TextInput(itemEditorInstance).text;
				selectedItem.vo.name = newName;
			}
		}
	}
}
