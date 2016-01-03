package mindmaps.elements.task.queries {
	import collections.TreeCollectionEx;
	import collections.tree.*;

	import factories.ControlObjectsTreeFactory;

	import mindmaps2.elements.task.queries.PrioritizeTasksHierarchicallyByPriorityAndTimeQuery;

	import mx.collections.ArrayCollection;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.*;
	import org.hamcrest.number.closeTo;
	import org.hamcrest.object.equalTo;

	public class PrioritizeTasksHierarchicallyByPriorityAndTimeQueryTest {

		private static const treeFactory:ControlObjectsTreeFactory = new ControlObjectsTreeFactory();

		[Test]
		public function calculate_2TaskTree():void {
			var testCase:Object = treeFactory.testCase_2TaskTree();
			var tree:TreeCollectionEx = TreeCollectionEx(testCase.input);
			var expectedTask1Node:TreeCollectionEx = TreeCollectionEx(testCase.outputSortedByPtRatio);

			var query:PrioritizeTasksHierarchicallyByPriorityAndTimeQuery = new PrioritizeTasksHierarchicallyByPriorityAndTimeQuery(tree);
			var result:ArrayCollection = query.execute();

			assertThat(result.length, equalTo(1));
			var actualTask1Node:TreeCollectionEx = TreeCollectionEx(result.getItemAt(0));

			assertThat(actualTask1Node.vo.ptRatio, equalTo(expectedTask1Node.vo.ptRatio));
			assertThat(actualTask1Node.children.length, equalTo(expectedTask1Node.children.length));

			var actual1ChildNode:TreeCollectionEx = TreeCollectionEx(actualTask1Node.getChildAt(0));
			var expected1ChildNode:TreeCollectionEx = TreeCollectionEx(expectedTask1Node.getChildAt(0));
			assertTaskNamePtRatioMatch(actual1ChildNode, expected1ChildNode);
		}

		[Test]
		public function calculate_6TaskNodeTree():void {
			var testCase:Object = treeFactory.testCase_6TaskNodeTree();
			var tree:TreeCollectionEx = TreeCollectionEx(testCase.input);
			var expectedTree:TreeCollectionEx = TreeCollectionEx(testCase.outputSortedByPtRatio);
			var expectedTask1Node:TreeCollectionEx = expectedTree;

			var query:PrioritizeTasksHierarchicallyByPriorityAndTimeQuery = new PrioritizeTasksHierarchicallyByPriorityAndTimeQuery(tree);
			var result:ArrayCollection = query.execute();

			assertThat(result.length, equalTo(1));
			var actualTask1Node:TreeCollectionEx = TreeCollectionEx(result.getItemAt(0));
			assertTaskNamePtRatioMatch(actualTask1Node, expectedTask1Node);

			var actualTask2Node:TreeCollectionEx = TreeCollectionEx(actualTask1Node.getChildAt(0));
			var expectedTask2Node:TreeCollectionEx = TreeCollectionEx(expectedTask1Node.getChildAt(0));
			assertTaskNamePtRatioMatch(actualTask2Node, expectedTask2Node);

			var actualTask3Node:TreeCollectionEx = TreeCollectionEx(actualTask1Node.getChildAt(1));
			var expectedTask3Node:TreeCollectionEx = TreeCollectionEx(expectedTask1Node.getChildAt(1));
			assertTaskNamePtRatioMatch(actualTask3Node, expectedTask3Node);

			var actualTask4Node:TreeCollectionEx = TreeCollectionEx(actualTask3Node.getChildAt(0));
			var expectedTask4Node:TreeCollectionEx = TreeCollectionEx(expectedTask3Node.getChildAt(0));
			assertTaskNamePtRatioMatch(actualTask4Node, expectedTask4Node);
		}

		private function assertTaskNamesMatch(actual:TreeCollectionEx, expected:TreeCollectionEx):void {
			assertThat(actual.vo.name, equalTo(expected.vo.name));
		}

		private function assertPtRatioMatch(actual:TreeCollectionEx, expected:TreeCollectionEx):void {
			assertThat(actual.vo.ptRatio, closeTo(expected.vo.ptRatio, 0.001));
		}

		private function assertTaskNamePtRatioMatch(actual:TreeCollectionEx, expected:TreeCollectionEx):void {
			assertTaskNamesMatch(actual, expected);
			assertPtRatioMatch(actual, expected);
		}
	}
}
