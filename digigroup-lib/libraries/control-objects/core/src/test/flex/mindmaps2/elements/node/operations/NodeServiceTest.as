package mindmaps2.elements.node.operations {
	import collections.TreeCollectionEx;

	import mindmaps2.elements.node.operations.NodeService;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;

	public class NodeServiceTest {
		private var service:NodeService;

		private var parent:TreeCollectionEx;

		private var child1:TreeCollectionEx;

		private var child2:TreeCollectionEx;

		private var child3:TreeCollectionEx;

		[Before]
		public function setup():void {
			service = new NodeService();
			parent = new TreeCollectionEx();
			child1 = new TreeCollectionEx();
			child2 = new TreeCollectionEx();
			child3 = new TreeCollectionEx();
		}

		[After]
		public function tearDown():void {
			service = null;
		}

		[Test]
		public function addChild():void {
			parent.addChild(child1);
			assertThat(parent.numChildren == 1);

			service.addChild(parent, child2);
			assertThat(parent.numChildren == 2);
			assertThat(parent.getChildAt(0) == child2);
		}

		[Test]
		public function addSibling():void {
			parent.addChild(child1);
			parent.addChild(child2);

			service.addSibling(parent, child1, child3);

			assertThat(parent.numChildren == 3);
			assertThat(parent.getChildAt(1) == child3);
		}

		[Test]
		public function removeChild():void {
			parent.addChild(child1);
			parent.addChild(child2);

			service.removeChild(parent, child2);

			assertThat(parent.numChildren == 1);
			assertThat(not(parent.hasChild(child2)));
		}

		[Test]
		public function removeNonExistingChild():void {
			service.removeChild(parent, child1);

			assertThat(parent.numChildren == 0);
		}
	}
}
