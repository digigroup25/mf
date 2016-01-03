package actions
{
	import collections.AliasHashMap;
	import collections.IIterator;
	
	public class AbstractIOAction extends AbstractAction
	{
		//input and output should be immutable once set
		private var _input:AliasHashMap = new AliasHashMap();
		public var output:AliasHashMap = new AliasHashMap();
		
		public function get input():AliasHashMap {
			return _input;
		}
		
		public function set input(value:AliasHashMap):void {
			_input = value;
		}
		
		public function AbstractIOAction(name:String=null) {
			super(name);
		}
		
		public function hasInput():Boolean {
			return (input!=null && numOfKeys(input)>0);
		}
		
		private function numOfKeys(map:Object):uint {
			var numOfKeys:uint = 0;
			for (var key:String in this.input) {
				numOfKeys++;
			}
			return numOfKeys;
		}
		
		public function hasOutput():Boolean {
			return (output!=null && numOfKeys(output)>0);
		}
		
		override public function addChild(child:*):void {
			super.addChild(child);
			if (child is AbstractIOAction) {
				AbstractIOAction(child).input.copyFrom(this.input);
			}
		}
		
		override protected function executeBody():void {
			for each (var action:AbstractAction in this.children) {
				setInputOnChild(action);
			}
			super.executeBody();
		}
		
		override protected function executeActions(actions:Array):void {
			var action:AbstractAction;
			//set input on all actions before executing any only if sequential
			//parallel should not get results from sibling actions
			if (this.type == ActionType.SEQUENTIAL) 
			{
				for each (action in actions) {
					setInputOnChild(action);
				}
			}
			
			for each (action in actions) {
				action.execute();
			}
		}
		
		protected function setInputOnChild(action:AbstractAction):void {
			if (action is AbstractIOAction) {
				var ioAction:AbstractIOAction = AbstractIOAction(action);
				var inputForChild:AliasHashMap = getInputWithOutput();
				ioAction.input.copyFrom(inputForChild);
			}
		}
		
		private function getInputWithOutput():AliasHashMap {
			var res:AliasHashMap = AliasHashMap(input.clone());
			
			//shallow copy of output to res
			for (var outputKey:String in output) {
				res[outputKey] = output[outputKey];
			}
			return res;
		}
		
		protected function copyMapContentAndAliases(sourceMap:AliasHashMap, targetMap:AliasHashMap):void {
			for (var key:String in sourceMap) {
				targetMap[key] = sourceMap[key];
			}
			
			var aliases:Array = sourceMap.getAliases();
			for each (var aliasValue:Object in aliases) {
				targetMap.addAlias(aliasValue.alias, aliasValue.propertyName);
			}
		}
		
		protected function copyInputToOutput():void {
			copyMapContentAndAliases(this.input, this.output);
		}
		
		private function copyOutput(source:AbstractIOAction, target:AbstractIOAction):void {
			copyMapContentAndAliases(source.output, target.output);
		}
		
		protected override function onChildActionCompleted(event:ActionEvent):void {
			getOutputFromChild(AbstractAction(event.target));
			super.onChildActionCompleted(event);
		}
		
		private function getOutputFromChild(action:AbstractAction):void {
			if (action is AbstractIOAction) {
				var ioAction:AbstractIOAction = AbstractIOAction(action);
				copyOutputFromChild(ioAction);
			}
		}
		
		private function copyOutputFromChild(childAction:AbstractIOAction):void {
			this.copyMapContentAndAliases(childAction.output, this.output);
		}
		
		public function getInputForKey(key:String):Object {
			return this.input[key];
		}
		
		public function hasInputForKey(key:String):Boolean {
			return this.input[key]!=null;
		}
		
		public override function copy():Object {
			var copiedAction:AbstractIOAction = AbstractIOAction(super.copy());
			copiedAction.input = AliasHashMap(this.input.clone());
			copiedAction.output = AliasHashMap(this.output.clone());
			
			//set input/output recursively on all descendants
			var it:IIterator = copiedAction.createIterator();
			while (it.hasNext()) {
				var a:AbstractAction = AbstractAction(it.next());
				if (a is AbstractIOAction) {
					var descendantAction:AbstractIOAction = AbstractIOAction(a);
					//using shallow copy intead of child.input = this.input
					//in order to prevent inadvertantly modifying parent
					//when modifying child's input or output
					//this.copyOutput(this, ioChild);
					descendantAction.input.copyFrom(copiedAction.input);
					descendantAction.output.copyFrom(copiedAction.input);
				}
			}
			
			
			return copiedAction;
		}
	}
}