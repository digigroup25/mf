package mindmaps.elementderivatives.subway
{
	import collections.IIterator;
	import collections.TreeCollectionEx;
	
	import mx.utils.StringUtil;
	
	import vos.Task;
	
	public class TreeToSubwayConverter
	{
		private var lineMap:Object ;
		
		public function TreeToSubwayConverter()
		{
		}
		
		public function convert(tree:TreeCollectionEx):Subway {
			//iterate thru all tasks
			//check assignedTo property
			//parse out assignees
			//if a task has multiple assignees, create a transfer station
			//otherwise create a station and link it with a previous station
			lineMap = new Object();
			var it:IIterator = tree.createIterator(Task);
			var res:OrderedSubway = new OrderedSubway();
			var previousStation:Station = null;
			var number:int = -1;
			while (it.hasNext()) {
				
				var node:TreeCollectionEx = TreeCollectionEx(it.next());
				if (node.hasChildren()) continue; //skip if has children
				var task:Task = Task(node.vo);
				var assignedTo:String = task.assignedTo;
				if (assignedTo==null || assignedTo=="") continue;
				
				var assignees:Array = parseAssignees(assignedTo);
				if (assignees.length==0) continue;
				
				number++;
				var station:Station = new Station(node.vo.name);
				var assigneeLines:Array = getAssigneeLines(assignees);
				res.addLines(assigneeLines);
				
				station = res.addOrderedStation(number, station.name, assigneeLines);
				station.visited = task.done == 1; 
				
				
				//create a link with previous station if not on the same line
				/* if (previousStation!=null && !station.containsLine(previousStation.lines[0])) {
					
					if (previousStation.isTransferStation()) {
						station.lines[0].addStationBefore(previousStation, station);
					}
					else {
						var dummyStation:Station = new Station(previousStation.name);
						var dummyStations:Array = new Array();
						if (station.isTransferStation()) {
							for each (var line:Line in station.lines) {
								var dummyStation:Station = new Station(previousStation.name);
								dummyStations.push(dummyStation);
								line.addStationBefore(dummyStation, station);
							}
						}
						else {
							var dummyStation:Station = new Station(previousStation.name);
							station.lines[0].addStationBefore(dummyStation, station);
							dummyStations.push(dummyStation);
						} 
						//insert previous station as first
						dummyStations.unshift(previousStation);
						res.markAsTransferStations(dummyStations);
					} 
						
				} 
				previousStation = station;
				*/
			}
			return res;
		}
		
		private function parseAssignees(assignedTo:String):Array {
			var assignees:Array = assignedTo.split(",");
			for (var i:int=0; i<assignees.length; i++) {
				assignees[i] = StringUtil.trim(assignees[i]);
			}
			return assignees;
		}
		
		private function getAssigneeLine(lineName:String):Line {
			if (lineMap[lineName]==null) {
				var line:Line = new Line(lineName);
				lineMap[lineName] = line;
			}
			return lineMap[lineName];
		}
		
		private function getAssigneeLines(lineNames:Array):Array {
			var res:Array = new Array();
			for each (var lineName:String in lineNames) {
				res.push(getAssigneeLine(lineName));
			}
			return res;
		}
	}
}