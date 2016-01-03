package mindmaps.importexport.task
{
	import mindmaps.importexport.IMatcher;
	import mindmaps.importexport.MatcherTestBase;
	
	import mx.utils.StringUtil;
	
	import org.flexunit.asserts.assertEquals;
	
	
	public class NameTextualMatcherTest extends MatcherTestBase
	{		
		private static const type:String = NameTextualMatcher.type;
		
		override protected function get testData():Array {
			return [
				/*{input:"", output:{score:0}},*/
				{input:"1", output:{score:0}},
				{input:"123", output:{score:0}},
				{input:"1 1", output:{score:0}},
				{input:"a,", output:{score:0}},
				{input:"P0", output:{score:0/*, type:type, value:"P0"*/}},
				
				{input:"a", output:{score:1, type:type, value:"a"}},
				{input:"ab", output:{score:1, type:type, value:"ab"}},
				{input:"'ab'", output:{score:1, type:type, value:"'ab'"}},
				{input:"0 1 a", output:{score:1, type:type, value:"a"}},
				{input:"abc", output:{score:1, type:type, value:"abc"}},
				{input:" abc ", output:{score:1, type:type, value:"abc"}},
				{input:"ab c ", output:{score:1, type:type, value:"c"}},
				{input:"do laundry", output:{score:1, type:type, value:"laundry"}},
				{input:"go to store and buy groceries", output:{score:1, type:type, value:"groceries"}}
			];
		}
		
		[Before]
		public function setUp():void
		{
			m = new NameTextualMatcher();
		}
		
		[After]
		public function tearDown():void
		{
			m = null;
		}
		
		[Test]
		public function matchTestData_names():void {
			super.matchTestData();
		}
	}
}