package mindmaps.elementderivatives.subway
{
	import collections.IIterator;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class OrderedSubwayLayouter extends SubwayLayouter
	{
		public override function compute(subWay:Subway):SubwayLayout {
			var positions:Dictionary = computedOrderedPositions(subWay);
			var res:SubwayLayout = new SubwayLayout(positions);
			return res;
		}
		
		private function computedOrderedPositions(subWay:Subway):Dictionary {
			var res:Dictionary = new Dictionary();
			for (var y:int=0; y<subWay.numberOfLines; y++) {
				var lineIterator:IIterator = subWay.getLineAt(y).createIterator();
				
				while (lineIterator.hasNext()) {
					var station:OrderedStation = OrderedStation(lineIterator.next());
					var x:int = station.number;
					if (station.isTransferStation()) {
						//compute location only once
						if (res[station]!=undefined) {
							continue;
						}
						res[station] = new Point(x, calculateYMean(subWay, station));
					}
					else {
						res[station] = new Point(x, y);
					}
				}
			}
			return res;
		}
	}
}