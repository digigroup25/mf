package collections.tree
{
	import classes.TreeFactory;
	import collections.TreeCollectionEx;
	
	import flexunit.framework.TestCase;

import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertStrictlyEquals;


	public class TreeCollectionExClonerTest
	{
		private const cloner:TreeCollectionExCloner = new TreeCollectionExCloner();
		private const trees:TreeFactory = new TreeFactory();
		private const col:TreeCollectionEx = trees.createParentChildCollection();

		[Test]
		public function test_clone_1Node():void
  		{
  			var res:TreeCollectionEx = cloner.clone(col, false);
  			
  			assertFalse(col === res);
  			assertFalse(col.vo === res.vo);
  			assertNull(res.children);
  		}

		[Test]
  		public function test_clone_children():void
  		{
  			var res:TreeCollectionEx = cloner.clone(col);
  			
  			assertFalse(col==res);
  			assertFalse(col.vo == res.vo);
  			assertFalse(col.children[0] == res.children[0]);
  			assertFalse(col.children[0].vo == res.children[0].vo);
  		}

		[Test]
		public function test_cloneStructure():void {
			var res:TreeCollectionEx = cloner.cloneStructure(col);
			
			assertFalse(res===col);
			assertStrictlyEquals(col.vo, res.vo);
			var resChild:TreeCollectionEx = TreeCollectionEx(res.children[0]);
			var colChild:TreeCollectionEx = TreeCollectionEx(col.children[0]);
			assertFalse(colChild === resChild);
			assertStrictlyEquals(colChild.vo, resChild.vo);
		}
	}
}