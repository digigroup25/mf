package mindmaps.importexport.task {
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.assertThat;

	import vos.Task;

	public class TaskExporterTest {
		private var exporter:TaskExporter;

		[Before]
		public function setUp():void {
			exporter = new TaskExporter();
		}

		[After]
		public function tearDown():void {
			exporter = null;
		}

		[Test]
		public function testTypicalGDTask1():void {
			var task:Task = new Task().setReviewed(true).setDone(1).setCommitted(true).setName("task").setAssignedTo("V").setEstimatedHours(1.2).setActualHours(2.5);

			var expectedResult:String = "rxc task V, 1h 12m/2h 30m";

			assertExport(task, expectedResult);
		}

		[Test]
		public function testTypicalGDTask2():void {
			var task:Task = new Task().setReviewed(false).setDone(0).setCommitted(true).setName("task description").setAssignedTo("V,M").setActualHours(1);

			var expectedResult:String = "c task description V,M /1h";

			assertExport(task, expectedResult);
		}

		[Test]
		public function testTypicalGDTask3():void {
			var task:Task = new Task().setReviewed(false).setDone(0).setCommitted(false).setName("task description").setEstimatedHours(1);

			var expectedResult:String = "task description 1h";

			assertExport(task, expectedResult);
		}

		[Test]
		public function testTypicalGDTask4():void {
			var task:Task = new Task().setName("task description");

			var expectedResult:String = "task description";

			assertExport(task, expectedResult);
		}

		[Test]
		public function testTypicalGDTask5():void {
			var task:Task = new Task();

			var expectedResult:String = "";

			assertExport(task, expectedResult);
		}

		[Test]
		public function testTypicalGDTask6():void {
			var task:Task = new Task().setPriority(2).setReviewed(true).setDone(1).setCommitted(false).setName("task description").setEstimatedHours(1);

			var expectedResult:String = "R2 rx task description 1h";

			assertExport(task, expectedResult);
		}

		[Test]
		public function testTypicalGDTask_emptyAssignment():void {
			var task:Task = new Task().setAssignedTo(" ").setName("task");

			var expectedResult:String = "task";

			assertExport(task, expectedResult);
		}

		private function assertExport(task:Task, expectedResult:String):void {
			var actualResult:String = exporter.export(task);
			assertEquals(expectedResult, actualResult);
		}
	}
}
