package
{
	// TODO: 2011/05/21 KTD: Commented out entire class.  Doesn't compile.  References VOFactory class in common-utils but that class isn't complete.

	//should I remove it?
	public class VOCollectionFilterTest
	{
		/*
		 public function VOCollectionFilterTest( methodName:String )
		 {
		 super( methodName );
		 }

		 public static function suite():TestSuite {
		 var ts:TestSuite = new TestSuite();
		 ts.addTest( new VOCollectionFilterTest( "filterAndSort_ArrayCollectionHelper") );
		 ts.addTest( new VOCollectionFilterTest( "addRemoveChild_TreeComposite") );
		 ts.addTest( new VOCollectionFilterTest( "toArrayBreadthFirst_CollectionConverter") );
		 ts.addTest( new VOCollectionFilterTest( "toArrayDepthFirst_CollectionConverter") );
		 ts.addTest( new VOCollectionFilterTest( "getDepth_TreeIterator") );
		 ts.addTest( new VOCollectionFilterTest( "getTrail_TreeComposite") );
		 ts.addTest( new VOCollectionFilterTest( "findParent_TreeComposite") );
		 ts.addTest( new VOCollectionFilterTest( "sortChildrenByPriority_HierarchicalPriorityTaskFilter") );
		 //ts.addTest( new VOCollectionFilterTest( "replaceNodeWithChildren_HierarchicalPriorityTaskFilter") );
		 ts.addTest( new VOCollectionFilterTest( "filter_HierarchicalPriorityTaskFilter_PriorityTaskTree") );
		 ts.addTest( new VOCollectionFilterTest( "filter_HierarchicalPriorityTaskFilter_PriorityTaskTree2") );
		 ts.addTest( new VOCollectionFilterTest( "createPriorityTaskTree2_VOFactory") );
		 ts.addTest( new VOCollectionFilterTest( "convert_TaskCompositeToTreeCollectionExConverter") );
		 return ts;
		 }

		 private function checkResults(expected:ArrayCollection, actual:ArrayCollection):void
		 {
		 for (var i:int=0; i<expected.length; i++)
		 {
		 var actualName:String;
		 if (actual[i] is TreeComposite)
		 actualName = actual[i].vo.name;
		 else
		 actualName = actual[i].name;

		 if (actualName!=expected[i])
		 assertTrue(//"i="+i+" ,expected="+expected[i]+", actual="+actual[i].name
		 actual.toString(), false);
		 }
		 assertTrue(true);
		 }

		 public function filterAndSort_ArrayCollectionHelper():void
		 {
		 //assertTrue(true);
		 var ach:ArrayCollectionHelper = new ArrayCollectionHelper();
		 var col:ArrayCollection = new ArrayCollection(VOFactory.createTasks1());
		 var res:ArrayCollection = ach.filterAndSort(col, "description", Task);

		 assertEquals(2, res.length);

		 res = ach.filterAndSort(col, "name", Task);

		 assertEquals(3, res.length);

		 res = ach.filterAndSort(col, "name", Appointment);

		 assertEquals(1, res.length);
		 }

		 public function addRemoveChild_TreeComposite():void
		 {
		 var parent:TreeComposite = VOFactory.createParentChildTaskTree();
		 var child:TreeComposite = new TreeComposite();
		 parent.addChild(child);
		 assertEquals(3, parent.children.length);

		 parent.removeChild(child);

		 assertEquals(2, parent.children.length);
		 }

		 public function toArrayBreadthFirst_CollectionConverter():void
		 {
		 var parent:TreeComposite = VOFactory.createParentChildTaskTree();
		 var res:ArrayCollection = CollectionConverter.toArray(parent);
		 var expRes:Array = ["0", "1A", "1B", "2A"];

		 checkResults(new ArrayCollection(expRes), res);
		 }

		 public function toArrayPreOrder_CollectionConverter():void
		 {
		 var parent:TreeComposite = VOFactory.createBinaryTree();
		 var res:ArrayCollection = CollectionConverter.toArrayPreOrder(parent);
		 //F, B, A, D, C, E, G, I, H
		 var expRes:Array = ["F", "B", "A", "D", "C", "E", "G", "I", "H"];

		 checkResults(new ArrayCollection(expRes), res);
		 }

		 public function toArrayDepthFirst_CollectionConverter():void
		 {
		 var parent:TreeComposite = VOFactory.createParentChildTaskTree();
		 var res:ArrayCollection = CollectionConverter.toArray(parent, false);
		 var expRes:Array = ["0", "1A", "2A", "1B"];

		 checkResults(new ArrayCollection(expRes), res);
		 }

		 public function createPriorityTaskTree_VOFactory():void
		 {
		 var root:TreeComposite = VOFactory.createPriorityTaskTree();

		 var res:ArrayCollection = CollectionConverter.toArray(root);
		 assertEquals(6, res.length);
		 var expRes:Array = ["0", "1A", "1B", "2A", "2B", "2C"];
		 checkResults(new ArrayCollection(expRes), res);
		 }

		 public function getTrail_TreeComposite():void
		 {
		 var root:TreeComposite = VOFactory.createPriorityTaskTree();

		 var task2B:TreeComposite  = TreeComposite(root.children[0].children[1]);
		 var res:ArrayCollection = root.getTrail(root, task2B);
		 var expRes:Array = ["0", "1A"];
		 checkResults(new ArrayCollection(expRes), res);
		 }

		 public function getDepth_TreeIterator():void
		 {
		 var root:TreeComposite = VOFactory.createPriorityTaskTree();
		 var i:ITreeIterator = new PreOrderTreeIterator(root);

		 assertEquals(0, i.getDepth());
		 i.next();
		 var node1B:TreeComposite = TreeComposite(i.next());
		 assertEquals(2, i.getDepth());
		 }

		 public function sortChildrenByPriority_HierarchicalPriorityTaskFilter():void
		 {
		 var root:TreeComposite = VOFactory.createPriorityTaskTree();
		 var res:ArrayCollection = new HierarchicalPriorityTaskFilter().sortChildrenByPriority(root);

		 assertEquals(2, res.length);
		 assertEquals("1B", res[0].name);
		 }
		 */
		/*
		 public function replaceNodeWithChildren_HierarchicalPriorityTaskFilter():void
		 {
		 var root:TreeComposite = VOFactory.createPriorityTaskTree();
		 var res:ArrayCollection = new ArrayCollection();
		 res.addItem(root.vo);
		 res.addItem(root.children[0].vo);
		 res.addItem(root.children[1].vo);

		 new HierarchicalPriorityTaskFilter().replaceNodeWithChildren(root.children[0], res);

		 //0,2A,2B,1B
		 assertEquals(4, res.length);
		 assertEquals("0", res[0].name);
		 assertEquals("2A", res[1].name);
		 assertEquals("2B", res[2].name);
		 }
		 */
		/*
		 public function filter_HierarchicalPriorityTaskFilter_PriorityTaskTree():void
		 {
		 var root:TreeComposite = VOFactory.createPriorityTaskTree();
		 var res:ArrayCollection = new HierarchicalPriorityTaskFilter().filter(root);

		 assertEquals(3, res.length);

		 var expRes:Array = ["2C", "2B", "2A"];
		 checkResults(new ArrayCollection(expRes), res);

		 }


		 public function filter_HierarchicalPriorityTaskFilter_PriorityTaskTree2():void
		 {
		 var root:TreeComposite = VOFactory.createPriorityTaskTree2();
		 var res:ArrayCollection = new HierarchicalPriorityTaskFilter().filter(root);

		 //2D, 2C, 3B, 3A, 2A
		 assertEquals(5, res.length);
		 var expRes:Array = ["2D", "2C", "3B", "3A", "2A"];
		 checkResults(new ArrayCollection(expRes), res);
		 }

		 public function createPriorityTaskTree2_VOFactory():void
		 {
		 var root:TreeComposite = VOFactory.createPriorityTaskTree2();

		 var res:ArrayCollection = CollectionConverter.toArray(root);
		 assertEquals(9, res.length);
		 var expRes:Array = ["0", "1A", "1B", "2A", "2B", "3A", "3B", "2C", "2D"];
		 checkResults(new ArrayCollection(expRes), res);
		 }

		 public function findParent_TreeComposite():void
		 {
		 var root:TreeComposite = VOFactory.createPriorityTaskTree();
		 var task2B:TreeComposite = root.children[0].children[1];
		 var task1A:TreeComposite = root.children[0];

		 var res:TreeComposite = task2B.findParent(root);
		 assertEquals(task1A, res);
		 }

		 public function convert_TaskCompositeToTreeCollectionExConverter():void
		 {
		 TreeCollectionEx.counter = 0;
		 var root:TaskComposite = TestFactory.createParentChildTaskComposite();
		 var res:TreeCollectionEx = new TaskCompositeToTreeCollectionExConverter().convert(root);
		 var exp:TreeCollectionEx = TestFactory.createParentChildCollection();
		 assertTrue(ObjectHelper.compare(res,exp));
		 }
		 */
	}
}