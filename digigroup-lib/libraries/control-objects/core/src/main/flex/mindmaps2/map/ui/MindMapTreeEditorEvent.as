package mindmaps2.map.ui
{
	import collections.TreeCollectionEx;
	
	import flash.events.Event;

	public class MindMapTreeEditorEvent extends Event
	{
		public static const ELEMENT_EDIT_BEGIN:String = "elementEditBegin";
		public static const ELEMENT_EDIT_END:String = "elementEditEnd";
		public static const SELECTED_ELEMENT_CHANGED:String = "selectedElementChanged";
		public static const FOCUS_IN:String = "mindMapEditorFocusIn";
		public static const FOCUS_OUT:String = "mindMapEditorFocusOut";
		public static const ADD_ELEMENT:String = "addElement";
		public static const DELETE_ELEMENT:String = "deleteElement";
		
		private var _node:TreeCollectionEx;
		
		public function get node():TreeCollectionEx {
			return _node;
		}
		
		public var elementType:Class;
		
		public function MindMapTreeEditorEvent(type:String, node:TreeCollectionEx=null)
		{
			super(type, true, false);
			this._node = node;
		}
		
		public override function clone():Event {
			var res:MindMapTreeEditorEvent = new MindMapTreeEditorEvent(type, node);
			res.elementType = this.elementType;
			return res;
		}
		
		public static function createAddElement(elementType:Class):MindMapTreeEditorEvent {
			var res:MindMapTreeEditorEvent = new MindMapTreeEditorEvent(ADD_ELEMENT);
			res.elementType = elementType;
			return res;
		}
	}
}