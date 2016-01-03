package mindmaps2.elements.task.queries {
	import assertions.Require;

	import collections.IIterator;
	import collections.TreeCollectionEx;
	import collections.tree.TreeLeafIterator;

	import mx.collections.ArrayCollection;

	import vos.Task;

	public class TaskPerformanceMetricCalculator {
		public function TaskPerformanceMetricCalculator() {
		}

		public function calculatePerformanceMetric(taskNodes:Array):TaskPerformanceMetric {
			var result:TaskPerformanceMetric = new TaskPerformanceMetric();

			for each (var taskNode:TreeCollectionEx in taskNodes) {
				var task:Task = Task(taskNode.vo);

				calculateExpectedPoints(task, result);
				calculateActualPoints(task, result);
				calculateExpectedHours(task, result);
				calculateActualHours(task, result);

			}
			return result;
		}

		private function calculateExpectedHours(task:Task, metric:TaskPerformanceMetric):void {
			if (task.committed) {
				metric.expectedCommittedHours += isNaN(task.estimatedHours) ? 0 : task.estimatedHours;
			} else { //task is not committed
				metric.expectedUncommittedHours += isNaN(task.estimatedHours) ? 0 : task.estimatedHours;
			}
		}

		private function calculateActualHours(task:Task, metric:TaskPerformanceMetric):void {
			if (task.committed)
				metric.actualCommittedHours += isNaN(task.actualHours) ? 0 : task.actualHours;
			else
				metric.actualUncommittedHours += isNaN(task.actualHours) ? 0 : task.actualHours;
		}

		private function calculateExpectedPoints(task:Task, metric:TaskPerformanceMetric):void {

			if (task.committed)
				metric.expectedCommittedPoints++;
			else
				metric.expectedUncommittedPoints++;
		}

		private function calculateActualPoints(task:Task, metric:TaskPerformanceMetric):void {
			if (task.done == 1) {
				if (task.committed)
					metric.actualCommittedPoints++;
				else
					metric.actualUncommittedPoints++;
			}
		}
	}
}
