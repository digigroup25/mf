package mindmaps2.actions
{
	import actions.AbstractAction;
	
	import collections.IIterator;
	
	import flash.utils.Dictionary;
	
	public class ActionReplacer
	{
		private var replacementMap:Dictionary;
		
		public function ActionReplacer(replacementMap:Dictionary=null)
		{
			this.replacementMap = replacementMap;
			if (this.replacementMap==null) {
				this.replacementMap = new Dictionary(true);
			}
		}
		
		public function replace(rootAction:AbstractAction):void {
			var actionIterator:IIterator = rootAction.createIterator();
			while (actionIterator.hasNext()) {
				var curAction:AbstractAction = AbstractAction(actionIterator.next());
				for (var key:Object in replacementMap) {
					var targetClass:Class = Class(key);
					if (curAction is targetClass) {
						var replaceWithClass:Class = Class(replacementMap[key]);
						var curActionParent:AbstractAction = AbstractAction(curAction.findParent(rootAction));
						var curActionIndex:int = curActionParent.getChildIndex(curAction);
						var replacementAction:AbstractAction = new replaceWithClass();
						curActionParent.setChildAt(replacementAction, curActionIndex);
					}
				}
			}
		}
		
		public function add(replaceWhat:Class, replaceWith:Class):void {
			this.replacementMap[replaceWhat] = replaceWith;
		}
	}
}