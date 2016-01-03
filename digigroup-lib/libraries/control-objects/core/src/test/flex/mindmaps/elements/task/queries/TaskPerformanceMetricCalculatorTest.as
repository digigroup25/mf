package mindmaps.elements.task.queries {
	import collections.TreeCollectionEx;
	import collections.tree.TreeIterator;

	import factories.TreeFactory;

	import mindmaps2.elements.task.filters.TaskFilter;
	import mindmaps2.elements.task.filters.TaskFilterContext;
	import mindmaps2.elements.task.queries.TaskPerformanceMetric;
	import mindmaps2.elements.task.queries.TaskPerformanceMetricCalculator;

	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	import vos.Task;

	public class TaskPerformanceMetricCalculatorTest {

		private static const calculator:TaskPerformanceMetricCalculator = new TaskPerformanceMetricCalculator();

		private static const leafTaskFilterContext:TaskFilterContext = new TaskFilterContext(true, false, false, true);

		public function TaskPerformanceMetricCalculatorTest() {
		}

		private var taskFilter:TaskFilter;

		[Test]
		public function calculatePerformanceMetric_leafTasksOnly_expectedAndActualHours():void {
			var tree:TreeCollectionEx = create2TaskTree();

			taskFilter = new TaskFilter(new TreeIterator(tree), leafTaskFilterContext);
			var treeNodes:Array = taskFilter.filter().source;

			var result:TaskPerformanceMetric = calculator.calculatePerformanceMetric(treeNodes);

			assertThat(result.expectedCommittedHours, equalTo(3));
			assertThat(result.actualHours, equalTo(6));
		}

		[Test]
		public function calculatePerformanceMetric_tasksAndTaskGroups_expectedAndActualHours():void {
			var tree:TreeCollectionEx = create2TaskTree();

			var tasksAndTaskGroupsFilterContext:TaskFilterContext = new TaskFilterContext(true, false, true, true);
			taskFilter = new TaskFilter(new TreeIterator(tree), tasksAndTaskGroupsFilterContext);
			var treeNodes:Array = taskFilter.filter().source;

			var result:TaskPerformanceMetric = calculator.calculatePerformanceMetric(treeNodes);

			assertThat(result.expectedCommittedHours, equalTo(3 + 4));
			assertThat(result.actualHours, equalTo(6 + 8));
		}

		[Test]
		public function calculatePerformanceMetric_taskGroupsOnly_expectedAndActualHours():void {
			var tree:TreeCollectionEx = create2TaskTree();

			var taskGroupsFilterContext:TaskFilterContext = new TaskFilterContext(false, false, true, true);
			taskFilter = new TaskFilter(new TreeIterator(tree), taskGroupsFilterContext);
			var treeNodes:Array = taskFilter.filter().source;

			var result:TaskPerformanceMetric = calculator.calculatePerformanceMetric(treeNodes);

			assertThat(result.expectedCommittedHours, equalTo(4));
			assertThat(result.actualHours, equalTo(8));
		}


		private function create2TaskTree():TreeCollectionEx {
			var result:TreeCollectionEx = new TreeCollectionEx();

			var taskGroup:Task = new Task().setName("task group").setEstimatedHours(4).setActualHours(8).setCommitted(true);

			var task1:Task = new Task().setName("task1").setEstimatedHours(1).setActualHours(2).setCommitted(true);
			var task2:Task = new Task().setName("task2").setEstimatedHours(2).setActualHours(4).setCommitted(true);

			result.vo = taskGroup;

			result.addChild(new TreeCollectionEx(task1));
			result.addChild(new TreeCollectionEx(task2));

			return result;
		}
	}
}
