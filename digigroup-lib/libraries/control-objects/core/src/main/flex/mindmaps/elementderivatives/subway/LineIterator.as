package mindmaps.elementderivatives.subway
{
	import collections.IIterator;

	public class LineIterator implements IIterator
	{
		private var line:Line;
		private var curIndex:int = -1;
		private var forward:Boolean;
		public function LineIterator(line:Line, isReverse:Boolean=false)
		{
			this.line = line;
			this.forward = !isReverse;
			if (!forward) {
				curIndex = line.numberOfStations;
			}
		}

		public function hasNext():Boolean
		{
			return (forward) ? curIndex+1<line.numberOfStations : curIndex-1>=0;
		}
		
		public function next():Object
		{
			(forward) ? curIndex++ : curIndex--;
			return line.getStationAt(curIndex);
		}
		
		//moves iterator to a particular station
		public function moveTo(station:Station):void {
			if (!line.stations.contains(station)) throw new ArgumentError("line does not contain", station);
			
			var index:int = line.stations.getItemIndex(station);
			curIndex = index;//forward ? index-1 : index+1;
		}
		
	}
}