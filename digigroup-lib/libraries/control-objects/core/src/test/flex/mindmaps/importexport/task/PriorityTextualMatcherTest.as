package mindmaps.importexport.task {
	import mindmaps.importexport.MatcherTestBase;

	import mx.utils.StringUtil;

	import org.flexunit.asserts.assertEquals;

	public class PriorityTextualMatcherTest extends MatcherTestBase {
		private static const type:String = PriorityTextualMatcher.type;

		[Before]
		public function setUp():void {
			m = new PriorityTextualMatcher();
		}

		[After]
		public function tearDown():void {
			m = null;
		}

		[Test]
		public function matchTestData_priorities():void {
			super.matchTestData();
		}

		override protected function get testData():Array {
			return [{ input: "", output: { score: 0 }},
				{ input: "a", output: { score: 0 }},
				{ input: "a_1", output: { score: 0 }},
				{ input: "1", output: { score: 1, type: type, value: 1 }},
				{ input: "P0", output: { score: 1, type: type, value: 0 }},
				{ input: "P1", output: { score: 1, type: type, value: 1 }},
				{ input: "R1", output: { score: 1, type: type, value: 1 }},
				{ input: "P-1", output: { score: 1, type: type, value: -1 }},
				{ input: " P1 ", output: { score: 1, type: type, value: 1 }},
				{ input: "P 1", output: { score: 1, type: type, value: 1 }},
				{ input: "P 999", output: { score: 1, type: type, value: 999 }},
				{ input: "V1", output: { score: 1, type: type, value: 1 }}];
		}
	}
}
