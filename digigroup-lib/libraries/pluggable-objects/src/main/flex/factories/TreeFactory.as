package factories {
	import collections.*;
	import collections.tree.*;

	import commonutils.ClassInspector;

	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.utils.StringUtil;

	import vos.*;

	public class TreeFactory {

		public static function createNode(voType:Class):TreeCollectionEx {

			return new TreeCollectionEx(createVo(voType));
		}

		public static function createVo(voType:Class, index:int = 0):* {
			var ci:ClassInspector = new ClassInspector();
			var cf:ClassFactory = new ClassFactory(voType);
			var vo:* = cf.newInstance();
			vo.name = StringUtil.substitute("{0}", ci.getClassName(vo, true).toLowerCase());
			if (index > 0)
				vo.name += " " + index;
			return vo;
		}

		public function create1Node(name:Boolean = false):TreeCollectionEx {
			var res:TreeCollectionEx = new TreeCollectionEx();
			if (name) {
				res.vo = new Task();
				res.vo.name = "1";
			}
			return res;
		}

		public function createParentNChildren(n:int, name:Boolean = false):TreeCollectionEx {
			var res:TreeCollectionEx = create1Node(name);
			addNChildren(res, n, name);
			return res;
		}

		/*
		public function createMap1():TreeCollectionEx
		{
			var b1:TreeCollectionEx = createParentNChildren(3);
			var a1:TreeCollectionEx = createParentNChildren(2);
			a1.addChild(b1);
			var a2:TreeCollectionEx = createParentNChildren(2);
			var res:TreeCollectionEx = new TreeCollectionEx();
			res.addChild(a1);
			res.addChild(b1);
			return res;
		}
		*/
		public function createBinaryFullTree_3Levels():TreeCollectionEx {
			var res:TreeCollectionEx = new TreeCollectionEx();
			var b1:TreeCollectionEx = createParentNChildren(2);
			var b2:TreeCollectionEx = createParentNChildren(2);
			res.addChild(b1);
			res.addChild(b2);
			return res;
		}

		public function createFullTree(numNodesInBranch:int, depth:int,
			res:TreeCollectionEx = null):TreeCollectionEx {
			if (res == null)
				res = new TreeCollectionEx();
			if (depth == 1)
				return null;
			addNChildren(res, numNodesInBranch);
			for each (var child:TreeCollectionEx in res.children)
				createFullTree(numNodesInBranch, depth - 1, child);
			return res;
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

		public function createFullTree_3Levels(num1:int, num2:int):TreeCollectionEx {
			var res:TreeCollectionEx = new TreeCollectionEx();
			for (var i:int = 0; i < num1; i++)
				res.addChild(new TreeCollectionEx());
			for each (var child:TreeCollectionEx in res.children)
				for (i = 0; i < num2; i++)
					child.addChild(new TreeCollectionEx());
			return res;
		}

		public function createRandomTree(numNodes:int):TreeCollectionEx {
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

		public function createRandomTaskTree(numNodes:int, useNodeIndexAsLabel:Boolean = true):TreeCollectionEx {
			var res:TreeCollectionEx = createRandomTree(numNodes);
			var it:IIterator = res.createIterator();

			var nodeIndex:int = 1;
			while (it.hasNext()) {
				var cur:TreeCollectionEx = TreeCollectionEx(it.next());
				var task:Task = new Task();
				task.name = useNodeIndexAsLabel ? nodeIndex.toString() : "task";

				var r:Number = Math.random();
				var priority:int = Math.floor(r * 10);
				var done:int = (r > (1 / 4)) ? 1 : 0;
				task.priority = priority;
				task.done = done;

				cur.vo = task;
				nodeIndex++;
			}
			return res;
		}

		/**      2
		 *      /    4
		 *    /    /
		 *  1 -- 3
		 *    \     \
		 *      \    5
		 *       6
		 *
		 */
		public function createTree2():TreeCollectionEx {
			var res:TreeCollectionEx = new TreeCollectionEx();
			res.addChild(new TreeCollectionEx());
			var b1:TreeCollectionEx = new TreeCollectionEx();
			addNChildren(b1, 2);
			res.addChild(b1);
			res.addChild(new TreeCollectionEx());
			return res;
		}

		/*
		public function create1NodeCollection():TreeCollectionEx
		{
			//TreeCollectionEx.counter = 0;
			var task:Task = new Task();
			task.name = "Everything";
			task.priority = 1;
			var root:TreeCollectionEx = new TreeCollectionEx(task);
			return root;
		}
		*/

		public function create1NodeCollection_Appointment():TreeCollectionEx {
			//TreeCollectionEx.counter = 0;
			var appt:Appointment = new Appointment();
			appt.name = "Appointment1";
			var root:TreeCollectionEx = new TreeCollectionEx(appt);
			return root;
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

		public function createAllElements():TreeCollectionEx {
			var allItems:Item = new Item();
			allItems.name = "all items";
			var allItemsNode:TreeCollectionEx = new TreeCollectionEx(allItems);

			var item:Item = new Item();
			item.name = "Item";
			allItemsNode.addChild(new TreeCollectionEx(item));

			var note:Note = new Note();
			note.name = "Note";
			allItemsNode.addChild(new TreeCollectionEx(note));

			var task:Task = new Task();
			task.name = "Task";
			allItemsNode.addChild(new TreeCollectionEx(task));

			var contact:Contact = new Contact();
			contact.name = "Contact";
			allItemsNode.addChild(new TreeCollectionEx(contact));

			var appointment:Appointment = new Appointment();
			appointment.name = "Appointment";
			allItemsNode.addChild(new TreeCollectionEx(appointment));

			var program:Program = new Program();
			program.name = "Program";
			allItemsNode.addChild(new TreeCollectionEx(program));

			return allItemsNode;
		}

		//     A0
		//  B0   C1
		//  D2   E1
		public function createTaskTree2():TreeCollectionEx {
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
			task.priority = 1;
			var taskC:TreeCollectionEx = taskA.addCollectionItem(task);

			task = new Task();
			task.name = "D";
			task.priority = 2;
			var taskD:TreeCollectionEx = taskB.addCollectionItem(task);

			task = new Task();
			task.name = "E";
			task.priority = 1;
			var taskE:TreeCollectionEx = taskC.addCollectionItem(task);
			return taskA;
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

		//            					  (0, p0, r0)
		//     			(1A, p1, r100)          					(1B, p2, r200)
		//	(2A, p2, r120)  		(2B, p3, r130)     		(2C, p1, r210)  (2D, p2, r220)
		//    			(3A, p1, r121)   (3B, p2, r132)  
		public function createPriorityTaskTree2WithRanks():TreeCollectionEx {
			var res:TreeCollectionEx = createPriorityTaskTree2();
			return res;
		}

		//task:Everything
		public function create1NodeCollection():TreeCollectionEx {
			var task:Task = new Task();
			task.name = "Everything";
			task.priority = 1;
			var root:TreeCollectionEx = new TreeCollectionEx(task);
			return root;
		}

		//task:Everything
		//	task:Project1
		public function createParentChildCollection():TreeCollectionEx {
			var root:TreeCollectionEx = TreeCollectionEx(create1NodeCollection());

			var task2:Task = new Task();
			task2.name = "Project1";
			task2.priority = 2;
			var child:TreeCollectionEx = new TreeCollectionEx(task2);
			root.addChild(child);
			return root;
		}



		public function createSimplePrologProgram():TreeCollectionEx {
			var program:Program = new Program();
			program.name = "prolog program";
			program.text = "member(X,[X|V1]).\nmember(X, [V1|Tail]):-member(X, Tail).";
			return new TreeCollectionEx(program);
		}

		public function createParentChildCollectionIncludingProgram():TreeCollectionEx {
			var root:TreeCollectionEx = createParentChildCollection();
			var program:TreeCollectionEx = createSimplePrologProgram();
			root.addChild(program);
			return root;
		}

		/** Everything
		 * 		Project1
		 * 			Task1
		 * 			Appointment1
		 * 		Project2
		 *  Preorder traversal: Everything, Project1, Task1, Appointment1, Project2
		 **/
		public function createSimpleCollection():TreeCollectionEx {
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

		}

		//Appointment1
		//	Project2
		public function createTaskAppointment():TreeCollectionEx {

			var appointment1:Appointment = new Appointment();
			appointment1.name = "Appointment1";
			appointment1.location = "Location1";
			var root:TreeCollectionEx = new TreeCollectionEx(appointment1);

			var project2:Task = new Task();
			project2.name = "Project2";
			project2.priority = 5;
			var project2Node:TreeCollectionEx = new TreeCollectionEx(project2);
			project2Node.addChild(root);
			return project2Node;

		}

		private function addNChildren(parent:TreeCollectionEx, n:int, name:Boolean = false):void {
			for (var i:int = 0; i < n; i++) {
				var child:TreeCollectionEx = new TreeCollectionEx();
				if (name) {
					child.vo = new Task();
					child.vo.name = i + 2;
				}
				parent.addChild(child);
			}
		}
	}
}
