package mindmaps.importexport.task {
	import mindmaps.importexport.IMatcher;
	import mindmaps.importexport.MatcherTestBase;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class TaskMatcherTest extends MatcherTestBase {
		public function TaskMatcherTest() {
		}

		[Before]
		public function setUp():void {
			m = new TaskMatcher();
		}

		[After]
		public function tearDown():void {
			m = null;
		}

		[Test]
		public function matchTestData_tasks():void {
			super.matchTestData();
		}

		[Test]
		public function number():void {
			var i:int = 5;
			assertFalse(typeof(i) == "object");
			assertTrue(typeof(i) == "number");
		}

		override protected function get testData():Array {
			return [{ input: "1 a", output: { score: 2, value: { priority: 1, name: "a" }}},
				{ input: "a", output: { score: 1, value: { priority: 0, name: "a" }}},
				{ input: "V1 abc", output: { score: 2, value: { priority: 1, name: "abc" }}},
				{ input: "rx abc", output: { score: 3, value: { done: 1, reviewed: true, name: "abc" }}},
				{ input: "V1 rx abc", output: { score: 4, value: { priority: 1, done: 1, reviewed: true, name: "abc" }}},
				{ input: "V1 a b c", output: { score: 2, value: { priority: 1, name: "a b c" }}},
				{ input: "V1 a b c V,", output: { score: 3, value: { priority: 1, name: "a b c", assignedTo: "V" }}},
				{ input: "V1 a b c V,C", output: { score: 3, value: { priority: 1, name: "a b c", assignedTo: "V,C" }}},
				{ input: "a 1", output: { score: 2, value: { priority: 0, name: "a", estimatedHours: 1 }}},
				{ input: "V1 a b c V,C 1", output: { score: 4, value: { priority: 1, name: "a b c", assignedTo: "V,C", estimatedHours: 1 }}},
				{ input: "V1 a b c 1", output: { score: 3, value: { priority: 1, name: "a b c", estimatedHours: 1 }}},
				{ input: "V1 a b c V,C 1/2", output: { score: 5, value: { priority: 1, name: "a b c", assignedTo: "V,C", estimatedHours: 1, actualHours: 2 }}},
				{ input: "comment /38mins", output: { score: 2, value: { name: "comment", actualHours: 38 / 60 }}},
				{ input: "V4 Add import functionality from text", output: { score: 2, value: { priority: 4, name: "Add import functionality from text" }}}];
		}
	}
}
