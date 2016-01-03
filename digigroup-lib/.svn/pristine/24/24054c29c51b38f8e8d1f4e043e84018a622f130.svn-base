package mindmaps.elementderivatives
{


	import org.flexunit.asserts.assertEquals;


	public class ProjectParserTest

	{
		private var p:ProjectParser = new ProjectParser();


		public function ProjectParserTest()
		{
		}


		[Test]
		public function test_parse_line():void {
			var t:String = "abc\nde\nf";
			var res:Array =t.split("\n");
			assertEquals(3, res.length);
		}

		[Test]
		public function test_parse():void {
			var res:Array = p.parse(ProjectTexts.twoTasks);
			
			assertEquals(2, res.length);
		}

		[Test]
		public function test_replaceMultiple():void {
			var s:String = "a\n\nb\nc";
			var res:String = p.replaceMultiple(s, "\n", "\n");
			assertEquals("a\nb\nc", res);
		}
	}
}