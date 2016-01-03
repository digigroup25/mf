package mindmaps.elements.task.queries {
	import collections.TreeCollectionEx;

	import factories.TreeFactory;

	import flexunit.framework.TestCase;

	import mindmaps2.elements.task.queries.IQuery;
	import mindmaps2.elements.task.queries.QueryFactory;

	import mx.charts.chartClasses.ChartBase;
	import mx.collections.ArrayCollection;

	import org.flexunit.asserts.*;

	import vos.*;

	public class PrioritizeLeafTasksHierarchicallyQueryTest {
		private var query:IQuery;

		private const trees:TreeFactory = new TreeFactory();

		private const queries:QueryFactory = new QueryFactory();

		[Test]
		public function test_execute_ParentChildHPTaskTree():void {
			var t:TreeCollectionEx = trees.createParentChildHPTaskTree();
			query = queries.prioritizeTasksAsList(t);

			var res:ArrayCollection = query.execute();

			assertParentChildHPTaskTree(res);
			ChartBase
		}

		[Test]
		public function test_execute_ParentChildHPTaskTree_taskDone():void {
			var t:TreeCollectionEx = trees.createParentChildHPTaskTree();
			t.children[0].vo.done = 1;

			query = queries.prioritizeTasksAsList(t);

			var res:ArrayCollection = query.execute();

			assertEquals(1, res.length);
			assertEquals("E", res[0].vo.name);
		}

		[Test]
		public function test_execute_ParentChildHPTaskTree_withContact():void {
			var t:TreeCollectionEx = trees.createParentChildHPTaskTree();
			t.addChild(new TreeCollectionEx(new Contact()));

			query = queries.prioritizeTasksAsList(t);
			var res:ArrayCollection = query.execute();

			assertParentChildHPTaskTree(res);
		}

		[Test]
		public function test_execute_TaskTree2():void {
			var t:TreeCollectionEx = trees.createTaskTree2();

			query = queries.prioritizeTasksAsList(t);
			var res:ArrayCollection = query.execute();

			assertTaskTree2(res);
		}

		[Test]
		public function test_execute_AllElements():void {
			var t:TreeCollectionEx = trees.createAllElements();

			query = queries.prioritizeTasksAsList(t);
			var res:ArrayCollection = query.execute();

			assertEquals(1, res.length);
		}

		//takes around 10sec to exec
		public function _test_execute_1000NodeTree():void {
			var t:TreeCollectionEx = trees.createRandomVoTree(1000, [ Item, Note, Task, Contact, Appointment ]);

			query = queries.prioritizeTasksAsList(t);
			var res:ArrayCollection = query.execute();
		}

		[Test]
		public function test_execute_preserveOrder():void {
			var t:TreeCollectionEx = create4TaskTree();

			query = queries.prioritizeTasksAsList(t);
			var res:ArrayCollection = query.execute();

			assertEquals(4, res.length);
			assertEquals('2', res[0].vo.name);
			assertEquals('1', res[1].vo.name);
			assertEquals('3', res[2].vo.name);
			assertEquals('4', res[3].vo.name);
		}

		private function assertParentChildHPTaskTree(res:ArrayCollection):void {
			assertEquals(3, res.length);
			assertEquals("E", res[0].vo.name);
			assertEquals(10, res[0].vo.rank);
			assertEquals("D", res[1].vo.name);
			assertEquals(3, res[1].vo.rank);
			assertEquals("C", res[2].vo.name);
			assertEquals(2, res[2].vo.rank);
		}

		private function assertTaskTree2(res:ArrayCollection):void {
			assertEquals(2, res.length);
			assertEquals("E", res[0].vo.name);
			assertEquals(11, res[0].vo.rank);
			assertEquals("D", res[1].vo.name);
			assertEquals(2, res[1].vo.rank);
		}

		private function create4TaskTree():TreeCollectionEx {
			var res:TreeCollectionEx = TreeFactory.createNode(Task);

			var task1:TreeCollectionEx = TreeFactory.createNode(Task);
			task1.vo.name = '1';
			task1.vo.priority = 2;

			var task2:TreeCollectionEx = TreeFactory.createNode(Task);
			task2.vo.name = '2';
			task2.vo.priority = 3;

			var task3:TreeCollectionEx = TreeFactory.createNode(Task);
			task3.vo.name = '3';
			task3.vo.priority = 2;

			var task4:TreeCollectionEx = TreeFactory.createNode(Task);
			task4.vo.name = '4';
			task4.vo.priority = 2;

			res.addChildren([ task1, task2, task3, task4 ]);

			return res;
		}
	}
}
