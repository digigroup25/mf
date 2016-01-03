package mindmaps.elementderivatives.subway
{
	import collections.IIterator;
	import collections.TreeCollectionEx;
	
	import factories.TreeFactory;
	
	import flash.utils.Dictionary;
	
	import mindmaps.elementderivatives.ProjectParser;
	
	import vos.Task;
	
	public class SubwayFactory
	{
		private const trees:TreeFactory = new TreeFactory();
		
		public function SubwayFactory()
		{
		}
		
		public function treeForSubway():TreeCollectionEx {
			var t:TreeCollectionEx = trees.createParentChildCollection();
			t.vo.assignedTo = "1,2";
			t.children[0].vo.assignedTo = "2,3";
			return t;
		}
		
		private function createTask(taskName:String, assignedTo:String):Task {
			var t1:Task = new Task();
			t1.name = taskName;
			t1.assignedTo = assignedTo;
			return t1;
		}
		
		public function taxSubway():Subway {
			var v:Line = new LineFactory().createStations(2);
			v.stations[0].name = "1";
			v.stations[1].name = "4";
			var c:Line = new LineFactory().createStations(2);
			c.stations[0].name = "2";
			var k:Line = new LineFactory().createStations(2);
			k.stations[0].name = "3";
			var res:Subway = new Subway();
			res.addLines([v,c,k]);
			c.addStation(v.stations[0]);
			k.addStation(c.stations[1]);
			k.addStation(v.stations[1]);
			return res;
		}
		
		public function treeForTaxSubway():TreeCollectionEx {
			var t:TreeCollectionEx = trees.createParentNChildren(4);
			var task:Task = new Task();
			task.name = "taxes";
			t.vo = task;
			
			t.children[0].vo = createTask("review taxes", "v, c");
			t.children[0].vo.done = 1;
			
			t.children[1].vo = createTask("submit taxes", "c");
			t.children[2].vo = createTask("create initial draft", "k");
			t.children[3].vo = createTask("review initial draft", "v, c");
			
			return t;
		}
		
		public function treeForTaxSubway_dependencies():TreeCollectionEx {
			var t:TreeCollectionEx = treeForTaxSubway();
			t.children[0].vo.assignedTo = "v,c";
			t.children[1].vo.assignedTo = "c";
			t.children[2].vo.assignedTo = "c,k";
			t.children[3].vo.assignedTo = "v,k";
			return t;
		}
		
		/**					s1 (l0)
		 * 				/			
		 * s0 (l0,l1)
		 * 				\
		 * 					s2 (l1)
		 **/
		public function createSubway3Stations():Subway {
			var l0:Line = new LineFactory().createStations(2);
			var l1:Line = new LineFactory().createStations(2);
			var res:Subway = new Subway();
			res.addLines([l0, l1]);
			res.markAsTransferStations([l0.getStationAt(0), l1.getStationAt(0)]);
			return res;
		}
		
		public function treeForSubway3Stations():TreeCollectionEx {
			var s0:Task = new Task();
			s0.name = "s0";
			s0.assignedTo = "l0,l1";
			var root:TreeCollectionEx = new TreeCollectionEx(s0);
			
			var s1:Task = new Task();
			s1.name = "s1";
			s1.assignedTo = "l0";
			root.addChild(new TreeCollectionEx(s1));
			
			var s2:Task = new Task();
			s2.name = "s2";
			s2.assignedTo = "l1";
			root.addChild(new TreeCollectionEx(s2));
			
			return root;
		}
		
		public function createFromText(text:String):Subway {
			var res:Subway = new Subway();
			var parse:Array = new ProjectParser().parse(text);
			var lineLabelMap:Object = new Object(); //lineName:Line
			for each (var parsedEntry:Object in parse) {
				var lines:Array = parsedEntry.groups;
				var stations:Array = new Array();
				for each (var lineLabel:String in lines) {
					var line:Line = getLine(res, lineLabelMap, lineLabel);
					var stationName:String = parsedEntry.label;
					var station:Station = line.addStation(new Station(stationName));
					stations.push(station);
				}
				if (stations.length>1) {
					//transfer stations
					res.markAsTransferStations(stations);
				}
			}
			return res;
		}
		
		private function getLine(subWay:Subway, lineLabelMap:Object, lineLabel:String):Line {
			if (lineLabelMap[lineLabel]==undefined) {
				var newLine:Line = new Line(lineLabel);
				lineLabelMap[lineLabel] = newLine;
				subWay.addLine(newLine);
			}
			return lineLabelMap[lineLabel];
		}
		
		public function createSubway3Stations2ts():Subway {
			var l0:Line = new LineFactory().createStations(3);
			var l1:Line = new LineFactory().createStations(3);
			var res:Subway = new Subway();
			res.addLines([l0, l1]);
			res.markAsTransferStations([l0.getStationAt(1), l1.getStationAt(1)]);
			res.markAsTransferStations([l0.getStationAt(2), l1.getStationAt(2)]);
			return res;
		}
		
		/**	
		 * 		s0 (l0)		\					/	s3 (l0)
		 * 						
		 * 		s1 (l1,l2)		-	s2(l0,l1,l2)	-	s4(l1)	
		 **/
		 public function createSubway3Lines():Subway {
			var res:Subway = new Subway();
			
			var l0:Line = new LineFactory().createStations(3);
			var l1:Line = new LineFactory().createStations(3);
			var l2:Line = new LineFactory().createStations(1);
			
			
			res.addLines([l0, l1, l2]);
			res.markAsTransferStations([l0.getStationAt(1), l1.getStationAt(1), l2.getStationAt(0)]);
			return res;
		}
		
		public function createSubway1():Subway {
			var res:Subway = new Subway();
			
			var l0:Line = new LineFactory().createStations(2);
			var l1:Line = new LineFactory().createStations(3);
			var l2:Line = new LineFactory().createStations(3);
			var l3:Line = new LineFactory().createStations(2);
			
			res.addLines([l0, l1, l2, l3]);
			var ts0:Station = res.markAsTransferStations([l0.getStationAt(0), l1.getStationAt(0), l2.getStationAt(2), l3.getStationAt(1)]);
			ts0.name = "0";
			var ts1:Station = res.markAsTransferStations([l0.getStationAt(1), l1.getStationAt(2)]);
			ts1.name = "1";
			return res;
		}
		
		public function createRandomSubway(numberOfStations:int):Subway {
			//create stations and assign them either to existing or a new line
			//create number of lines = numberOfStations/10
			var subWay:Subway = new Subway();
			var numberOfLines:int = numberOfStations/10;
			for (var i:int=0; i<numberOfLines; i++) {
				var line:Line = new Line();
				subWay.addLine(line);
			}
			
			for (i=0; i<numberOfStations; i++) {
				var lineIndex:Number = Math.floor(Math.random() * numberOfLines);
				line = subWay.getLineAt(lineIndex);
				line.addStation(new Station());
			}
			
			joinStations(subWay, numberOfStations/5, numberOfStations);
			return subWay;
		}
		
		private function joinStations(subWay:Subway, numberOfStationsToMakeTransferable:int, totalNumberOfStations:int):void {
			var iterators:Dictionary = new Dictionary();
			
			for each (var line:Line in subWay.lines) {
				var lineIterator:IIterator = line.createIterator();
				iterators[line] = lineIterator;
			}
			
			for (var i:int=0; i<totalNumberOfStations;) {
				var randomLine:Line = getRandomLine(subWay);
				var randomLineIterator:IIterator = iterators[randomLine];
				if (randomLineIterator.hasNext())
					randomLineIterator.next(); // advance 
				//calculate probability of joining stations
				var chanceOfJoining:Number = Math.random();
				
				if (chanceOfJoining>0.2) { 
					i++;
					continue;
				}
				else {
					
					//put random number of lines to join
					var linesToJoin:Array = new Array();
					var numberOfLinesToJoin:int = Math.floor(Math.random() * (subWay.numberOfLines-2)) + 2;
					var numberOfStationsToJoin:int = numberOfLinesToJoin;
					
					while (linesToJoin.length<numberOfLinesToJoin) {
						//add random lines
						randomLine = getRandomLine(subWay);
						if (linesToJoin.indexOf(randomLine)==-1)
							linesToJoin.push(randomLine);
					}
					
					//join stations
					var stationsToJoin:Array = new Array();
					for each (line in linesToJoin) {
						var it:IIterator = iterators[line];
						if (it.hasNext())
							stationsToJoin.push(it.next());
					}
					
					if (stationsToJoin.length>=2)
						subWay.markAsTransferStations(stationsToJoin);
					
					i+=numberOfStationsToJoin;
				}
			}
			
		}
		
		private function getRandomLine(subWay:Subway):Line {
			var randomLineIndex:int = Math.floor(Math.random()*subWay.numberOfLines);
			return subWay.getLineAt(randomLineIndex);
		}
		
	}
}