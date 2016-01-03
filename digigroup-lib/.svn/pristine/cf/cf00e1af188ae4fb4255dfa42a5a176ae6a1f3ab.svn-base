package mindmaps.importexport
{
	import collections.TreeCollectionEx;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	
	import vos.Item;
	import vos.Task;

	public class MapTextImporterTest
	{
		private static const importer:MapTextImporter = new MapTextImporter();
		private static const treeAsserter:TreeAsserter = new TreeAsserter();
		private static const sampleTasksFromGD:String = 
			"Create first version of Mindmapping application\r"
			+"    V4 Add import functionality from text\r"
			+"        x create XmlCollectionConverter unit test, test proxy, added several cases for comparing "
			+"xml values, refactored out xmlToVo method - V 1\r\r"
			+"xc add expectedHours and actualHours to Task and test persistence - V 1/0.75\r\r"
			+"x added CompositeMatch with unit tests - V /0.75";
		
		private static const threeTasksText:String = "taskA\r    taskB\r        taskC";
		private static const threeTasksObjectTree:Object = {vo:{name:'taskA'}, children:[{vo:{name:'taskB'}, children:[{vo:{name:'taskC'}}]}]};
		
		private static const threeTasksGDText:String = 
"Create first version of Mindmapping application"+
		"V4 Add import functionality from text" +
				"xc refactor to not use isPersistentMap - 1/0.75";
		
		private static const twoSiblingTasksText:String = "taskA\r taskB\rtaskC";
		private static const twoSiblingTasksObjectTree:Object = {vo:{name:''}, children:[{vo:{name:'taskA'}, children:[{vo:{name:'taskB'}}]}, {vo:{name:'taskC'}}]};
		
		private static const threeTasksTwoSiblingsText:String = "taskA\r taskB\r taskC";
		private static const threeTasksTwoSiblingsObjectTree:Object = {vo:{name:'taskA'}, children:[{vo:{name:'taskB'}}, {vo:{name:'taskC'}}]};
		private static const threeTasksGDObjectTree:Object = {vo:{name:"Create first version of Mindmapping application"}, children:[{vo:{name:"Add import functionality from text"},
			children:[{vo:{name:"refactor to not use isPersistentMap"}}]}]};
		
		private static const multiLevelTasksText:String = 
			"task one description A,B 0.1/0.2\r"+"" +
			" V1 task two 0.3\r"+
			"  task three A,\r"+
			" task four\r"+
			"  task five\r";
		
		private static const multiLevelTasksObjectTree:Object = 
			{vo:{name:'task one description', assignedTo:'A,B', estimatedHours:0.1, actualHours:0.2}, children:[
			{vo:{name:'task two', priority:1, estimatedHours:0.3}, children:[{vo:{name:'task three'}}]},
			{vo:{name:'task four'}, children:[{vo:{name:'task five'}}]}]
			}; 
		
		private static const textLines:String = "a\r\r b";
		
		[Test]
		public function importNull():void {
			var result:TreeCollectionEx = importer.importFrom(null);
			assertNull(result);
			
		}
		
		[Ignore]
		[Test]
		public function importEmpty():void {
			var result:TreeCollectionEx = importer.importFrom("");
			assertNotNull(result);
			assertThat(result, isA(Item));
		}
		
		[Test]
		public function assertOneTasks_notSubset():void {
			var task:Task = new Task();
			task.name = "taskName";
			task.assignedTo = "assignedToValue";
			var taskTree:TreeCollectionEx = new TreeCollectionEx(task);
			var taskObjectTree:Object = {vo:{name:'taskName2', assignedTo:'assignedToValue'}};
			
			var result:Object = treeAsserter.isSubset(taskTree, taskObjectTree);
			
			assertThat(not(result.result));
		}
		
		[Test]
		public function import_twoSiblingTasksText():void {
			var twoSiblingTasksTree:TreeCollectionEx = importer.importFrom(twoSiblingTasksText);

			var result:Object = treeAsserter.isSubset(twoSiblingTasksTree, twoSiblingTasksObjectTree);
			assertThat(result.result);
		}
		
		[Test]
		public function import3tasks2siblings():void {
			var threeTasksTwoSiblingsTree:TreeCollectionEx = importer.importFrom(threeTasksTwoSiblingsText);
			
			var result:Object = treeAsserter.isSubset(threeTasksTwoSiblingsTree, threeTasksTwoSiblingsObjectTree);
			assertThat(result.result);
		}
		
		
		[Ignore("Leading spaces are not imported correctly from GD")]
		[Test]
		public function import3tasksGDText():void {
			var threeTasksGDTree:TreeCollectionEx = importer.importFrom(threeTasksGDText);
			
			var result:Object = treeAsserter.isSubset(threeTasksGDTree, threeTasksGDObjectTree);
			assertThat(result.result);
		}

		[Test]
		public function importMultiLevelTasks():void {
			var tree:TreeCollectionEx = importer.importFrom(multiLevelTasksText);

			var result:Object = treeAsserter.isSubset(tree, multiLevelTasksObjectTree);
			assertThat(result.result);
		}
		
		[Test]
		public function importSampleTasksFromGD():void {
			var result:TreeCollectionEx = importer.importFrom(sampleTasksFromGD);
		
			assertNotNull(result);
			assertThat(result.vo, isA(Task));
		}
		
		[Test]
		public function breakIntoLines():void {
			var lines:Array = importer.breakIntoLines(textLines);
			assertThat(lines, array("a", " b"));
		}
		
		[Test]
		public function getPrecedingSpaces():void {
			assertEquals(0, importer.getPrecedingSpaces(""));
			assertEquals(1, importer.getPrecedingSpaces(" "));
			assertEquals(3, importer.getPrecedingSpaces("   a "));
		}
	}
}