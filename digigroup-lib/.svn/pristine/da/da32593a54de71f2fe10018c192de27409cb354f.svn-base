package collections.tree
{
	import classes.TreeFactory;

	import collections.*;

	import org.flexunit.asserts.assertEquals;


	public class BreadthFirstTreeIteratorTest
	{
		public function BreadthFirstTreeIteratorTest()
		{
		}


		//              0(0)
		//     1A(1)        1B(2)
		//2A(2)  2B(3)      2C(1)
		[Test]
		public function test_prioirtyTaskTree2():void
		{
			var t:TreeCollectionEx = new TreeFactory().createPriorityTaskTree2();
			var it:IIterator = new BreadthFirstTreeIterator(t);
			var node:TreeCollectionEx = TreeCollectionEx(it.next());
			assertEquals("0", node.vo.name);
			node = TreeCollectionEx(it.next());
			assertEquals("1A", node.vo.name);
			node = TreeCollectionEx(it.next());
			assertEquals("1B", node.vo.name);
			node = TreeCollectionEx(it.next());
			assertEquals("2A", node.vo.name);
			node = TreeCollectionEx(it.next());
			assertEquals("2B", node.vo.name);
			node = TreeCollectionEx(it.next());
			assertEquals("2C", node.vo.name);
		}
	}
}
