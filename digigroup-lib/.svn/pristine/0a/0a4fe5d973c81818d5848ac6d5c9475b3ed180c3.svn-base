package mindmaps2.elements.task.queries {

	public class TaskGroupPerformanceMetric {

		public function TaskGroupPerformanceMetric() {
		}

		private var nameMetricList:Array = [];

		public function addPerformanceMetric(name:String, metric:TaskPerformanceMetric):void {
			var index:int = indexOfKey(name);
			var element:Object = { name: name, metric: metric };
			if (index != -1)
				nameMetricList[index] = element;
			else
				nameMetricList.push(element);
		}

		public function removePerformanceMetric(name:String):void {
			var indexToRemove:int = indexOfKey(name);
			if (indexToRemove == -1)
				return;
			nameMetricList.splice(indexToRemove, 1);
		}

		public function toArray():Array {
			return nameMetricList.slice();
		}

		private function indexOfKey(key:String):int {
			for (var i:int = 0; i < nameMetricList.length; i++) {
				var element:Object = nameMetricList[i];
				if (element.name == key)
					return i;
			}
			return -1;
		}
	}
}
