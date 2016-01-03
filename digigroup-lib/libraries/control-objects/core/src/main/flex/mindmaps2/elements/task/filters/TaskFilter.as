package mindmaps2.elements.task.filters {
	import collections.*;
	import collections.tree.*;

	import mx.collections.ArrayCollection;

	import vos.Task;

	public class TaskFilter {
		public function TaskFilter(it:ITreeIterator, filterContext:TaskFilterContext) {
			this.it = it;
			this.filterContext = filterContext;
		}

		private var it:ITreeIterator;

		private var filterContext:TaskFilterContext;

		public function filter():ArrayCollection {
			var res:ArrayCollection = new ArrayCollection();
			if (!it.hasNext())
				return res;
			if (!filterContext.includeRoot) {
				//skip first
				it.next();
			}

			while (it.hasNext()) {
				var cur:* = it.peek();
				if (match(cur)) {
					res.addItem(cur);
					it.next();
				} else if (cur.hasChildren())
					it.next();
				else
					it.skip();
			}
			return res;
		}

		public function match(item:TreeCollectionEx):Boolean {
			var res:Boolean;
			if (!(item.vo is Task))
				return false;
			var matchLeaf:Boolean = (item.isLeaf() == filterContext.showLeafs);
			var matchNonLeaf:Boolean = (!item.isLeaf() == filterContext.showNonLeafs);
			var matchDone:Boolean = ((item.vo.done == 1) == filterContext.showDone);
			return ((matchLeaf || matchNonLeaf) && matchDone);
		}
	}
}
