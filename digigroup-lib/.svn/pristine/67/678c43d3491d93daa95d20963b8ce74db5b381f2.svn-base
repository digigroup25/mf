package actions
{
	import collections.AliasHashMap;
	import collections.tree.AbstractTreeIterator;
	
	public class AbstractRepeatableAction extends AbstractIOAction
	{
		
		private var _repeatCount:int;
		public static const INFINITE_REPEATS:int = int.MAX_VALUE;
		private static const REPEAT_COUNT_FOR_SINGLE_ACTION:int = 1;
		
		private var originalAction:AbstractRepeatableAction;
		
		public var isCopy:Boolean = false;
		
		public function get repeatCount():int {
			return _repeatCount;
		}
		
		public function set repeatCount(value:int):void {
			//check that repeatCount is set before action is executed (or even initialized?)
			_repeatCount = value;
		}
		
		//setting input after initializing the action
		//should be copied to original action since repeatable
		//actions will created from it
		public override function set input(value:AliasHashMap):void {
			super.input = value;
			if (originalAction!=null)
				originalAction.input = value;
		}
		
		internal function setRepeatCount(value:int):void {
			this._repeatCount = value;
		}
		
		protected function get numReplicatedChildren():int {
			var res:int = 0;
			for each (var child:AbstractAction in this.children) {
				if (child is AbstractRepeatableAction && AbstractRepeatableAction(child).isCopy) {
					res++;
				}
			}
			return res;
		}
		
		public function AbstractRepeatableAction(name:String=null, repeat:int=1)
		{
			super(name);
			//explicitly set to sequential
			super.type = ActionType.SEQUENTIAL;
			this.setRepeatCount(repeat); //repeat means total number of times an action can be executed
		}
		
		public override function initialize():void {
			if (this.initialized)
				return;
			if (canReplicate()) {
				copyOriginalAction();
				
				//set OR since as soon as any child succeeds, the action succeeds
				this.logicType = LogicType.OR;
				
				//remove all children as they will be replicated and appended along with child action
				if (this.hasChildren()) 
					this.children.removeAll();
				
				replicateAsChildAndSetup();
			}
			super.initialize();
		}
		
		
		internal function copyOriginalAction():void {
			originalAction = AbstractRepeatableAction(this.copy());
		}
		
		//TODO: need to distinguish whether a child is a replica or part of a composite action
		/* protected override function executeBody():void {
				super.executeBody();
		} */
		
		private function canReplicate():Boolean {
			if (this.repeatCount==1) return false;
			return this.repeatCount - this.numReplicatedChildren/*this.numChildren*/ >= REPEAT_COUNT_FOR_SINGLE_ACTION;
		}
		
		private function replicateAsChildAndSetup():AbstractRepeatableAction {
			trace("AbstractRepeatableAction.replicateAsChildAndSetup", this);
			var child:AbstractRepeatableAction = AbstractRepeatableAction(this.originalAction.copy());
			child.isCopy = true;
			child.setRepeatCount(REPEAT_COUNT_FOR_SINGLE_ACTION);
			child.canExecuteNextActionWhileCurrentIsCompleting = false;//or this.canExecut..=true, then allow 
																		//next copy of actions to be shown as available
			this.addActionListeners(child);

			child.initialize();
			this.addChild(child);
			return child;
		}
		
		/* protected override function propagateUpAndDetermineStatus(event:ActionStatusEvent):void {
			var child:AbstractAction = AbstractAction(event.target);
			if (this.numReplicatedChildren==1)
				processChildStatusChange(child.status, event);
			else super.propagateUpAndDetermineStatus(event);
		} */
		
		public override function copy():Object {
			var res:AbstractRepeatableAction = AbstractRepeatableAction(super.copy());
			//res.name = getNumberedName(res);
			res.setRepeatCount(this.repeatCount);
			
			
			/* if (res is AbstractRepeatableAction) {
				var repeatableChild:AbstractRepeatableAction = AbstractRepeatableAction(res);
				//repeatableChild.repeatCount = REPEAT_COUNT_FOR_SINGLE_ACTION;
				repeatableChild.isCopy = true;
			} */
			
			return res;
		}
		
		private function getNumberedName(action:AbstractAction):String {
			return action.name + this.numReplicatedChildren;
		}
		
		protected override function onChildActionCompleting(event:ActionEvent):void {
			if (!this.containsChild(event.targetAction))
				return;
			tryReplicate();
		}
		
		protected override function onChildActionFailing(event:ActionEvent):void {
			//if child action failed, only fail if all child actions have failed
			if (this.logicType==LogicType.OR && !allChildrenFailed()) {
				return;
			}
			fail();
		}
		
		private function tryReplicate():void {
			if (this.canReplicate()) {
				replicateAsChildAndSetup();
			}
		}
		
		override protected function handleActionAvailability(it:AbstractTreeIterator, res:Array):Boolean {
			var action:AbstractAction = AbstractAction(it.peek());
			//if repeatable action traverse its children
			if (action is AbstractRepeatableAction && action.status==ActionStatus.COMPLETING) {
				it.next();
				return true;
			}
			return false; 
		}
	}
}