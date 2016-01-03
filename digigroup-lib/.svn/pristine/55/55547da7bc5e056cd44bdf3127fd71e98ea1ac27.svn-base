package mindmaps.elements.task.queries {

	import collections.TreeCollectionEx;

	import factories.ControlObjectsTreeFactory;
	import factories.TreeFactory;

	import mindmaps.importexport.TreeAsserter;

	import mindmaps2.elements.task.queries.TaskPerformanceMetric;
	import mindmaps2.elements.task.queries.TaskTimeAndPriorityTimeRatioCalculator;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.number.closeTo;
	import org.hamcrest.object.equalTo;

	import vos.Task;

	public class TaskTimeAndPriorityTimeRatioCalculatorTest {

		private static const calculator:TaskTimeAndPriorityTimeRatioCalculator = new TaskTimeAndPriorityTimeRatioCalculator();

		private static const testTreeFactory:ControlObjectsTreeFactory = new ControlObjectsTreeFactory();

		private static const poTreeFactory:TreeFactory = new TreeFactory();

		private static const treeAsserter:TreeAsserter = new TreeAsserter();

		private static const epsilon:Number = 1 / Math.pow(10, calculator.decimalDigitPrecision);

		[Test]
		public function calculate_1Node_noEstimatedTime():void {
			var taskTree:TreeCollectionEx = poTreeFactory.create1NodeCollection();

			var actualTree:TreeCollectionEx = calculator.calculate(taskTree);

			assertThat(actualTree.vo.time, equalTo(calculator.defaultTime));
			assertThat(actualTree.vo.ptRatio, closeTo(actualTree.vo.priority / actualTree.vo.time, epsilon));
		}

		[Test]
		public function calculate_1Parent1Child_noEstimatedTime():void {
			var taskTree:TreeCollectionEx = poTreeFactory.createParentChildCollection();

			var actualTree:TreeCollectionEx = calculator.calculate(taskTree);

			assertThat(actualTree.vo.time, equalTo(calculator.defaultTime));
			assertThat(actualTree.vo.ptRatio, closeTo(actualTree.vo.priority / actualTree.vo.time, epsilon));
		}

		[Test]
		public function calculate_1Parent1Child_estimatedTime():void {
			var taskTree:TreeCollectionEx = poTreeFactory.createParentChildCollection();
			taskTree.vo.estimatedHours = 0.5;

			var actualTree:TreeCollectionEx = calculator.calculate(taskTree);

			assertThat(actualTree.vo.time, equalTo(0.5));
			assertThat(actualTree.vo.ptRatio, closeTo(actualTree.vo.priority / 0.5, epsilon));
		}

		[Test]
		public function calculate_1Parent2Children_noEstimatedTime():void {
			var taskTree:TreeCollectionEx = poTreeFactory.createParentNChildren(2, true);

			var actualTree:TreeCollectionEx = calculator.calculate(taskTree);

			assertThat(actualTree.vo.time, equalTo(2 * calculator.defaultTime));
			assertThat(actualTree.vo.ptRatio, closeTo(actualTree.vo.priority / actualTree.vo.time, epsilon));
		}

		[Test]
		public function calculate_leafTasksOnly():void {
			var testCase:Object = testTreeFactory.testCase_2TaskTree();
			var tree:TreeCollectionEx = TreeCollectionEx(testCase.input);
			var expectedTree:TreeCollectionEx = TreeCollectionEx(testCase.output);

			var actualTree:TreeCollectionEx = calculator.calculate(tree);

			//assertTrue(treeAsserter.isSubset(expectedTree, tree).result); //treeAsserter only works on Object and not TreeCollectionEx

			var actualTaskGroup:Task = Task(actualTree.vo);
			assertThat(actualTaskGroup.time, equalTo(3));
			assertThat(actualTaskGroup.ptRatio, equalTo(1));
			var actualTask1Node:TreeCollectionEx = TreeCollectionEx(actualTree.children.getItemAt(0));
			var actualTask1:Task = Task(actualTask1Node.vo);
			var expectedTask1Node:TreeCollectionEx = TreeCollectionEx(expectedTree.children.getItemAt(0));
			var expectedTask1:Task = Task(expectedTask1Node.vo);
			assertThat(actualTask1.name, equalTo(expectedTask1.name));
			assertThat(actualTask1.time, equalTo(expectedTask1.time));
			assertPtRatioMatch(actualTask1Node, expectedTask1Node);
		}

		private function assertPtRatioMatch(actual:TreeCollectionEx, expected:TreeCollectionEx):void {
			assertThat(actual.vo.ptRatio, closeTo(expected.vo.ptRatio, epsilon));
		}
	}
}
