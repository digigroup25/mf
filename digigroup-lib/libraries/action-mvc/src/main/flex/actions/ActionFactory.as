package actions
{
	public class ActionFactory
	{
		public function sequentialAND(name:String, children:Array=null):AbstractAction {
			var res:AbstractAction = createWithChildren(name, children);
			res.type = ActionType.SEQUENTIAL;
			res.logicType = LogicType.AND;
			return res;
		}
		
		public function sequentialOR(name:String, children:Array=null):AbstractAction {
			var res:AbstractAction = createWithChildren(name, children);
			res.type = ActionType.SEQUENTIAL;
			res.logicType = LogicType.OR;
			return res;
		}
		
		public function parallelAND(name:String, children:Array=null):AbstractAction {
			var res:AbstractAction = createWithChildren(name, children);
			res.type = ActionType.PARALLEL;
			res.logicType = LogicType.AND;
			return res;
		}
		
		public function parallelOR(name:String, children:Array=null):AbstractAction {
			var res:AbstractAction = createWithChildren(name, children);
			res.type = ActionType.PARALLEL;
			res.logicType = LogicType.OR;
			return res;
		}
		
		private function createWithChildren(name:String, children:Array):AbstractAction {
			var res:AbstractAction = new AbstractAction(name);
			if (children) {
				for each (var child:AbstractAction in children) {
					res.addChild(child);
				}
			}
			return res;
		}
		
		public function createAction(name:String, type:String, logicType:String, repeatCount:uint, 
			userFacing:Boolean):AbstractAction {
			var res:AbstractAction;
			if (userFacing) {
				var userAction:AbstractUserAction = new AbstractUserAction(name, repeatCount);
				res = userAction;
			}
			else if (repeatCount>1) {
				res = new AbstractRepeatableAction(name, repeatCount);
			} 
			else {
				res = new AbstractIOAction(name);
			}
			res.type = type;
			res.logicType = logicType;
			return res;
		}
	}
}