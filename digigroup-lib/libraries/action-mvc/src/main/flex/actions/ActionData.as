package actions
{
	import mx.utils.StringUtil;
	
	public class ActionData
	{
		public var name:String;
		public var type:String = ActionType.SEQUENTIAL;
		public var logicType:String = LogicType.AND;
		public var canExecuteNextActionWhileCurrentIsCompleting:Boolean = false;
		public var keepExecutingOrActions:Boolean = false;
		
		public function ActionData(name:String=null)
		{
			this.name = name;
		}
		
		public function clone():Object {
			var res:ActionData = new ActionData();
			res.name = this.name;
			res.type = this.type;
			res.logicType = this.logicType;
			res.canExecuteNextActionWhileCurrentIsCompleting = this.canExecuteNextActionWhileCurrentIsCompleting;
			res.keepExecutingOrActions = this.keepExecutingOrActions;
			return res;
		}
		
		public function toString():String {
			return StringUtil.substitute("{0}, {1}, {2}", this.name, this.type, this.logicType);
		}
	}
}