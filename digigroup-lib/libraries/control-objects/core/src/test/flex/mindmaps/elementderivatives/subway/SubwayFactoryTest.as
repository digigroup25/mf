package mindmaps.elementderivatives.subway
{
	import mindmaps.elementderivatives.ProjectTexts;
	
	import org.flexunit.asserts.*;

	public class SubwayFactoryTest 
	{
		[Test]
		public function test_createFromText_twoTasks():void {
			var f:SubwayFactory = new SubwayFactory();
			var res:Subway = f.createFromText(ProjectTexts.twoTasks);
			assertEquals(1, res.numberOfLines);
			assertEquals(2, res.lines[0].numberOfStations);
		}
		
		[Test]
		public function test_createFromText_twoTasks2Lines():void {
			var f:SubwayFactory = new SubwayFactory();
			var res:Subway = f.createFromText(ProjectTexts.twoTasks2Lines);
			assertEquals(2, res.numberOfLines);
			assertEquals(2, res.lines[0].numberOfStations);
			assertEquals(1, res.lines[1].numberOfStations);
		}
		
		[Test]
		public function test_createFromText_sampleProjectSnippet():void {
			var f:SubwayFactory = new SubwayFactory();
			var res:Subway = f.createFromText(ProjectTexts.sampleProjectSnippet.text);
			assertEquals("number of lines", ProjectTexts.sampleProjectSnippet.numberOfLines, res.numberOfLines);
			assertEquals("number of stations", ProjectTexts.sampleProjectSnippet.numberOfStations, res.numberOfStations);
		}
	}
}