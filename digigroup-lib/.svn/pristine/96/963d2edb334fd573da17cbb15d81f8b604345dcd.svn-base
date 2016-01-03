package persistence
{
	import classes.*;
	
	import collections.*;
	
	import commonutils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;


	public class ObjectPersistorTest
	{
		private var name:String = "test";
		private const testCatalog:String = "_testMaps";

		private var p:ObjectPersistor = createObjectPersistor();


		/**
		 * write an item to one catalog
		 * load one catalog
		 * write an item to another catalog and read from it
		 * delete a catalog - should not delete other catalog
		 * an item can belong only to one catalog
		 */

		[Before]
		public function setUp():void
		{
			//p.clearCatalog();
			p.removeAll();
		}


		[Test]
		public function testSaveLoad():void
		{
			var t:TreeCollectionEx = TreeCollectionEx(new TreeFactory().createSimpleCollection());

			p.save(t, name);
			var types:Array = new Array();
			types.push(Task);
			var res:* = p.load(name, t, types); //t to make the test pass (line below)

			assertTrue(ObjectHelper.compare(t, res));
			assertTrue(res is TreeCollectionEx);
			assertTrue(res.vo is Task);
		}


		[Test]
		public function contains():void {
			var t:TreeCollectionEx = TreeCollectionEx(new TreeFactory().createSimpleCollection());
			
			assertFalse(p.contains(name).result);
			
			p.save(t, name);
			
			assertTrue(p.contains(name).result);
		}
		
		[Test]
		public function testSaveLoad_IllegalCharacters():void
		{
			var t:TreeCollectionEx = TreeCollectionEx(new TreeFactory().createSimpleCollection());
			var illegalName:String = "a b";

			p.save(t, illegalName);
			var types:Array = new Array();
			types.push(Task);
			var res:* = p.load(illegalName, t, types); //t to make the test pass (line below)

			assertTrue(ObjectHelper.compare(t, res));
			assertTrue(res is TreeCollectionEx);
			assertTrue(res.vo is Task);
		}


		[Test]
		public function testSave():void
		{
			saveItem();
		}


		private function saveItem():void
		{
			var p:ObjectPersistor = createObjectPersistor();
			var item:* = TreeCollectionEx(new TreeFactory().createSimpleCollection());
			p.save(item, "testItem");

		}


		[Test]
		public function testLoad():void
		{
			saveItem();

			var item:* = TreeCollectionEx(new TreeFactory().createSimpleCollection());
			var types:Array = new Array();
			types.push(Task);

			var catalog:ArrayCollection = p.loadCatalog();
			assertEquals(1, catalog.length);
			assertEquals("testItem", catalog[0]);

			var res:* = p.load("testItem", item, types);

			assertTrue(ObjectHelper.compare(item, res));
			assertTrue(res is TreeCollectionEx);
			assertTrue(res.vo is Task);
		}


		[Test]
		public function testRemove():void
		{
			//p.removeAll();
			saveItem();

			p.remove("testItem");

			var catalog:ArrayCollection = p.loadCatalog();
			assertEquals(0, catalog.length);
		}


		[Test]
		public function testAddToCatalog_NewItem():void
		{
			p = new ObjectPersistor(testCatalog, true);
			var item1:VersionedItem = new VersionedItem("testItem1", 1);
			var item2:VersionedItem = new VersionedItem("testItem2", 2);

			p.addToCatalog(item1);
			p.addToCatalog(item2);

			var res:ArrayCollection = p.loadCatalog()
			assertEquals(2, res.length);
		}


		[Test]
		public function testAddToCatalog_UpdateItem():void
		{
			p = new ObjectPersistor(testCatalog, true);
			var item1:VersionedItem = new VersionedItem("testItem1", 1);
			p.addToCatalog(item1);
			item1.version = 2;

			p.addToCatalog(item1);

			var res:ArrayCollection = p.loadCatalog()
			assertEquals(1, res.length);
			assertEquals(2, res[0].version);
		}


		[Test]
		public function testStripIllegalCharacters():void
		{
			var res:String = ObjectPersistor.replaceIllegalCharacters("a b");
			assertEquals("a_b", res);
			res = ObjectPersistor.replaceIllegalCharacters("a  b c ");
			assertEquals("a__b_c_", res);
		}


		private function createObjectPersistor():ObjectPersistor
		{
			return new ObjectPersistor(testCatalog, false);
		}
	}
}