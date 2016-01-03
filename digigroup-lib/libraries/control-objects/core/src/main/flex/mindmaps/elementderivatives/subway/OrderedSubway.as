package mindmaps.elementderivatives.subway
{
	public class OrderedSubway extends Subway
	{
		public function addOrderedStation(number:int, name:String, lines:Array):Station {
			var station:OrderedStation = new OrderedStation(number, name);
			for each(var line:Line in lines) {
				line.addStation(station);
			} 
			return station;
		} 
	}
}