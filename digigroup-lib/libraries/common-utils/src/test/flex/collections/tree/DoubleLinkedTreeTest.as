package collections.tree
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;


	public class DoubleLinkedTreeTest
	{
		private var parent:DoubleLinkedTree;
		private var child:DoubleLinkedTree;


		public function DoubleLinkedTreeTest()
		{
		}


		[Before]
		public function setUp():void
		{
			parent = new DoubleLinkedTree();
			child = new DoubleLinkedTree();
		}


		[Test]
		public function test_addChild():void
		{
			parent.addChild(child);

			assertTrue(parent.hasChild(child));
			assertEquals(parent, child.parent);
		}


		[Test]
		public function test_addChildTwice():void
		{
			parent.addChild(child);
			parent.addChild(child);

			assertTrue(parent.hasChild(child));
			assertEquals(1, parent.children.length);
		}


		[Test]
		public function test_addNullChild():void
		{
			parent.addChild(null);

			assertFalse(parent.hasChild(null));
			assertFalse(parent.hasChildren());
		}


		[Test]
		public function test_removeChild():void
		{
			parent.addChild(child);
			parent.removeChild(child);

			assertFalse(parent.hasChild(child));
			assertFalse(parent.hasChildren());
		}


		[Test]
		public function test_removeNonExistentChild():void
		{
			var nonExistentChild:DoubleLinkedTree = new DoubleLinkedTree();
			parent.removeChild(nonExistentChild);

			assertFalse(parent.hasChild(nonExistentChild));
		}


		[Test]
		public function test_addChildAtTwice():void
		{
			parent.addChildAt(child, 0);
			parent.addChildAt(child, 0);

			assertTrue(parent.hasChild(child));
			assertEquals(1, parent.children.length);
		}
	}
}