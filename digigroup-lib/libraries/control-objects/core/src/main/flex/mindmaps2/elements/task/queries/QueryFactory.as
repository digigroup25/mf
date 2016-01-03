package mindmaps2.elements.task.queries {
	import collections.TreeCollectionEx;

	public class QueryFactory {
		public function prioritizeTasksAsList(root:TreeCollectionEx):IQuery {
			return new PrioritizeLeafTasksHierarchicallyQuery4(root);
		}

		public function prioritizeTasksAsTree(root:TreeCollectionEx, fieldName:String):IQuery {
			if (fieldName == "ptRatio") {
				return new PrioritizeTasksHierarchicallyByPriorityAndTimeQuery(root);
			}

			return new PrioritizeTasksHierarchicallyQuery(root, fieldName);
		}

		public function rankTasksAsTree(root:TreeCollectionEx):IQuery {
			return new RankTasksQuery(root);
		}
	}
}
