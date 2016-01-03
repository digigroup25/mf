package uiengine
{
	import actions.AbstractUserAction;
	import actions.IActionDescriptor;
	
	import commonutils.ClassInspector;
	
	public class ActionRepository
	{
		private var _actions:Array = new Array();
		private var ci:ClassInspector = new ClassInspector();
		private var voType:Class; //used by getActionsByVOType
		public function ActionRepository()
		{
		}
		
		public function add(action:IActionDescriptor):void {
			_actions.push(action);
		}
		
		public function getNonVoActions():Array {
			return _actions.filter(filterActions);
		}
		
		private function filterActions(element:*, index:int, arr:Array):Boolean {
			var res:Boolean = (element is AbstractUserAction);
			return res;
		}
		
		public function getByVOType(voType:Class):Array {
			this.voType = voType;
			/* var res:ArrayCollection = new ArrayCollection();
			for each (var action:ActionDescriptor2 in _actions) {
				if (isA(voType, action.voType)) {
					res.addItem(action);
				}
			}
			return res; */
			return _actions.filter(getActionsByVOType);
		}
		
		private function getActionsByVOType(element:*, index:int, arr:Array):Boolean {
			var res:Boolean = (element is ActionDescriptor2 && isA(element.voType, voType));
			return res;
		}
		
		private function isA(type1:Class, type2:Class):Boolean {
			if (type1==type2) return true;
			if (ci.implementsInterface(type1, type2)) return true;
			return false;
		}
	}
}