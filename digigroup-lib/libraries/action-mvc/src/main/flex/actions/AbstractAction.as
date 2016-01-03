package actions
{
	import assertions.Require;
	
	import collections.tree.AbstractTreeIterator;
	import collections.tree.BreadthFirstTreeIterator;
	import collections.tree.DoubleLinkedTree;
	
	import commonutils.ClassInspector;
	
	import mf.framework.IManagedLifecycle;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	/**
	 * Allows for both sequential and parallel execution of actions and AND/OR logic for determining success 
	 * of a composite action.  If sequential, every child action is processed 
	 * one after another (upon completed status). Then the body of the action is executed.  If parallel, 
	 * all child actions are executed and once all of them have been completed, the action body is executed.
	 * By default actions are sequential.
	 * 
	 **/
	public class AbstractAction extends DoubleLinkedTree implements IActionDescriptor, IManagedLifecycle
	{
		private const ci:ClassInspector = new ClassInspector();
		
		internal var actionData:ActionData;
		private var _showTrace:Boolean = false;
		private var _status:String;
		private var _preconditions:Array;
		
		public var doExecuteFunction:Function = null;
		
		protected var _initialized:Boolean = false;
		
		private function encounteredFailure():Boolean {
			return this.status == ActionStatus.FAILING || this.status == ActionStatus.FAILED;
		}
		
		public function get initialized():Boolean {
			return _initialized;
		}
		
		public function get showTrace():Boolean {
			return _showTrace;
		}
		
		public function set showTrace(value:Boolean):void {
			this._showTrace = value;
			for each (var child:AbstractAction in this.children) {
				child.showTrace = value;
			}
		}
		
		public function get label():String {
			return name;
		}
		
		public function set label(value:String):void {
			actionData.name = value;
		}
		
		public function get name():String {
			return actionData.name;
		}
		
		public function set name(value:String):void {
			actionData.name = value;
		}
		
		public function get type():String {
			return actionData.type;
		}
		
		public function set type(value:String):void {
			actionData.type = value;
		}
		
		public function get logicType():String {
			return actionData.logicType;
		}
		
		public function set logicType(value:String):void {
			actionData.logicType = value;
		}
		
		public function get canExecuteNextActionWhileCurrentIsCompleting():Boolean {
			return actionData.canExecuteNextActionWhileCurrentIsCompleting;
		}
		
		public function set canExecuteNextActionWhileCurrentIsCompleting(value:Boolean):void {
			actionData.canExecuteNextActionWhileCurrentIsCompleting = value;
		}
		
		public function get keepExecutingOrActions():Boolean {
			return actionData.keepExecutingOrActions;
		}
		
		public function set keepExecutingOrActions(value:Boolean):void {
			actionData.keepExecutingOrActions = value;
		}
		
		[Bindable(event="statusChange")]
		public function get status():String {
			return _status;
		}
		
		private function isLegalStatusTransition(newStatus:String):Boolean {
			var res:Boolean = false;
			if (!initialized)
				return true;//ignore status setting if action has not been initialized yet
			switch(this.status) {
				case ActionStatus.NOT_STARTED: 
					if (newStatus==ActionStatus.COMPLETING) {
						res = true;
					}
					break;
				case ActionStatus.COMPLETING:
					if (newStatus==ActionStatus.COMPLETED || newStatus==ActionStatus.FAILING) {
						res = true;
					}
					break;
				case ActionStatus.COMPLETED:
					if (newStatus==ActionStatus.FAILING) {
						res = true;
					}
					break;
				case ActionStatus.FAILING:
					if (newStatus==ActionStatus.FAILED) {
						res = true;
					}
					break;
			}
			return res;
		}
		
		private function throwIllegalStatusTransition(currentStatus:String, newStatus:String):void {
			throw new ActionError(StringUtil.substitute("Illegal status transition from {0} to {1}", currentStatus, newStatus));
		}
		
		//internal for testing
		public function set status (value:String) :void {
			if (_status==value) return;
			if (!isLegalStatusTransition(value)) {
				throwIllegalStatusTransition(this.status, value);
			}
			_status = value;
			traceStatus();
			
			var event:ActionEvent = new ActionEvent(ActionEvent.STATUS_CHANGE,
				this, this.status);
			this.dispatchEvent(event);
		} 
		
		
		public function set preconditions(value:Array):void {
			Require.notNull(value, "preconditions");
			//Require.hasAllElementsOfType(value, "preconditions", Function);
			
			this._preconditions = value;
		}
		
		public function AbstractAction(name:String=null) {
			if (name==null)
				name = ci.getClassName(this, true);
			this.actionData = new ActionData(name);
			this._status = ActionStatus.NOT_STARTED;
		}
		
		public function initialize():void {
			if (initialized) return;
			
			for each (var action:AbstractAction in this.children) {
				addActionListeners(action);
				action.initialize();
			}
			
			_initialized = true;
		}
		
		public function uninitialize():void {
			for each (var action:AbstractAction in this.children) {
				action.uninitialize();
				this.removeActionListeners(action);
			}
			
			_initialized = false;
		}
		
		//this is a template method and cannot be overridden
		public final function execute():void {
			if (!initialized) {
				throw new ActionError("Action has to be initialized before executing");
			}
			//should not be able to execute an action which has finished
			//executing or is in progress
			if (this.status!=ActionStatus.NOT_STARTED) return;
			
			if (canExecuteBody()) {
				if (checkPreconditions()) { //check preconditions before setting status to completing
					setCompleting();
					executeBody();
				}
			} else {
				trace("AbstractAction: dispatching UNABLE_TO_EXECUTE", this);
				var event:ActionEvent = new ActionEvent(ActionEvent.UNABLE_TO_EXECUTE, this);
				this.dispatchEvent(event);
			}
		}
		
		protected function canExecuteBody():Boolean {
			return true;
		}
		
		protected function executeBody():void {
			if (canExecuteChildren()) 
				executeChildren();
			else if (doExecuteFunction!=null) {
				doExecuteFunction(this);
			}
			else doExecute();
		}
		
		protected function canExecuteChildren():Boolean {
			return this.hasChildren();
		}
		
		protected function executeChildren():int {
			var actionsToExecute:Array = getActionsToExecute();
			executeActions(actionsToExecute);
			return actionsToExecute.length;
		}
		
		protected function executeActions(actions:Array):void {
			for each (var action:AbstractAction in actions) {
				action.execute();
			}
		}
		
		private function checkPreconditions():Boolean {
			for each (var precondition:Function in this._preconditions) {
				if (!precondition()) return false;
			}
			return true;
		}
		
		protected function addActionListeners(action:AbstractAction):void {
			//modify itself before notifying other listeners
			action.addEventListener(ActionEvent.STATUS_CHANGE, propagateUpAndDetermineStatus, false, 1); 
			action.addEventListener(ActionEvent.UNABLE_TO_EXECUTE, propagateEventUp, false, 1); 
		}
		
		protected function removeActionListeners(action:AbstractAction):void {
			action.removeEventListener(ActionEvent.STATUS_CHANGE, propagateUpAndDetermineStatus);
			action.removeEventListener(ActionEvent.UNABLE_TO_EXECUTE, propagateEventUp);
		}
		
		protected function propagateUpAndDetermineStatus(event:ActionEvent):void {
			trace("AbstractAction.propagateUpAndDetermineStatus", "current action:", this.toString() + ";", event);
			var child:AbstractAction = AbstractAction(event.target);
			propagateEventUp(event);
			processChildStatusChange(child.status, event);
			
		}
		
		private function propagateEventUp(event:ActionEvent):void {
			this.dispatchEvent(event);
		}
		
		protected function processChildStatusChange(childStatus:String, event:ActionEvent):void {
			//trace("AbstractAction.processChildStatusChange", event);
			switch (childStatus) {
				case ActionStatus.COMPLETING:
					onChildActionCompleting(event);
					break;
				case ActionStatus.COMPLETED:
					onChildActionCompleted(event);
					break;
				case ActionStatus.FAILING:
					onChildActionFailing(event);
					break;
				case ActionStatus.FAILED:
					onChildActionFailed(event);
					break;
				
			}
		}
		
		protected function getActionsToExecute():Array {
			var res:Array = getChildActionsWithStatus(ActionStatus.NOT_STARTED); //for parallel execution
			if (type==ActionType.SEQUENTIAL && res.length>1) //for sequential execution limit to 1 action
				res = [res[0]];
			return res;
		}
		
		public function getChildExecutableActions():Array {
			return getActionsToExecute();
		}
		
		protected function doExecute():void {
			setCompleted();
		}
		
		protected function doExecuteFail():void {
			setFailed();
		}
		
		private function allChildActionsHaveStatus(status:String):Boolean {
			for each (var action:AbstractAction in getAccessibleChildren()) {
				if (action.status!=status) return false;
			}
			return true;
		}
		
		public function getAccessibleChildren():ArrayCollection {
			var res:ArrayCollection = new ArrayCollection(this.children.toArray());//copy all elements
			//hack, should really find the last completing action
			//and then trim next actions that are not started
			if (this.type==ActionType.SEQUENTIAL && !actionData.canExecuteNextActionWhileCurrentIsCompleting) {
				if (res.length<2)
					return res;
				var lastAction:AbstractAction = AbstractAction(res.getItemAt(res.length-1));
				var oneBeforelastAction:AbstractAction = AbstractAction(res.getItemAt(res.length-2));
				if (oneBeforelastAction.status==ActionStatus.COMPLETING && lastAction.status==ActionStatus.NOT_STARTED) {
					res.removeItemAt(res.length-1);
				}
			}
			return res;
		}
		
		private function traceStatus():void {
			if (showTrace) trace(this);
		}
		
		protected function tryExecutingChildren():Boolean {
			if (!allChildrenFailed()) {
				executeChildren();
				return true;
			}
			return false;
		}
		
		
		protected function onChildActionCompleting(event:ActionEvent):void {
			
		}
		
		protected function onChildActionCompleted(event:ActionEvent):void {
			var action:AbstractAction = AbstractAction(event.target);
			Assert.isTrue(action.status==ActionStatus.COMPLETED, "Completed action should have status completed");
			//even if child is completed, it can be aborted later by its ancestor
			//removeActionListeners(action);
			
			//if child action was executed directly, ignore
			if (this.status==ActionStatus.NOT_STARTED)
				return;
			
			/*
			if ((this.logicType==LogicType.OR) 
				|| (this.logicType==LogicType.AND && allChildActionsHaveStatus(ActionStatus.COMPLETED))){
				setCompleted();
				return;
			}
			*/
			if (this.logicType==LogicType.OR) { 
				setCompleted();
				if (!keepExecutingOrActions)
					return;
			} else if (this.logicType==LogicType.AND && allChildActionsHaveStatus(ActionStatus.COMPLETED)) {
				setCompleted();
				return;
			}
			
			executeChildren();
		}
		
		protected function onChildActionFailing(event:ActionEvent):void {
			var action:AbstractAction = AbstractAction(event.target);
			
			if (this.status==ActionStatus.NOT_STARTED) 
				return;
			
			if (this.logicType==LogicType.OR) {
				var childrenExecuted:Boolean = tryExecutingChildren();
				if (childrenExecuted) {
					return;
				}				
			}
			fail();
		}
		
		
		protected function onChildActionFailed(event:ActionEvent):void {
			//removeActionListeners(action);
			
			if (this.logicType==LogicType.OR && !allChildrenFailed()) {
				executeChildren();//should continue if OR and there exist children to be executed
				return;
			}
			if (this.status==ActionStatus.COMPLETING)
				this.fail();
			else
				this.setFailed();
		}
		
		protected function allChildrenFailed():Boolean {
			for each (var action:AbstractAction in this.getAccessibleChildren()) {
				if (!(action.status==ActionStatus.FAILED))
					return false;
			}
			return true;
		}
		
		public function forceComplete():void {
			setCompleted();
		}
		
		public function forceFailed():void {
			setFailed();
		}
		
		internal function setCompleting():void {
			this.status = ActionStatus.COMPLETING;
		}
		
		internal function setCompleted():void {
			if (encounteredFailure()) return;
			this.status = ActionStatus.COMPLETED;
		}
		
		internal function setFailed():void {
			this.status = ActionStatus.FAILED;
		}
		
		internal function setFailing():void {
			this.status = ActionStatus.FAILING;
		}
		
		public function fail():void {
			if (this.status==ActionStatus.FAILING || this.status==ActionStatus.FAILED) return;
			
			setFailing();
			
			if (this.hasChildren()) {
				for each (var action:AbstractAction in this.getAccessibleChildren()) {
					if ((action.status==ActionStatus.COMPLETING) || (action.status==ActionStatus.COMPLETED)) {
						action.fail();
					}
				}
			}
			else {
				this.doExecuteFail();
			}
		}
		
		public function getDescendantActionsWithStatus(status:String, type:Class=null):Array {
			var res:Array = new Array();
			var it:AbstractTreeIterator = new BreadthFirstTreeIterator(this);
			//skip root (itself)
			it.next();
			
			while (it.hasNext()) {
				var action:AbstractAction = AbstractAction(it.peek());
				if (action.status==status && (type==null || action is type)) {
					res.push(action);
					it.skip();//do not add branch for traversal
				}
				else it.next();
			}
			return res;
		}
		
		public function getChildActionsWithStatus(status:String):Array {
			var res:Array = new Array();
			for each (var action:AbstractAction in this.children) {
				if (action.status==status) 
					res.push(action);
			}
			return res;
		}
		
		public override function toString():String {
			return StringUtil.substitute("{0}, {1}", actionData.toString(), this.status);
		}
		
		public function copy():Object {
			var actionPrototype:Class = ci.getClass(this);
			var child:AbstractAction = new actionPrototype();
			child.actionData = ActionData(this.actionData.clone());
			child.doExecuteFunction = this.doExecuteFunction; //copy doExecuteFunction
						
			//status is always not started
			child.status = ActionStatus.NOT_STARTED;
			
			//copy children
			if (this.hasChildren()) {
				child.children = new ArrayCollection();
				for each (var actionChild:AbstractAction in this.children) { //should I use this.getAccessibleChildren() instead?
					child.addChild(actionChild.copy());
				}
			}
			
			return child;
		}
		
		private static const GET_BY_TYPE:String = "getByType";
		private static const GET_BY_NAME:String = "getByName";
		
		/**
		 * available actions are those with status NOT_STARTED and whose
		 * ascendants have status NOT_STARTED, COMPLETING or COMPLETED. 
		 * available actions do not contain descendants of available actions.
		 * available actions are determined by using breadth-first search
		 **/
		public function getAvailableActions(type:Class=null):Array {
			return _getAvailableActions(GET_BY_TYPE, type);
		}
		
		public function getAvailableActionsByName(name:String):Array {
			return _getAvailableActions(GET_BY_NAME, name);
		}
		
		private function _getAvailableActions(type:String, value:Object):Array {
			var res:Array = new Array();
			var it:AbstractTreeIterator = new BreadthFirstTreeIterator(this);
			//skip root (itself)
			it.next();
			
			while (it.hasNext()) {
				var action:AbstractAction = AbstractAction(it.peek());
				
				var handled:Boolean = action.handleActionAvailability(it, res);
				if (handled)
					continue;
					
				if /* (action.status!=ActionStatus.NOT_STARTED &&
					action.status!=ActionStatus.COMPLETING &&  
					action.status!=ActionStatus.COMPLETED) */ 
					(action.status==ActionStatus.FAILING || action.status==ActionStatus.FAILED) {
					it.skip();
					continue;
				}
				if (action.status==ActionStatus.NOT_STARTED && (
					(type==GET_BY_TYPE && (value==null || action is Class(value)))
					|| (type==GET_BY_NAME && action.name==value)
					)) {
					res.push(action);
					it.skip();//do not add branch for traversal
					continue;
				}
				it.next();
			}
			return res;
		}
		
		protected function handleActionAvailability(it:AbstractTreeIterator, res:Array):Boolean {
			return false;
		}
	}
}