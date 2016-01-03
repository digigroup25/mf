package classes
{
	import mx.collections.ArrayCollection;
	import collections.*;
	
	public class VOFactory
	{
		/*
		public static function create1NodeCollection():TreeCollectionEx
		{
			var task:Task = new Task();
			task.name = "Everything";
			task.priority = 1;
			var root:TreeCollectionEx = new TreeCollectionEx(task);
			root.id = 1;
			return root;
		}
		
		public static function create1NodeCollectionXml_1_0():XML
		{
			var res:XML = 
			<graph version="1.0">
				<node id="1">
					<data>
						<Task name="Everything" priority="1" />
					</data>
				</node>
			</graph>;
			return res;
		}
		
		public static function create1NodeCollectionXml_1_1():XML
		{
			var res:XML = 
			<graph version="1.1">
				<node id="1">
					<data>
						<Task>
							<name>Everything</name>
							<priority>1</priority>
						</Task>
					</data>
				</node>
			</graph>;
			return res;
		}
		
		public static function createEmptyCollectionXml():XML
		{
			var res:XML = 
			<graph>
			</graph>;
			return res;
		}
		
		public static function createParentChildCollection():TreeCollectionEx
		{
			var root:TreeCollectionEx = create1NodeCollection();
			
			var task2:Task = new Task();
			task2.name = "Project1";
			task2.priority = 2;
			var child:TreeCollectionEx = new TreeCollectionEx(task2);
			child.id = 2;
			root.addChild(child);
			return root;
		}
		
		
		public static function createParentChildCollectionXml():XML
		{
			var res:XML = 
			<graph version="1.0">
				<node id="1">
					<data>
						<Task name="Everything" priority="1" />
					</data>
					<relations>
						<relation targetNodeId="2" type="child"/>
					</relations>
				</node>
				<node id="2">
					<data>
						<Task name="Project1" priority="2" />
					</data>
				</node>
			</graph>;
			return res;
		}
		
		//Everything
		//	Project1
		//		Task1
		//		Appointment1
		//	Project2
		public static function createSimpleCollection():TreeCollectionEx
		{
			//TreeCollectionEx.counter = 0;
			var root:TreeCollectionEx = createParentChildCollection();
			
			var task1:Task = new Task();
			task1.name = "Task1";
			task1.priority = 3;
			var task1Node:TreeCollectionEx = new TreeCollectionEx(task1);
			task1Node.id = 3;
			root.children[0].addChild(task1Node);
			
			var appointment1:Appointment = new Appointment();
			appointment1.name = "Appointment1";
			appointment1.location = "Location1";
			var appointment1Node:TreeCollectionEx = new TreeCollectionEx(appointment1);
			appointment1Node.id = 4;
			root.children[0].addChild(appointment1Node);
			
			var project2:Task = new Task();
			project2.name = "Project2";
			project2.priority = 5;
			var project2Node:TreeCollectionEx = new TreeCollectionEx(project2);
			project2Node.id = 5;
			root.addChild(project2Node);
			return root;
		}
		
		public static function createSimpleCollectionXml():XML
		{
			var res:XML = 
			<graph version="1.0">
				<node id="1">
					<data>
						<Task name="Everything" priority="1" />
					</data>
					<relations>
						<relation targetNodeId="2" type="child"/>
						<relation targetNodeId="5" type="child"/>
					</relations>
				</node>
				<node id="2">
					<data>
						<Task name="Project1" priority="2" />
					</data>
					<relations>
						<relation targetNodeId="3" type="child"/>
						<relation targetNodeId="4" type="child"/>
					</relations>
				</node>
				<node id="3">
					<data>
						<Task name="Task1" priority="3" />
					</data>
				</node>
				<node id="4">
					<data>
						<Appointment name="Appointment1" location="Location1"/>
					</data>
				</node>
				<node id="5">
					<data>
						<Task name="Project2" priority="5" />
					</data>
				</node>
			</graph>;
			return res;
		}
		
		//   0
		// 1A 1B
		//2A
		public static function createParentChildTaskTree():TreeCollectionEx
		{
			var task:Task = new Task();
			task.name = "0";
  			var task1:TreeCollectionEx = new TreeCollectionEx();
  			task1.vo = task;
  			
  			task = new Task();
  			task.name = "1A";
  			task.priority = 1;
  			var task2:TreeCollectionEx = task1.addCollectionItem(task);
  			
  			task = new Task();
  			task.name = "1B";
  			task.priority = 2;
  			var task3:TreeCollectionEx = task1.addCollectionItem(task);
  			
  			task = new Task();
  			task.name = "2A";
  			task.priority = 2;
  			var task4:TreeCollectionEx = task2.addCollectionItem(task);
  			return task1;
		}
		
		//              0
		//     1A(1)        1B(2)
		//2A(2)  2B(3)      2C(1)
		//output of sorting based on hierarchical priorities: 2C, 2B, 2A
		public static function createPriorityTaskTree():TreeCollectionEx
		{
			var res:TreeCollectionEx = createParentChildTaskTree();
			
			var task:Task = new Task();
			task.name = "2B";
			task.priority = 3;
  			TreeCollectionEx(res.children[0]).addCollectionItem(task);
  			
  			task = new Task();
			task.name = "2C";
			task.priority = 1;
  			TreeCollectionEx(res.children[1]).addCollectionItem(task);
  			
  			return res;
  		}
  		
  		//              0
		//     1A(1)           1B(2)
		//2A(2)  2B(3)      2C(1)   2D(2)
		//    3A(1)   3B(2)  
		//output of sorting based on hierarchical priorities: 2D, 2C, 3B, 3A, 2A
		public static function createPriorityTaskTree2():TreeCollectionEx
		{
			var res:TreeCollectionEx = createPriorityTaskTree();
			
			var task:Task = new Task();
			task.name = "2D";
			task.priority = 2;
  			TreeCollectionEx(res.children[1]).addCollectionItem(task);
  			
  			task = new Task();
			task.name = "3A";
			task.priority = 1;
  			TreeCollectionEx(res.children[0].children[1]).addCollectionItem(task);
  			
  			task = new Task();
			task.name = "3B";
			task.priority = 2;
  			TreeCollectionEx(res.children[0].children[1]).addCollectionItem(task);
  			
  			return res;
  		}
  		
  		//                F
		//        B                G
		//    A       D              I
		//          C   E          H   
		public static function createBinaryTree():TreeCollectionEx
		{
			var task:Task = new Task();
			task.name = "F";
  			var res:TreeCollectionEx = new TreeCollectionEx();
  			res.vo = task;
  			
  			task = new Task();
			task.name = "B";
  			res.addCollectionItem(task);
  			
  			task = new Task();
			task.name = "A";
  			TreeCollectionEx(res.children[0]).addCollectionItem(task);
  			
  			task = new Task();
			task.name = "D";
  			TreeCollectionEx(res.children[0]).addCollectionItem(task);
  			
  			task = new Task();
			task.name = "C";
  			TreeCollectionEx(res.children[0].children[1]).addCollectionItem(task);
  			
  			task = new Task();
			task.name = "E";
  			TreeCollectionEx(res.children[0].children[1]).addCollectionItem(task);
  			
  			task = new Task();
			task.name = "G";
  			res.addCollectionItem(task);
  			
  			task = new Task();
			task.name = "I";
  			TreeCollectionEx(res.children[1]).addCollectionItem(task);
  			
  			task = new Task();
			task.name = "H";
  			TreeCollectionEx(res.children[1].children[0]).addCollectionItem(task);
  			
  			return res;
  		}
  		*/
	}
}