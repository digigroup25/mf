package mindmaps.elements.task.operations {
	import collections.TreeCollectionEx;

	import factories.TreeFactory;

	import flexunit.framework.TestCase;

	import mindmaps2.elements.task.operations.TaskService;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.*;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;

	import vos.Task;

	public class TaskServiceTest {
		private static const trees:TreeFactory = new TreeFactory();

		private const taskService:TaskService = new TaskService();

		[Test]
		public function test_removeNonTaskLeafs_():void {
			var t:TreeCollectionEx = trees.createSimpleCollection();
			taskService.removeNonTaskLeafs(t);
			assertEquals(1, t.children[0].numChildren);
			assertTrue(t.children[0].vo is Task);
		}

		[Test]
		public function removeDoneTasks():void {
			var t:TreeCollectionEx = trees.createParentChildCollection();
			var child:TreeCollectionEx = TreeCollectionEx(t.children.getItemAt(0));
			child.vo.done = 1;

			var result:uint = taskService.removeDone(t);

			assertThat(result, equalTo(1));
		}

		[Test]
		public function keepDoneTasks_2ndChildTaskDone():void {
			var t:TreeCollectionEx = trees.createParentChildCollection();
			var child2:TreeCollectionEx = new TreeCollectionEx(new Task().setName("doneTask").setDone(1));
			t.addChild(child2);

			taskService.keepDoneTasksOnly(t);
			assertThat(t.numChildren, equalTo(1));
			assertThat(t.children.getItemAt(0).vo.name, equalTo("doneTask"));
			assertThat(t.children.getItemAt(0).vo.done, equalTo(1));
		}

		[Test]
		public function keepDoneTasks_2ChildTasksNoneDone():void {
			var t:TreeCollectionEx = trees.createParentChildCollection();

			taskService.keepDoneTasksOnly(t);
			assertThat(t.numChildren, equalTo(0));
		}

		[Test]
		public function keepDoneTasks_grandChildTaskDone():void {
			var t:TreeCollectionEx = trees.createParentChildCollection();
			var grandChildTask:TreeCollectionEx = new TreeCollectionEx(new Task().setName("grandChildTask").setDone(1));
			t.getChildAt(0).addChild(grandChildTask);

			taskService.keepDoneTasksOnly(t);

			assertThat(t.numChildren, equalTo(1));
			assertThat(t.getChildAt(0).getChildAt(0), equalTo(grandChildTask));
		}
	}
}
