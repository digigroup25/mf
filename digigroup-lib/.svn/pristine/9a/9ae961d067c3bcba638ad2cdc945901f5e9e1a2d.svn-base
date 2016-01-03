package mindmaps.importexport.task
{
	import mindmaps.importexport.MatcherTestBase;

	public class StatusTextualMatcherTest extends MatcherTestBase
	{
		protected override function get testData():Array {
			return [
				{input:"", output:{score:0}},
				{input:"a", output:{score:0}},
				{input:"abcx", output:{score:0}},
				{input:"cox", output:{score:0}},
				{input:"ra", output:{score:0}},

				{input:"c", output:{score:1, matches:[{type:"committed", value:true}]}},
				{input:"x", output:{score:1, matches:[{type:"done", value:1}]}},
				{input:"r", output:{score:1, matches:[{type:"reviewed", value:true}]}},
				{input:"cx", output:{score:1, matches:[{type:"committed", value:true}, {type:"done", value:1}] }},
				{input:"rx", output:{score:1, matches:[{type:"reviewed", value:true}, {type:"done", value:1}] }},
				{input:"rxc", output:{score:1, matches:[{type:"reviewed", value:true}, {type:"done", value:1}, {type:"committed", value:true}] }}
			];
		}
		
		[Before]
		public function setUp():void
		{
			m = new StatusTextualMatcher();
		}
		
		[After]
		public function tearDown():void
		{
			m = null;
		}
		
		[Test]
		public function matchTestData_statuses():void {
			super.matchTestData();
		}
	}
}