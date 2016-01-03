package mindmaps.elementderivatives.subway
{
	public class LineFactory
	{
		public function createStations(number:int):Line {
			var line:Line = new Line();
			for (var i:int=0; i<number; i++) {
				line.addStation(new Station(i.toString()));
			}
			return line;
		}
	}
}