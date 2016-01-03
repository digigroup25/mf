package collections.tree
{
	import classes.*;
	
	import collections.TreeCollectionEx;
	
	import flash.events.Event;
	
	import mx.binding.utils.*;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;


	public class TreeCompositeTest
	{
		private var updated:int = 0;
		private var childrenChanged:int = 0;
		private var numChildren:int;

		private const testTrees:TreeFactory = new TreeFactory();
		private const trees:TreeFactory = new TreeFactory();


		[Test]
		public function test_findParent_simpleCollection():void
		{
			var t:TreeComposite = testTrees.createSimpleCollection();
			var res:TreeComposite = t.children[0].findParent(t);
			assertEquals(t, res);

			res = t.children[0].children[1].findParent(t);
			assertEquals(t.children[0], res);
		}


		[Test]
		public function test_remove_simpleCollection():void
		{
			var col:TreeComposite = new TreeFactory().createSimpleCollection();
			var nodeToRemove:TreeComposite = col.children[0];

			col.remove(nodeToRemove, col);

			assertFalse(col.children[0] == nodeToRemove);
			//assertEquals(null, nodeToRemove);
		}


		[Test]
		public function test_size():void
		{
			var t:TreeComposite = new TreeComposite();
			var res:int = t.size;
			assertEquals(1, res);

			t.addChild(new TreeComposite());
			res = t.size;
			assertEquals(2, res);

			t.children[0].addChild(new TreeComposite());
			t.children[0].addChild(new TreeComposite());
			t.addChild(new TreeComposite());
			res = t.size;
			assertEquals(5, res);
		}


		[Test]
		public function test_getNumLeafs():void
		{
			var t:TreeComposite = new TreeFactory().createBinaryFullTree_3Levels();
			var res:int = t.getNumLeafs();
			assertEquals(4, res);

			t = new TreeFactory().createFullTree_3Levels(4, 3);
			res = t.getNumLeafs();
			assertEquals(12, res);

			t = new TreeFactory().createTree1();
			res = t.getNumLeafs();
			assertEquals(3, res);
		}


		/**
		 * insert nodes
		 * add child before
		 *		 - 1 node
		 *		 - 2 nodes
		 * add child after
		 *		 - 1 node
		 *		 - 2 nodes
		 */
		[Test]
		public function test_addChildBefore_1Child():void
		{
			var col:TreeCollectionEx = new TreeFactory().createParentNChildren(1);
			var newNode:TreeCollectionEx = new TreeCollectionEx();

			col.addChildBefore(newNode, col.children[0]);

			assertEquals(2, col.children.length);
			assertEquals(newNode, col.children[0]);
		}


		[Test]
		public function test_addChildAfter_1Child():void
		{
			var col:TreeCollectionEx = new TreeFactory().createParentNChildren(1);
			var newNode:TreeCollectionEx = new TreeCollectionEx();

			col.addChildAfter(newNode, col.children[0]);

			assertEquals(2, col.children.length);
			assertEquals(newNode, col.children[1]);
		}


		[Test]
		public function test_addChildBefore_2Children():void
		{
			var col:TreeCollectionEx = new TreeFactory().createParentNChildren(2);
			var newNode:TreeCollectionEx = new TreeCollectionEx();

			col.addChildBefore(newNode, col.children[1]);

			assertEquals(3, col.children.length);
			assertEquals(newNode, col.children[1]);
		}


		[Test]
		public function test_addChildAfter_2Children():void
		{
			var col:TreeCollectionEx = new TreeFactory().createParentNChildren(2);
			var newNode:TreeCollectionEx = new TreeCollectionEx();

			col.addChildAfter(newNode, col.children[1]);

			assertEquals(3, col.children.length);
			assertEquals(newNode, col.children[2]);
		}


//		[Test]
		public function test_getNumLeafs_hiddenChildren():void
		{
			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();

			col.children[0].childrenExpanded = false;
			var res:int = col.getNumLeafs();
			assertEquals(2, res);
		}


//		[Test]
		public function test_bindingNumChildren():void
		{
			updated = 0;
			var col:TreeCollectionEx = new TreeCollectionEx();
			col.children = new ArrayCollection();
			//BindingUtils.bindSetter(updateNumChildren, col, "children");
			col.children.addEventListener(CollectionEvent.COLLECTION_CHANGE, updateNumChildren);
			var child:TreeCollectionEx = new TreeCollectionEx();

			col.addChild(child);
			assertEquals(1, updated);
			col.removeChild(child);
			assertEquals(2, updated);

			col.children.removeEventListener(CollectionEvent.COLLECTION_CHANGE, updateNumChildren);
		}


		private function updateNumChildren(event:CollectionEvent):void
		{
			updated++;
		}


//		[Test]
		// TODO: 2011/05/16 KTD: Commented this out.  Test isn't working.  Method updateNumChidren2 not being called.
		public function testBindingNumChildren2():void
		{
			var col:TreeCollectionEx = new TreeCollectionEx();
			BindingUtils.bindSetter(updateNumChildren2, col, "numChildren");
			var child:TreeCollectionEx = new TreeCollectionEx();

			col.addChild(child);
			assertEquals(1, numChildren);
			col.removeChild(child);
			assertEquals(0, numChildren);
		}


		private function updateNumChildren2(val:int):void
		{
			numChildren = val;
		}


		[Test]
		public function test_toString():void
		{
			var col:TreeCollectionEx = new TreeCollectionEx();
			assertEquals("", col.toString());
			col.vo = new Task();
			col.vo.name = "mytask";
			assertEquals("mytask", col.toString());
		}


//		[Test]
		public function test_childrenChangedEvent():void
		{
			var col:TreeCollectionEx = new TreeCollectionEx();
			col.addEventListener(TreeChildrenChangedEvent.name, onChildrenChanged);
			var child1:TreeCollectionEx = new TreeCollectionEx();
			col.addChild(child1);
			assertEquals(1, childrenChanged);

			col.addChildAfter(new TreeCollectionEx(), child1);
			assertEquals(2, childrenChanged);

			col.vo = new Object(); //ignore updates
			assertEquals(2, childrenChanged);

			col.removeChild(child1);
			assertEquals(3, childrenChanged);
		}


		private function onChildrenChanged(e:Event):void
		{
			childrenChanged++;
		}


		[Test]
		public function test_hasChild():void
		{
			var col:TreeCollectionEx = new TreeCollectionEx();
			var child:TreeCollectionEx = new TreeCollectionEx();

			var res:Boolean = col.hasChild(child);
			assertEquals(false, res);

			col.addChild(child);
			res = col.hasChild(child);
			assertEquals(true, res);
		}


		[Test]
		public function test_getPath():void
		{
			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();

			var res:Array = col.children[0].children[0].getPath(col);

			assertEquals(2, res.length);
			assertEquals("Everything", res[0].vo.name);
			assertEquals("Project1", res[1].vo.name);
		}


		[Test]
		public function test_assignValue():void
		{
			var node:TreeCollectionEx = new TreeFactory().create1NodeCollection_Appointment();
			node.assignValue(["vo", "name"], "1");
			assertEquals("1", node.vo.name);

			var task:Task = new Task();
			node.assignValue("vo", task);
			assertEquals(task, node.vo);

		}


		[Test]
		public function test_getMaxDepth():void
		{
			var t:TreeCollectionEx = trees.create1Node();
			var depth:int = t.getMaxDepth();
			assertEquals(0, depth);

			t = trees.createParentChildCollection();
			depth = t.getMaxDepth();
			assertEquals(1, depth);

			t = trees.createPriorityTaskTree2();
			depth = t.getMaxDepth();
			assertEquals(3, depth);
		}


		[Test]
		public function test_hasDataOfType():void
		{
			var t:TreeCollectionEx = new TreeCollectionEx(new Task());

			assertTrue(t.hasDataOfType(Task));
			assertFalse(t.hasDataOfType(Item));
			assertFalse(t.hasDataOfType(null));
		}


		[Test]
		public function test_hasDataOfTypeNull():void
		{
			var t:TreeCollectionEx = new TreeCollectionEx(null);

			assertTrue(t.hasDataOfType(null));
			assertFalse(t.hasDataOfType(Task));
		}
		
		[Test]
		public function test_removeAllChildren():void {
			var t:TreeCollectionEx = new TreeCollectionEx();
			t.addChildren([new TreeCollectionEx(), new TreeCollectionEx()]);
			assertEquals(2, t.numChildren);
			
			t.removeAllChildren();
			
			assertEquals(0, t.numChildren);
		}
	}
}