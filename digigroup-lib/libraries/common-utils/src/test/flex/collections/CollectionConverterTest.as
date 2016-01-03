package collections
{
	import classes.*;

	import mx.collections.ArrayCollection;

	import org.flexunit.asserts.assertEquals;


	public class CollectionConverterTest
 	{
		[Test]
   		public function testToArray():void
   		{
   			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();
   			
   			var res:ArrayCollection = CollectionConverter.toArray(new CollectionConverterContext(col));
   			
   			assertEquals(5, res.length);
   			assertEquals("Everything", res[0].vo.name);
   			assertEquals("Project1", res[1].vo.name);
   			assertEquals("Task1", res[2].vo.name);
   			assertEquals("Appointment1", res[3].vo.name);
   			assertEquals("Project2", res[4].vo.name);
   			//assertTrue(res[0] is TreeCollectionEx);
   		}

		[Test]
   		public function testToArrayWithPath():void
   		{
   			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();
   			var context:CollectionConverterContext = new CollectionConverterContext(col, null, true)
   			
   			var res:ArrayCollection = CollectionConverter.toArray(context);
   			
   			assertEquals(5, res.length);
   			assertEquals("Everything", res[0].vo.name);
   			
   			var taskPath:Array = res[2].path;
   			assertEquals("Everything", taskPath[0].vo.name);
   			assertEquals("Project1", taskPath[1].vo.name);
   			
   			var project2Path:Array = res[4].path;
   			assertEquals("Everything", project2Path[0].vo.name);
   		}
  }
}