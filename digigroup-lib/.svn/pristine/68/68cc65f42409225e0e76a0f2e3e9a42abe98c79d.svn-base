package classes {
	import collections.*;

	import commonutils.ClassInspector;

	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.utils.StringUtil;

	public class TreeFactory {

		private static function createVo(voType:Class, index:int = 0):* {
			var ci:ClassInspector = new ClassInspector();
			var cf:ClassFactory = new ClassFactory(voType);
			var vo:* = cf.newInstance();
			vo.name = StringUtil.substitute("{0}", ci.getClassName(vo, true).toLowerCase());
			if (index > 0)
				vo.name += " " + index;
			return vo;
		}

		public function create1NodeCollectionXml_1_0():XML {
			var res:XML = <graph version="1.0">
					<node id="1">
						<data>
							<Task name="Everything" priority="1" />
						</data>
					</node>
				</graph>;
			return res;
		}

		public function createTaskData():XML {
			var res:XML = <Task>
					<name>Everything</name>
					<priority>1</priority>
				</Task>;
			return res;
		}

		public function create1NodeCollectionXml(version:Number):XML {
			var res:XML = <graph version="0">
					<node id="1">
						<data>
							{createTaskData()}
						</data>
					</node>
				</graph>;
			res.@version = version;
			return res;
		}

		public function create1NodeCollectionXml_1_1():XML {
			return create1NodeCollectionXml(1.1);
		}

		public function createEmptyCollectionXml():XML {
			var res:XML = <graph>
				</graph>;
			return res;
		}

		public function createParentChildCollectionXml():XML {
			var res:XML = <graph version="1.0">
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

		public function createSimpleCollectionXml():XML {
			var res:XML = <graph version="1.0">
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

		//Everything (1)
		public function create1NodeCollection():TreeCollectionEx {
			var task:Task = new Task();
			task.name = "Everything";
			task.priority = 1;
			var root:TreeCollectionEx = new TreeCollectionEx(task);
			root.id = 1;
			return root;
		}

		//Everything (1)
		//  Project1 (2)
		public function createParentChildCollection():TreeCollectionEx {
			var root:TreeCollectionEx = create1NodeCollection();

			var task2:Task = new Task();
			task2.name = "Project1";
			task2.priority = 2;
			var child:TreeCollectionEx = new TreeCollectionEx(task2);
			child.id = 2;
			root.addChild(child);
			return root;
		}

		//Everything (1)
		//	Project1 (2)
		//		Task1 (3)
		//		Appointment1 (4)
		//	Project2 (5)
		public function createSimpleCollection():TreeCollectionEx {
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

		/*
		var root:TreeCollectionEx = TreeCollectionEx(createParentChildCollection());

		var task1:Task = new Task();
		task1.name = "Task1";
		task1.priority = 3;
		var task1Node:TreeCollectionEx = new TreeCollectionEx(task1);
		root.children[0].addChild(task1Node);

		var appointment1:Appointment = new Appointment();
		appointment1.name = "Appointment1";
		appointment1.location = "Location1";
		var appointment1Node:TreeCollectionEx = new TreeCollectionEx(appointment1);
		root.children[0].addChild(appointment1Node);

		var project2:Task = new Task();
		project2.name = "Project2";
		project2.priority = 5;
		var project2Node:TreeCollectionEx = new TreeCollectionEx(project2);
		root.addChild(project2Node);
		return root;
		*/
		}


		/**
		 *
		 * @return
		 *
		 *     2 - 3
		 *   /
		 * 1       5
		 *   \   /
		 *     4
		 *       \
		 *         6
		 */
		public function createTree1():TreeCollectionEx {
			var res:TreeCollectionEx = new TreeCollectionEx();
			res.id = 1;
			var b0:TreeCollectionEx = new TreeCollectionEx();
			b0.id = 2;
			var b0child:TreeCollectionEx = new TreeCollectionEx();
			b0child.id = 3;
			b0.addChild(b0child);
			var b1:TreeCollectionEx = new TreeCollectionEx();
			b1.id = 4;
			addNChildren(b1, 2);
			b1.children[0].id = 5;
			b1.children[1].id = 6;
			res.addChild(b0);
			res.addChild(b1);
			return res;
		}

		public function createParentNChildren(n:int, name:Boolean = false):TreeCollectionEx {
			var res:TreeCollectionEx = create1Node(name);
			addNChildren(res, n, name);
			return res;
		}

		public function create1Node(name:Boolean = false):TreeCollectionEx {
			var res:TreeCollectionEx = new TreeCollectionEx();
			if (name) {
				res.vo = "Task";
				res.vo.name = "1";
			}
			return res;
		}

		public function createBinaryFullTree_3Levels():TreeCollectionEx {
			var res:TreeCollectionEx = new TreeCollectionEx();
			var b1:TreeCollectionEx = createParentNChildren(2);
			var b2:TreeCollectionEx = createParentNChildren(2);
			res.addChild(b1);
			res.addChild(b2);
			return res;
		}

		public function createFullTree_3Levels(num1:int, num2:int):TreeCollectionEx {
			var res:TreeCollectionEx = new TreeCollectionEx();
			for (var i:int = 0; i < num1; i++)
				res.addChild(new TreeCollectionEx());
			for each (var child:TreeCollectionEx in res.children)
				for (i = 0; i < num2; i++)
					child.addChild(new TreeCollectionEx());
			return res;
		}

		public function create1NodeCollection_Appointment():TreeCollectionEx {
			//TreeCollectionEx.counter = 0;
			var appt:Appointment = new Appointment();
			appt.name = "Appointment1";
			var root:TreeCollectionEx = new TreeCollectionEx(appt);
			return root;
		}

		//              0
		//     1A(1)           1B(2)
		//2A(2)  2B(3)      2C(1)   2D(2)
		//    3A(1)   3B(2)
		//output of sorting based on hierarchical priorities: 2D, 2C, 3B, 3A, 2A
		public function createPriorityTaskTree2():TreeCollectionEx {
			var res:TreeCollectionEx = createPriorityTaskTree();

			var task:Task = new Task();
			task.name = "2D";
			task.priority = 2;
			TreeCollectionEx(res.children[1]).addCollectionItem(task);
			;

			task = new Task();
			task.name = "3A";
			task.priority = 1;
			TreeCollectionEx(res.children[0].children[1]).addCollectionItem(task);
			;

			task = new Task();
			task.name = "3B";
			task.priority = 2;
			TreeCollectionEx(res.children[0].children[1]).addCollectionItem(task);
			;

			return res;
		}

		//              0(0)
		//     1A(1)        1B(2)
		//2A(2)  2B(3)      2C(1)
		//output of sorting based on hierarchical priorities: 2C, 2B, 2A
		public function createPriorityTaskTree():TreeCollectionEx {
			var task:Task = new Task();
			task.name = "0";
			var res:TreeCollectionEx = new TreeCollectionEx();
			res.vo = task;

			task = new Task();
			task.name = "1A";
			task.priority = 1;
			var task1A:TreeCollectionEx = res.addCollectionItem(task);

			task = new Task();
			task.name = "1B";
			task.priority = 2;
			var task1B:TreeCollectionEx = res.addCollectionItem(task);

			task = new Task();
			task.name = "2A";
			task.priority = 2;
			task1A.addCollectionItem(task);

			task = new Task();
			task.name = "2B";
			task.priority = 3;
			task1A.addCollectionItem(task);
			;

			task = new Task();
			task.name = "2C";
			task.priority = 1;
			task1B.addCollectionItem(task);
			;

			return res;
		}

		//     A0
		//  B0   E1
		//C2 D3
		public function createParentChildHPTaskTree():TreeCollectionEx {
			var task:Task = new Task();
			task.name = "A";
			var taskA:TreeCollectionEx = new TreeCollectionEx();
			taskA.vo = task;

			task = new Task();
			task.name = "B";
			task.priority = 0;
			var taskB:TreeCollectionEx = taskA.addCollectionItem(task);

			task = new Task();
			task.name = "C";
			task.priority = 2;
			var taskC:TreeCollectionEx = taskB.addCollectionItem(task);

			task = new Task();
			task.name = "D";
			task.priority = 3;
			var taskD:TreeCollectionEx = taskB.addCollectionItem(task);

			task = new Task();
			task.name = "E";
			task.priority = 1;
			var taskE:TreeCollectionEx = taskA.addCollectionItem(task);
			return taskA;
		}

		public function createRandomVoTree(numNodes:int, types:Array, useNodeIndexAsLabel:Boolean = false):TreeCollectionEx {
			var res:TreeCollectionEx = createRandomTree(numNodes);
			var it:IIterator = res.createIterator();

			var nodeIndex:int = 1;
			while (it.hasNext()) {
				var cur:TreeCollectionEx = TreeCollectionEx(it.next());
				var r:Number = Math.random();
				var index:int = Math.floor(r * types.length);

				var voType:Class = types[index];
				var vo:* = createVo(voType, (useNodeIndexAsLabel) ? nodeIndex : 0);
				cur.vo = vo;
				nodeIndex++;

			}
			return res;
		}

		private function addNChildren(parent:TreeCollectionEx, n:int, name:Boolean = false):void {
			for (var i:int = 0; i < n; i++) {
				var child:TreeCollectionEx = new TreeCollectionEx();
				if (name) {
					child.vo = "Task";
					child.vo.name = i + 2;
				}
				parent.addChild(child);
			}
		}

		private function createRandomTree(numNodes:int):TreeCollectionEx {
			var a:ArrayCollection = new ArrayCollection();
			for (var i:int = 0; i < numNodes; i++)
				a.addItem(new TreeCollectionEx());
			while (a.length > 1) {
				var r:Number = Math.random();
				var index:int = Math.floor(r * a.length);
				var c:TreeCollectionEx = TreeCollectionEx(a.getItemAt(index));
				a.removeItemAt(index);
				var addIndex:int = Math.floor(r * a.length);
				a[addIndex].addChild(c);

			}
			return a[0];
		}
	}
}
