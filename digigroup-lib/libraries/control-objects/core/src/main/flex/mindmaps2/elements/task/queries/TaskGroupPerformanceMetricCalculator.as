package mindmaps2.elements.task.queries {
	import assertions.Require;

	import collections.IIterator;
	import collections.TreeCollectionEx;
	import collections.tree.TreeLeafIterator;

	import mindmaps.importexport.WordTokenizer;

	import vos.Task;

	public class TaskGroupPerformanceMetricCalculator {

		private static const wordTokenizer:WordTokenizer = new WordTokenizer();

		private static const performanceMetricCalculator:TaskPerformanceMetricCalculator = new TaskPerformanceMetricCalculator();

		public function calculateGroupPerformance(node:TreeCollectionEx):TaskGroupPerformanceMetric {
			Require.notNull(node, "node");

			var result:TaskGroupPerformanceMetric = new TaskGroupPerformanceMetric();

			var leafTaskNodes:Array = getLeafTaskNodes(node);

			var nameTasksMap:Object = getMapNameToTasks(leafTaskNodes);

			var namePerformanceMetricMap:Object = getNamePerformanceMetricMap(nameTasksMap);

			populateGroupPerformanceMetric(result, namePerformanceMetricMap);

			populateTotalsForGroupPerformanceMetric(result);

			return result;
		}

		private function populateTotalsForGroupPerformanceMetric(metric:TaskGroupPerformanceMetric):void {
			var totalMetric:TaskPerformanceMetric = new TaskPerformanceMetric();

			for each (var metricObject:Object in metric.toArray()) {
				var taskMetric:TaskPerformanceMetric = TaskPerformanceMetric(metricObject.metric);
				totalMetric.expectedCommittedPoints += taskMetric.expectedCommittedPoints;
				totalMetric.actualCommittedPoints += taskMetric.actualCommittedPoints;

				totalMetric.expectedUncommittedPoints += taskMetric.expectedUncommittedPoints;
				totalMetric.actualUncommittedPoints += taskMetric.actualUncommittedPoints;

				totalMetric.expectedCommittedHours += taskMetric.expectedCommittedHours;
				totalMetric.actualCommittedHours += taskMetric.actualCommittedHours;

				totalMetric.expectedUncommittedHours += taskMetric.expectedUncommittedHours;
				totalMetric.actualUncommittedHours += taskMetric.actualUncommittedHours;
			}

			metric.addPerformanceMetric("Total", totalMetric);
		}

		private function populateGroupPerformanceMetric(metric:TaskGroupPerformanceMetric, map:Object):void {
			for (var name:String in map) {
				metric.addPerformanceMetric(name, map[name]);
			}
		}

		private function getMapNameToTasks(tasks:Array):Object {
			var result:Object = {};

			for each (var taskNode:TreeCollectionEx in tasks) {
				var task:Task = Task(taskNode.vo);
				var names:Array = wordTokenizer.getWords(task.assignedTo);
				if (names.length == 0) {
					names = [ "Unassigned" ];
				}
				for each (var name:String in names) {
					if (result[name] == undefined)
						result[name] = [];
					result[name].push(taskNode);
				}
			}

			return result;
		}

		private function getNamePerformanceMetricMap(nameTasksMap:Object):Object {
			var result:Object = {};

			for (var name:String in nameTasksMap) {
				result[name] = performanceMetricCalculator.calculatePerformanceMetric(nameTasksMap[name]);
			}

			return result;
		}

		private function getLeafTaskNodes(node:TreeCollectionEx):Array {
			var it:IIterator = new TreeLeafIterator(node);
			var leafTaskNodes:Array = [];
			while (it.hasNext()) {
				var leafNode:TreeCollectionEx = TreeCollectionEx(it.next());
				if (leafNode.vo is Task) {
					leafTaskNodes.push(leafNode);
				}
			}
			return leafTaskNodes;
		}
	}
}
