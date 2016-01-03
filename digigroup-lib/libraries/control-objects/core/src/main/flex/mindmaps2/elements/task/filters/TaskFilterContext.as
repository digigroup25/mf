package mindmaps2.elements.task.filters {
	import collections.*;

	public class TaskFilterContext {

		public function TaskFilterContext(showLeafs:Boolean = true, showDone:Boolean = false,
			showNonLeafs:Boolean = false, includeRoot:Boolean = false) {
			_showLeafs = showLeafs;
			_showDone = showDone;
			_showNonLeafs = showNonLeafs;
			_includeRoot = includeRoot;
		}

		private var _showLeafs:Boolean = true;

		private var _showNonLeafs:Boolean = false;

		private var _showDone:Boolean = false;

		private var _includeRoot:Boolean = false;

		public function get showLeafs():Boolean {
			return _showLeafs;
		}

		public function get showNonLeafs():Boolean {
			return _showNonLeafs;
		}

		public function get showDone():Boolean {
			return _showDone;
		}

		public function get includeRoot():Boolean {
			return _includeRoot;
		}
	}
}
