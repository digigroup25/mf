package mindmaps.importexport.task
{
	import mindmaps.importexport.MatcherTestBase;
	
	import mx.utils.StringUtil;
	
	import org.flexunit.asserts.assertEquals;
	
	public class AssignedToTextualMatcherTest extends MatcherTestBase
	{		
		private static const type:String = AssignedToTextualMatcher.type;
		
		protected override function get testData():Array {
			return [
				{input:"", output:{score:0}},
				{input:"1", output:{score:0}},
				{input:"11", output:{score:0}},
				{input:"B", output:{score:1, type:type, value:"B"}},
				{input:"Bob", output:{score:1, type:type, value:"Bob"}},
				{input:"Bob,Alice", output:{score:1, type:type, value:"Bob,Alice"}},
				{input:"B,A", output:{score:1, type:type, value:"B,A"}},
				{input:"B,1 ", output:{score:1, type:type, value:"B"}},
				{input:"1,B", output:{score:1, type:type, value:"B"}}
			];
		}
		
		[Before]
		public function setUp():void
		{
			m = new AssignedToTextualMatcher();
		}
		
		[After]
		public function tearDown():void
		{
			m = null;
		}
		
		[Test]
		public function matchTestData_priorities():void {
			super.matchTestData();
		}
	}
}