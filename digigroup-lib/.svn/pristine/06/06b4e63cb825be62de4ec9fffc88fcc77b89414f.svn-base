package mindmaps.importexport.task {
	import commonutils.TimeSpan;

	import mindmaps.importexport.MatcherTestBase;

	public class ExecutionPeriodTextualMatcherTest extends MatcherTestBase {

		[Before]
		public function setUp():void {
			m = new ExecutionPeriodTextualMatcher();
		}

		[After]
		public function tearDown():void {
			m = null;
		}

		[Test]
		public function matchTestData_executionPeriods():void {
			super.matchTestData();
		}

		//private static const type:String = ExecutionPeriodTextualMatcher.type;

		override protected function get testData():Array {
			return [{ input: "", output: { score: 0 }},
				{ input: "a", output: { score: 0 }},
				{ input: "a_1", output: { score: 0 }},
				{ input: "1", output: { score: 1, matches: [{ type: "estimatedHours", value: TimeSpan.fromHours(1)}]}},
				{ input: "/1", output: { score: 1, matches: [{ type: "actualHours", value: TimeSpan.fromHours(1)}]}},
				{ input: "1/2", output: { score: 2, matches: [{ type: "estimatedHours", value: TimeSpan.fromHours(1)}, { type: "actualHours", value: TimeSpan.fromHours(2)}]}},
				{ input: "1.5/2.5", output: { score: 2, matches: [{ type: "estimatedHours", value: TimeSpan.fromHours(1.5)}, { type: "actualHours", value: TimeSpan.fromHours(2.5)}]}},
				{ input: "(1/2)", output: { score: 2, matches: [{ type: "estimatedHours", value: TimeSpan.fromHours(1)}, { type: "actualHours", value: TimeSpan.fromHours(2)}]}},
				{ input: "1h30m)", output: { score: 1, matches: [{ type: "estimatedHours", value: TimeSpan.fromHours(1.5)}]}}
				/*,
				{input:"P0", output:{score:1, type:type, value:0}},
				{input:"P1", output:{score:1, type:type, value:1}},
				{input:"P-1", output:{score:1, type:type, value:-1}},
				{input:" P1 ", output:{score:1, type:type, value:1}},
				{input:"P 1", output:{score:1, type:type, value:1}},
				{input:"P 999", output:{score:1, type:type, value:999}},
				{input:"V1", output:{score:1, type:type, value:1}}*/];
		}
	}
}
