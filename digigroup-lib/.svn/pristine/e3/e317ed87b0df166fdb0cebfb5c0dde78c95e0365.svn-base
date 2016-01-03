package mindmaps2.actions
{
	import actions.*;
	
	import mf.framework.Container2;
	
	public class UserActionCollector
	{
		public var traceEnabled:Boolean = true;
		/** returns all actions accessible to a user
		 *  ie. user actions that have not started
		 *  the tree is pruned as follows:
		 *  - prune if action is not started or completing or completed action is repeatable action and 
		 * 		has children that can be executed
		 **/
		public function getAvailableUserActions(action:AbstractAction):Array {
			
			if (action is AbstractUserAction  && action.status == ActionStatus.NOT_STARTED)
				return [action];
				
			if (!action.hasChildren()) 
				return [];
				
			var res:Array = [];
			var pruneChildren:Boolean = false;
			if (action is AbstractUserAction) {
				if (action.status==ActionStatus.COMPLETED) //if user action completed ignore children, unless it is repeatable action
					pruneChildren = true;// AbstractUserAction(action).repeatCount>1;
				else if (action.status==ActionStatus.COMPLETING) 
					pruneChildren = true;
			}
			else if ((action.status==ActionStatus.COMPLETING) || (action.status==ActionStatus.NOT_STARTED) 
				|| (action.status==ActionStatus.COMPLETED)) {
				pruneChildren = true;
			}
			
			trace_(action.name, "children are pruned", pruneChildren);
			if (pruneChildren) {
				var childActionsToPrune:Array = getChildActionsToPrune(action);
				for each (var child:AbstractAction in childActionsToPrune) {
					res = res.concat(this.getAvailableUserActions(child));
				}
			}
			return res;
		}
		
		private function trace_(... args):void {
			if (!traceEnabled) return;
			trace(args);
		}
		
		private function getChildActionsToPrune(action:AbstractAction):Array {
			var res:Array = [];
			for each (var childAction:AbstractAction in action.getAccessibleChildren()) {
				var status:String = childAction.status;
				if (status==ActionStatus.NOT_STARTED || status==ActionStatus.COMPLETING
					|| status==ActionStatus.COMPLETED) {
					res.push(childAction);
				}
			}
			
			if (action.type==ActionType.SEQUENTIAL && res.length>1) {//for sequential execution limit to 1 action
				trace_(action.name, "trimming children to CI + 1NS b/c sequential");
				//add all CI eligible children + next NS
				var completed:Array = action.getChildActionsWithStatus(ActionStatus.COMPLETED);
				var completing:Array = action.getChildActionsWithStatus(ActionStatus.COMPLETING); 
				var notStarted:Array = action.getChildActionsWithStatus(ActionStatus.NOT_STARTED);
				res = completed.concat(completing); 
				if (notStarted.length>=1) {
					res = res.concat(notStarted[0]);
				} 
				//res = [getNextNotCompletedAction(action.children)];
			}
			return res;
		}
		
		/* private function getNextNotCompletedAction(actions:ArrayCollection):AbstractAction {
			for each (var action:AbstractAction in actions) {
				if (action.status==ActionStatus.NOT_STARTED || action.status==ActionStatus.COMPLETING) { //why include completing?
					return action;
				}
			}
			return null;
		} */
		
		public function getAvailableUserActionsForContainer(action:AbstractAction, container:Container2):Array {
			var res:Array = [];
			var allAvailableActions:Array = this.getAvailableUserActions(action);
			for each (var action:AbstractAction in allAvailableActions) {
				if (action is AbstractIOAction && 
					AbstractIOAction(action).getInputForKey("invocationContainer")==container) {
					res.push(action);	
				}
			}
			
			return res;
		}
	}
}