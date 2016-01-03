package mindmaps2.actions.element {
	import actions.AbstractIOAction;
	import actions.AbstractUserAction;

	import assertions.Require;

	import collections.TreeCollectionEx;

	import mindmaps2.AppSettings;
	import mindmaps2.actions.iteration.IterationStatusAction;
	import mindmaps2.actions.task.*;

	import vos.Iteration;
	import vos.Task;

	public class CreateElementActions extends AbstractIOAction {
		public static const commonElementActions:Array = [ ExpandDescendants, ConvertElement, ImportElement, ExportElement ];

		public static const taskActions:Array = [ PrioritizeByRatingAndTimeAction, PrioritizeByRatingAction, PrioritizeByValueAction, RemoveDoneTasks, ExportDoneTasks, TaskGroupInfoAction ];

		private static const iterationActions:Array = [ IterationStatusAction ];

		public function CreateElementActions(name:String = null) {
			super(name);
			this.preconditions = [ checkPreconditions ];
			this.input.addAlias("model", "node");
		}

		override protected function doExecute():void {
			var node:TreeCollectionEx = TreeCollectionEx(this.input.node);
			Require.notNull(node, "node");
			var element:Object = node.vo;
			Require.notNull(element, "element");

			//pass through all args
			super.copyInputToOutput();

			var commonElementActions:Array = createCommonElementActions(element);
			var specificElementActions:Array = createSpecificElementActions(element);
			var allActions:Array = commonElementActions.concat(specificElementActions);

			this.output.elementActions = allActions;

			super.doExecute();
		}

		private function checkPreconditions():Boolean {
			Require.notNull(this.input.node, "node");

			return true;
		}

		private function createCommonElementActions(element:Object):Array {
			return createActionsFrom(commonElementActions);
		}

		private function createActionsFrom(actions:Array):Array {
			var res:Array = [];
			for each (var actionClass:Class in actions) {
				var action:AbstractUserAction = new actionClass();
				//explicitly set all actions to infinitely repeat
				//action.repeatCount = AppSettings.INFINITE_REPEAT_COUNT;
				res.push(action);
			}
			return res;
		}

		private function createSpecificElementActions(element:Object):Array {
			var res:Array = [];
			if (element is Task) {
				res = res.concat(createActionsFrom(taskActions));
			} else if (element is Iteration) {
				res = res.concat(createActionsFrom(iterationActions));
			}
			return res;
		}
	}
}
