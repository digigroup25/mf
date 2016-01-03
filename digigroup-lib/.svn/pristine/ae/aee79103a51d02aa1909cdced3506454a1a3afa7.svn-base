package components {
	import flash.events.MouseEvent;

	import mx.controls.CheckBox;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.core.mx_internal;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	import mx.events.TreeEvent;

	use namespace mx_internal;

	[Deprecated("Use TaskItemRenderer instead")]
	public class TreeCheckBoxItemRenderer extends TreeItemRenderer {

		public function TreeCheckBoxItemRenderer() {
			super();
		}

		protected var _checkbox:CheckBox;

		public function get checkBox():CheckBox {
			return _checkbox;
		}

		override public function set data(value:Object):void {
			if (data && data.vo && data.vo.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
				data.vo.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
					onPropertyChange);
			super.data = value;
			if (data && data.vo) {
				data.vo.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange, false, 0, true);
			}
		}

		override protected function createChildren():void {
			super.createChildren();
			if (!_checkbox) {
				_checkbox = new CheckBox();
				_checkbox.mouseEnabled = false;
					//addChild(_checkbox);
			}
		}

		override protected function measure():void {
			super.measure();

			var w:Number = data ? (listData as TreeListData).indent : 0;

			if (disclosureIcon)
				w += disclosureIcon.width;

			if (icon)
				w += icon.measuredWidth;

			if (label.width < 4 || label.height < 4) {
				label.width = 4;
				label.height = 16;
			}

			if (isNaN(explicitWidth)) {
				w += label.getExplicitOrMeasuredWidth();
				//w += _checkbox.getExplicitOrMeasuredWidth();
				measuredWidth = w;
				measuredHeight = Math.max(_checkbox.getExplicitOrMeasuredHeight(), label.getExplicitOrMeasuredHeight());
			} else {
				label.width = Math.max(explicitWidth - (w /*+ _checkbox.getExplicitOrMeasuredWidth()*/), 4);
				measuredHeight = Math.max(_checkbox.getExplicitOrMeasuredHeight(), label.getExplicitOrMeasuredHeight());

				if (icon && icon.measuredHeight > measuredHeight)
					measuredHeight = icon.measuredHeight;
			}
		}

		override protected function commitProperties():void {
			super.commitProperties();

			if (data != null) {
				var showCheckBox:Boolean = data.vo.done > 0;
				if (!showCheckBox) {
					if (this.contains(checkBox))
						this.removeChild(checkBox);
				} else {
					this.addChild(checkBox);
					checkBox.selected = true;
				}
			}
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var startx:Number = data ? (listData as TreeListData).indent : 0;

			if (disclosureIcon) {
				disclosureIcon.x = startx;
				startx = disclosureIcon.x + disclosureIcon.width;
				disclosureIcon.setActualSize(disclosureIcon.width, disclosureIcon.height);
				disclosureIcon.visible = data ? (listData as TreeListData).hasChildren : false;
			}

			if (icon) {
				icon.x = startx;
				icon.setActualSize(icon.measuredWidth, icon.measuredHeight);
			}

			if (checkBox) {
				checkBox.x = startx;
				checkBox.setActualSize(checkBox.measuredWidth, checkBox.measuredHeight);
			}

			startx = icon.x + Math.max(icon.measuredWidth, checkBox.measuredWidth);

			label.x = startx;
			label.setActualSize(unscaledWidth - startx, measuredHeight);

			var verticalAlign:String = getStyle("verticalAlign");

			if (verticalAlign == "top") {
				label.y = 0;
				_checkbox.y = 0;

				if (icon)
					icon.y = 0;
				if (disclosureIcon)
					disclosureIcon.y = 0;
			} else if (verticalAlign == "bottom") {
				label.y = unscaledHeight - label.height + 2; // 2 for gutter
				_checkbox.y = unscaledHeight - checkBox.height + 2; // 2 for gutter
				if (icon)
					icon.y = unscaledHeight - icon.height;
				if (disclosureIcon)
					disclosureIcon.y = unscaledHeight - disclosureIcon.height;
			} else {
				label.y = (unscaledHeight - label.height) / 2;
				checkBox.y = (unscaledHeight - checkBox.height) / 2;
				if (icon)
					icon.y = (unscaledHeight - icon.height) / 2;
				if (disclosureIcon)
					disclosureIcon.y = (unscaledHeight - disclosureIcon.height) / 2;
			}
		}

		protected function onPropertyChange(event:PropertyChangeEvent):void {
			if (event.kind == PropertyChangeEventKind.UPDATE && event.property == "done")
				this.invalidateProperties();
		}
	}
}
