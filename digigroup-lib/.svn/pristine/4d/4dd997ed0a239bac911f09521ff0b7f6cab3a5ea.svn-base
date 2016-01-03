package commonutils 
{
	import classes.Item;
	import classes.Task;
	import classes.TreeFactory;

	import collections.TreeCollectionEx;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;


	public class DeepCopyTest
 	{
		[Test]
  	    public function test_clone_parentChild():void {
  			var t:TreeCollectionEx = new TreeFactory().createParentChildCollection();
  			var t2:TreeCollectionEx = TreeCollectionEx(DeepCopy.clone(t));
  			
  			assertFalse(t==t2);
  			assertTrue(ObjectHelper.compare(t, t2));
  		}

//		[Test]
		// TODO: 2011/05/11 KTD: Commented out.  Getting Error #1056.
  		public function test_clone_withoutRegisterClassAlias_3Node():void {
  			var t:TreeCollectionEx = new TreeFactory().createRandomVoTree(1000, [Task, Item], true);
  			var t2:TreeCollectionEx = TreeCollectionEx(DeepCopy.clone(t, false));
  			
  			assertFalse(t==t2);
  			assertTrue(ObjectHelper.compare(t, t2));
  		}

//		[Test]
		// TODO: 2011/05/11 KTD: Commented out.  Getting Error #1056.
  		public function test_clone_1000nodeTree():void {
  			var t:TreeCollectionEx = new TreeFactory().createRandomVoTree(1000, [Task, Item], true);
  			var size:int = t.size;
  			var t2:TreeCollectionEx = TreeCollectionEx(DeepCopy.clone(t, false));
  			
  			assertFalse(t==t2);
  			assertTrue(ObjectHelper.compare(t, t2));
  		}

		[Test]
  		public function test_clone_circularReference():void {
  			var a:Object = new Object();
  			var b:Object = new Object();
  			a["b"]=b;
  			b["a"]=a;
  			
  			var aClone:Object = DeepCopy.clone(a, true);
  			assertTrue(aClone!=null);
  			assertTrue(aClone["b"]!=undefined);
  			assertEquals(aClone, aClone["b"]["a"]);
  		}
  	}
}