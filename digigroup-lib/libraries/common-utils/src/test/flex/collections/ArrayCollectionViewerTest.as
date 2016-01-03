package collections 
{
	import classes.*;

	import mx.collections.*;

	import org.flexunit.asserts.assertEquals;


	public class ArrayCollectionViewerTest
 	{
 		private var col:TreeCollectionEx;
 		private var viewer:ArrayCollectionViewer = new ArrayCollectionViewer();

		[Before]
 		public function setUp():void
 		{
 			col = new TreeFactory().createSimpleCollection();
 		}

		[Test]
   		public function test_createView_sortByPriorityAscDesc_simpleCollection():void
  		{
  			var flatCol:ArrayCollection = col.toArray();
			var context:ArrayCollectionViewerContext = new ArrayCollectionViewerContext("priority", false, Task, true);
			//sort asc
			var result:ArrayCollection = viewer.createView(flatCol, context);
			
			assertEquals("Project2", Task(result[result.length-1].vo).name);
			
			//sort desc
			context.descending = true;
			result = viewer.createView(flatCol, context);
			
			assertEquals("Project2", Task(result[0].vo).name);
  		}

		[Test]
		public function test_createView_Tasks_simpleCollection():void
		{
			var context:ArrayCollectionViewerContext = new ArrayCollectionViewerContext(null, 
				false, Task, true);
			var flatCol:ArrayCollection = col.toArray();
			
			var result:ArrayCollection = viewer.createView(flatCol, context);
			
			assertEquals(3, result.length);
			assertEquals("Project1", result[0].vo);
		}

		[Test]
		public function test_createView_Appointments_simpleCollection():void
		{
			var context:ArrayCollectionViewerContext = new ArrayCollectionViewerContext(null, 
				false, Appointment, true);
			var flatCol:ArrayCollection = col.toArray();
			
			var result:ArrayCollection = viewer.createView(flatCol, context);
			
			assertEquals(1, result.length);
		}
  	}
}