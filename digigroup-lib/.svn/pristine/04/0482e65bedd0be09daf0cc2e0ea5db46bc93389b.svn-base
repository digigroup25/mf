package mindmaps.importexport.task
{
	import mindmaps.importexport.IMatcher;
	import mindmaps.importexport.MatcherTestBase;
	import mindmaps.importexport.Match;
	
	import mx.utils.StringUtil;
	
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.hasProperty;
	
	public class PriorityPositionalMatcherTest extends MatcherTestBase
	{		
		private const priorityToken:Match = new Match(PriorityTextualMatcher.type, "V1");
		private const nameToken:Match = new Match(NameTextualMatcher.type, "abc");
		
		override protected function get testData():Array {
			return [
				{input:[priorityToken, nameToken], output:{score:1}}
				, {input:[nameToken, priorityToken], output:{score:1}}
				, {input:[nameToken, nameToken], output:{score:0}}
				, {input:[priorityToken, priorityToken], output:{score:0}}
			];
		}
		
		[Before]
		public function setUp():void
		{
			m = new PriorityPositionalMatcher();
		}
		
		[After]
		public function tearDown():void
		{
			m = null;
		}
		
		[Test]
		public function matchTestData_priorityPositions():void {
			super.matchTestData();
		}
		
		[Test]
		public function matchOutputType():void {
			var result:Match = m.match([priorityToken, nameToken]);
			assertThat(result, hasProperty("type", PriorityPositionalMatcher.type));
		}
	}
}