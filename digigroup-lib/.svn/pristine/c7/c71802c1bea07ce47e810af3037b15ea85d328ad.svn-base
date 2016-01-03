package actions
{
	import collections.tree.AbstractTreeIterator;
	import collections.tree.BreadthFirstTreeIterator;
	
	/**
	 * User actions usually require user's input or provide user output.
	 * Some user actions require that a user invokes them directly,
	 * while others can be a part of composite action.
	 **/
	public class AbstractUserAction extends AbstractRepeatableAction
	{
		public var userInvocationOnly:Boolean = true;
		internal var initiatedFromUserExecute:Boolean = false;
		
		public function AbstractUserAction(name:String=null, repeatCount:int=1)
		{
			super(name, repeatCount);
		}
		
		protected override function canExecuteBody():Boolean {
			return (!userInvocationOnly || initiatedFromUserExecute);
		}
		
		override protected function executeBody():void {
			if (this.hasChildren()) {
				for each (var action:AbstractAction in this.getAccessibleChildren()) {
					if (action is AbstractUserAction) {
						var userAction:AbstractUserAction = AbstractUserAction(action);
						userAction.initiatedFromUserExecute = this.initiatedFromUserExecute;
					}
				}
			}
			super.executeBody();
		}
		
		public function userExecute():void {
			initiatedFromUserExecute = true;
			super.execute();
		}
		/**
		 * available actions are those with status NOT_STARTED and whose
		 * ascendants have status NOT_STARTED or COMPLETED. 
		 * available actions do not contain descendants of available actions.
		 * available actions are determined by using breadth-first search
		 **/
		/* override public function getAvailableActions(type:Class=null):Array {
			var res:Array = new Array();
			var it:AbstractTreeIterator = new BreadthFirstTreeIterator(this);
			//skip root (itself)
			it.next();
			
			while (it.hasNext()) {
				var action:AbstractAction = AbstractAction(it.peek());
				
				//if repeatable action traverse its children
				if (action is AbstractRepeatableAction && action.status==ActionStatus.COMPLETING) {
					it.next();
					continue;
				}  
				if (action.status!=ActionStatus.NOT_STARTED && action.status!=ActionStatus.COMPLETED) {
					it.skip();
					continue;
				}
				if (action.status==ActionStatus.NOT_STARTED && (type==null || action is type)) {
					res.push(action);
					it.skip();//do not add branch for traversal
					continue;
				}
				it.next();
			}
			return res;
		} */
		
		
		
		public override function copy():Object {
			var child:AbstractUserAction = AbstractUserAction(super.copy());
			child.userInvocationOnly = this.userInvocationOnly;
			return child;
		}
		/* private function cloneActions(actions:Array):Array {
			var res:Array = new Array();
			for each (var action:AbstractAction in actions) {
				var cloneAction:AbstractAction = AbstractAction(action.clone(false));
				cloneAction.children = null;
				res.push(cloneAction);
			}
			return res;
		} */
	}
}