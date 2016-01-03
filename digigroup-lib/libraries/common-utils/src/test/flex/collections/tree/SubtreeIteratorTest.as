package collections.tree
{

import classes.TreeFactory;

import collections.*;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;


public class SubtreeIteratorTest
	{
		[Test]
		public function test_iterator():void
		{
			var tree:TreeCollectionEx = new TreeFactory().createParentNChildren(2);
			var it:IIterator = new SubtreeIterator(tree);
			
			assertEquals(tree.children[0], it.next());
			assertEquals(tree.children[1], it.next());
		}

		[Test]
		public function test_nosubtree():void
		{
			var tree:TreeCollectionEx = new TreeFactory().create1Node();
			var it:IIterator = new SubtreeIterator(tree);
			
			assertFalse(it.hasNext());
		}
	}
}