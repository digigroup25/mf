package mindmaps2.elements.task {
	import collections.TreeCollectionEx;
	import collections.tree.TreeCollectionExCloner;

	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;

	import mindmaps.map.MapModel2;
	import mindmaps.map.ui.actions.messages.MapMessageFactory;
	import mindmaps.map.ui.actions.messages.MapMessages;

	import mindmaps2.elements.task.operations.TaskService;
	import mindmaps2.elements.task.queries.IQuery;
	import mindmaps2.elements.task.queries.QueryFactory;

	import mx.collections.ArrayCollection;

	public class TaskController extends AbstractController {
		private static const taskService:TaskService = new TaskService();

		private static const treeCloner:TreeCollectionExCloner = new TreeCollectionExCloner();

		public function TaskController(model:IModelProvider = null, mb:IMessageBroker = null) {
			super(model, mb);
			taskMessages = new TaskMessageFactory(this);
		}

		private var taskMessages:TaskMessageFactory;

		private const queries:QueryFactory = new QueryFactory();

		override public function receive(m:Message):void {
			switch (m.name) {
				case TaskMessages.PRIORITIZE:
					onPrioritize(m);
					break;
				case TaskMessages.REMOVE_DONE:
					onRemoveDone(m);
					break;
				case TaskMessages.FILTER_DONE:
					onFilterDone(m);
					break;
			}
		}

		protected function get mapModel():MapModel2 {
			return MapModel2(model);
		}

		private function onPrioritize(m:Message):void {
			//trace(this, "onPrioritize");
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			var fieldName:String = m.body.fieldName as String;
			var query:IQuery = queries.prioritizeTasksAsTree(node, fieldName);
			var result:ArrayCollection = query.execute();
			this.send(new Message(TaskMessages.PRIORITIZED, this, { data: result[0], node: node,
					originalMessage: m, window: m.body.window, fieldName: fieldName })); //need window because window controller needs to know which window the data is attached to
		}

		private function onRemoveDone(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			var removedTasks:uint = taskService.removeDone(node);
			this.send(taskMessages.RemovedDone(removedTasks));
		}

		private function onFilterDone(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			var clonedNodeStructure:TreeCollectionEx = treeCloner.cloneStructure(node);
			taskService.keepDoneTasksOnly(clonedNodeStructure);
			this.send(taskMessages.FilteredDone(clonedNodeStructure));
		}
	}
}
