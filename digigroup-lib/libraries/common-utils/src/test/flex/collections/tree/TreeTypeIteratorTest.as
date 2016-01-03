package collections.tree
{
	import classes.*;
	
	import collections.*;
	
	import flexunit.framework.TestCase;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;


	public class TreeTypeIteratorTest
	{
		[Test]
		public function testTraverseTasks():void
  		{
  			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();
  			var it:IIterator = new TreeTypeIterator(col, Task);
  			var o:* = it.next();
  			o = it.next();
  			o = it.next();
  			o = it.next();
  			assertFalse(it.hasNext());
  		}

		[Test]
  		public function testTraverseAppointments():void
  		{
  			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();
  			var it:IIterator = new TreeTypeIterator(col, Appointment);
  			var o:* = it.next();
  			assertFalse(it.hasNext());
  		}
  		
  		//traverse all Task nodes even if they are under other types of nodes (e.g. Item)
		[Test]
  		public function testTraverseTasks_NonTaskAndTaskTask():void
  		{
  			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();
  			col.children[0].vo = new Item();
  			var it:IIterator = new TreeTypeIterator(col, Task);
  			var res:Array = new Array();
  			
  			while (it.hasNext())
  				res.push(it.next());
  			
  			assertEquals(3, res.length);
  			assertEquals(col.vo, res[0].vo);
  			assertEquals(col.children[0].children[0].vo, res[1].vo);
  			assertEquals(col.children[1].vo, res[2].vo);
  		}
	}
}