package collections
{
	import mx.utils.ObjectProxy;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.fail;


	public class AliasHashMapTest
	{
		private var m:AliasHashMap;
		
		public function AliasHashMapTest()
		{
		}

		[Before]
		public function setUp():void {
			m = new AliasHashMap();
		}

		[Test]
		public function test_getPropertyByName():void {
			m["a"] = -1;
			
			var p:* = m["a"];
			
			assertEquals(-1, p);
		}

		[Test]
		public function test_getNonExistingProperty():void {
			var p:String = m["nonExisting"];
			
			assertNull(p);
		}

		[Test]
		public function test_getEmptyListOfAliases():void {
			var res:Array = m.getAliases();
			
			assertEquals(0, res.length);
		}

		[Test]
		public function test_get1Alias():void {
			m.addAlias("b", "a");
			
			var res:Array = m.getAliases();
			assertEquals(1, res.length);
			assertEquals("b", res[0].alias);
		}

		[Test]
		public function test_addNullAlias():void {
			try {
				m.addAlias(null, "a");
				fail();
			}
			catch (e:Error){}	
		}

		[Test]
		public function test_addSameAliasTwice():void {
			m.addAlias("b", "a");
			m.addAlias("b", "a");
			
			var res:Array = m.getAliases();
			
			assertEquals(1, res.length);
			assertEquals("b", res[0].alias);
		}

		[Test]
		public function test_addSameAliasTwiceForDifferentProperties():void {
			m.addAlias("b", "a");
			m.addAlias("b", "c");
			
			var res:Array = m.getAliases();
			
			assertEquals(1, res.length);
			assertEquals("b", res[0].alias);
			assertEquals("c", res[0].propertyName);
		}

		[Test]
		public function test_addCircularAlias():void {
			m.addAlias("a", "b");
			try {
				m.addAlias("b", "a");
				fail();
			}
			catch (e:Error){}
		}

		[Test]
		public function test_getPropertyByAlias_1indirection():void {
			m.addAlias("b", "a");
			m["a"] = 1;
			
			var res:int = m["b"];
			
			assertEquals(1, res);
		}
		
		//if a value is Object, ObjectProxy is created to wrap around Object
		//and therefore cannot compare reference equality, only contents
		[Test]
		public function test_getPropertyByAlias_1indirection_ObjectType():void {
			m.addAlias("b", "a");
			m["a"] = {key:"value"};
			
			var res:Object = m["b"];
			
			assertEquals("value", res.key);
		}

		[Test]
		public function test_getPropertyByAlias_2indirection():void {
			m.addAlias("b", "a");
			m.addAlias("c", "b");
			var testObject:Object = new ObjectProxy();
			m["a"] = testObject;
			
			var resB:Object = m["b"];
			var resC:Object = m["c"];
			
			assertStrictlyEquals(testObject, resB);
			assertStrictlyEquals(testObject, resC);
		}

		[Test]
		public function test_clone_objectCopiedByReference():void {
			var testValue:ObjectProxy = new ObjectProxy();
			m["a"] = testValue;
			
			var clone:AliasHashMap = AliasHashMap(m.clone());
			
			assertNotNull(clone);
			assertFalse(m==clone);
			assertEquals(testValue, clone["a"]);
		}

		[Test]
		public function test_clone_aliasesAreCopied():void {
			m.addAlias("b", "a");
			m.addAlias("c", "b");
			
			var res:AliasHashMap = AliasHashMap(m.clone());
			
			assertEquals(2, res.getAliases().length);
		}

		[Test]
		public function test_setAlias():void {
			m.addAlias("b", "a");
			var testValue:ObjectProxy = new ObjectProxy();
			m["b"] = testValue;
			
			var resB:Object = m["b"];
			var resA:Object = m["a"];
			
			assertEquals(testValue, resB);
			assertEquals(testValue, resA);
		}

		[Test]
		public function test_copyFrom_aliasesAreCopied():void {
			m.addAlias("b", "a");
			var newMap:AliasHashMap = new AliasHashMap();
			newMap.copyFrom(m);
			
			var aliases:Array = newMap.getAliases();
			assertEquals(1, aliases.length);
		}
	}
}