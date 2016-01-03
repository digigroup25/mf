package mindmaps.elementderivatives.subway
{
	import collections.IIterator;
	
	import flexunit.framework.TestCase;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;

	import org.flexunit.asserts.assertTrue;


	public class LineIteratorTest
	{
		public function LineIteratorTest()
		{
		}

		[Test]
		public function test_2stations_forward():void {
			var line:Line = new LineFactory().createStations(2);
			var it:IIterator = line.createIterator();
			assertTrue("s0 exists", it.hasNext());
			var s0:Station = Station(it.next());
			assertEquals(line.getStationAt(0), s0);
			assertTrue("s1 exists", it.hasNext());
			var s1:Station = Station(it.next());
			assertEquals(line.getStationAt(1), s1);
			assertFalse("s2 does not exist", it.hasNext());
		}

		[Test]
		public function test_2stations_backward():void {
			var line:Line = new LineFactory().createStations(2);
			var it:IIterator = new LineIterator(line, true);
			assertTrue("s1 exists", it.hasNext());
			var s1:Station = Station(it.next());
			assertEquals(line.getStationAt(1), s1);
			assertTrue("s0 exists", it.hasNext());
			var s0:Station = Station(it.next());
			assertEquals(line.getStationAt(0), s0);
			assertFalse("s-1 does not exist", it.hasNext());
		}

		[Test]
		public function test_2stations_moveTo():void {
			var line:Line = new LineFactory().createStations(3);
			var it:LineIterator = new LineIterator(line);
			it.moveTo(line.getStationAt(1));
			var s2:Station = Station(it.next());
			assertEquals(line.getStationAt(2), s2);
			
			
			it = new LineIterator(line, true);
			it.moveTo(line.getStationAt(1));
			var s0:Station = Station(it.next());
			assertEquals(line.getStationAt(0), s0);
			assertFalse("s-1 does not exist", it.hasNext());
		}

		[Test]
		public function test_subway_3stations():void {
			var subWay:Subway = new SubwayFactory().createSubway3Stations();
			var line0:Line = subWay.lines[0];
			var it:IIterator = line0.createIterator();
			assertTrue("s0 exists", it.hasNext());
			var s0:Station = Station(it.next());
			assertEquals(line0.getStationAt(0), s0);
			assertTrue("s1 exists", it.hasNext());
			var s1:Station = Station(it.next());
			assertEquals(line0.getStationAt(1), s1);
			assertFalse("s2 does not exist", it.hasNext());
		}
	}
}