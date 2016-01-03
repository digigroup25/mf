package collections.tree
{
	import classes.*;

	import collections.IIterator;
	import collections.TreeCollectionEx;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;


	public class TreeIteratorTest
	{
		//TODO: provide tests for peek and skip

		[Test]
		public function testTraverseNonExistingClass():void
		{
			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();
			var it:IIterator = col.createIterator(ClassB);
			assertFalse(it.hasNext());
		}


		[Test]
		public function testTraverseAll():void
		{
			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();
			var it:IIterator = col.createIterator();
			var i:int = 0;
			for (; it.hasNext(); i++)
			{
				it.next();
			}
			assertEquals(i, 5);
		}


		[Test]
		public function test_reverseDirection():void
		{
			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();
			var it:IIterator = new TreeIterator(col, true);

			assertTrue(it.hasNext());
			var e:TreeCollectionEx = TreeCollectionEx(it.next());
			assertEquals(col, e);

			assertTrue(it.hasNext());
			var project2:TreeCollectionEx = TreeCollectionEx(it.next());
			assertEquals(col.children[1], project2);

			assertTrue(it.hasNext());
			var project1:TreeCollectionEx = TreeCollectionEx(it.next());
			assertEquals(col.children[0], project1);

			assertTrue(it.hasNext());
			var app1:TreeCollectionEx = TreeCollectionEx(it.next());
			assertEquals(col.children[0].children[1], app1);

			assertTrue(it.hasNext());
			var task1:TreeCollectionEx = TreeCollectionEx(it.next());
			assertEquals(col.children[0].children[0], task1);

			assertFalse(it.hasNext());
		}
	}
}