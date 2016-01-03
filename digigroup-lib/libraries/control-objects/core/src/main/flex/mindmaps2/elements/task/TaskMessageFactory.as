package mindmaps2.elements.task {
	import collections.TreeCollectionEx;

	import mf.framework.Message;

	public class TaskMessageFactory {

		public function TaskMessageFactory(sender:Object) {
			this.sender = sender;
		}

		private var sender:Object;

		public function RemoveDone(node:TreeCollectionEx):Message {
			return new Message(TaskMessages.REMOVE_DONE, sender, { node: node });
		}

		public function RemovedDone(removedTasks:uint):Message {
			return new Message(TaskMessages.REMOVED_DONE, sender, { removedTasks: removedTasks });
		}

		public function ExportDone(node:TreeCollectionEx):Message {
			return new Message(TaskMessages.EXPORT_DONE, sender, { node: node });
		}

		public function ExportedDone():Message {
			return new Message(TaskMessages.EXPORTED_DONE, sender);
		}

		public function FilterDone(node:TreeCollectionEx):Message {
			return new Message(TaskMessages.FILTER_DONE, sender, { node: node });
		}

		public function FilteredDone(node:TreeCollectionEx):Message {
			return new Message(TaskMessages.FILTERED_DONE, sender, { node: node });
		}
	}
}
