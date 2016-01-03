package factories {
	import collections.TreeCollectionEx;

	import mx.utils.ObjectUtil;

	import vos.Task;

	public class ControlObjectsTreeFactory extends TreeFactory {
		/**@return
		 * input:
		 * task group, priority:3
		 *     task1, priority:3, eh:2
		 *     task2, priority:2, eh:1
		 *
		 * output:
		 * task group, priority:3, time:3, ptRatio:1
		 *     task1: priority:3, eh:2, time:2, ptRatio:1.5
		 *     task2, priority:2, eh:1, time:1, ptRatio:2
		 *
		 * outputSortedByPtRatio:
		 * task group, priority:3, time:3, ptRatio:1
		 *     task2, priority:2, eh:1, time:1, ptRatio:2
		 *     task1: priority:3, eh:2, time:2, ptRatio:1.5
		 **/
		public function testCase_2TaskTree():Object {
			var input:TreeCollectionEx = new TreeCollectionEx();
			var taskGroup:Task = new Task().setName("task group").setPriority(3);
			var task1:Task = new Task().setName("task1").setPriority(3).setEstimatedHours(2);
			var task2:Task = new Task().setName("task2").setPriority(2).setEstimatedHours(1);
			input.vo = taskGroup;
			input.addChildren([ new TreeCollectionEx(task1), new TreeCollectionEx(task2)]);


			var output:TreeCollectionEx = new TreeCollectionEx();
			var outputTaskGroup:Task = new Task().setName("task group").setPriority(3);
			outputTaskGroup.time = 3;
			outputTaskGroup.ptRatio = 1;
			var outputTask1:Task = new Task().setName("task1").setPriority(3).setEstimatedHours(2);
			outputTask1.time = 2;
			outputTask1.ptRatio = 1.5;
			output.vo = outputTaskGroup;
			var outputTask2:Task = new Task().setName("task2").setPriority(2).setEstimatedHours(1);
			outputTask2.time = 1;
			outputTask2.ptRatio = 2;
			output.addChildren([ new TreeCollectionEx(outputTask1), new TreeCollectionEx(outputTask2)]);

			var outputSortedByPtRatio:TreeCollectionEx = TreeCollectionEx(output.clone());
			var task2Node:TreeCollectionEx = TreeCollectionEx(outputSortedByPtRatio.children.removeItemAt(1));
			outputSortedByPtRatio.children.addItemAt(task2Node, 0);

			return { input: input, output: output, outputSortedByPtRatio: outputSortedByPtRatio };
		}

		/**
		 *  input:
		 *  1, priority:1
		 * 		2, priority:2
		 * 			3, priority:1, eh:1
		 * 			4, priority:2, eh:2
		 * 			5, priority:4, eh:1
		 * 		6, priority:2, eh:3
		 *
		 *  outputSortedByPtRatio:
		 *  1, priority:1, time:7, ptRatio:1/7
		 * 		6, priority:2, eh:3, time:3, ptRatio:0.67
		 * 		2, priority:2, time:4, ptRatio:0.5
		 * 			5, priority:4, eh:1, time:1, ptRatio:4
		 * 			3, priority:1, eh:1, time:1, ptRatio:3
		 * 			4, priority:2, eh:2, time:2, ptRatio:2
		 **/
		public function testCase_6TaskNodeTree():Object {
			var task1:Task = new Task().setName("1").setPriority(1);
			var task2:Task = new Task().setName("2").setPriority(2);
			var task3:Task = new Task().setName("3").setPriority(1).setEstimatedHours(1);
			var task4:Task = new Task().setName("4").setPriority(2).setEstimatedHours(2);
			var task5:Task = new Task().setName("5").setPriority(4).setEstimatedHours(1);
			var task6:Task = new Task().setName("6").setPriority(2).setEstimatedHours(3);

			var task1Node:TreeCollectionEx = new TreeCollectionEx(task1);
			var task2Node:TreeCollectionEx = new TreeCollectionEx(task2);
			var task3Node:TreeCollectionEx = new TreeCollectionEx(task3);
			var task4Node:TreeCollectionEx = new TreeCollectionEx(task4);
			var task5Node:TreeCollectionEx = new TreeCollectionEx(task5);
			var task6Node:TreeCollectionEx = new TreeCollectionEx(task6);
			task2Node.addChildren([ task3Node, task4Node, task5Node ]);
			task1Node.addChildren([ task2Node, task6Node ]);

			var outputTask1Node:TreeCollectionEx = TreeCollectionEx(task1Node.clone(false));
			var outputTask1:Task = Task(outputTask1Node.vo);
			outputTask1.time = 7;
			outputTask1.ptRatio = 1 / 7 as Number;

			var outputTask2Node:TreeCollectionEx = TreeCollectionEx(task6Node.clone(false));
			var outputTask2:Task = Task(outputTask2Node.vo);
			outputTask2.time = 3;
			outputTask2.ptRatio = 2 / 3 as Number;

			var outputTask3Node:TreeCollectionEx = TreeCollectionEx(task2Node.clone(false));
			var outputTask3:Task = Task(outputTask3Node.vo);
			outputTask3.time = 4;
			outputTask3.ptRatio = 0.5;

			var outputTask4Node:TreeCollectionEx = TreeCollectionEx(task5Node.clone(false));
			var outputTask4:Task = Task(outputTask4Node.vo);
			outputTask4.time = 1;
			outputTask4.ptRatio = 4;

			var outputTask5Node:TreeCollectionEx = TreeCollectionEx(task3Node.clone(false));
			var outputTask5:Task = Task(outputTask5Node.vo);
			outputTask5.time = 1;
			outputTask5.ptRatio = 3;

			var outputTask6Node:TreeCollectionEx = TreeCollectionEx(task4Node.clone(false));
			var outputTask6:Task = Task(outputTask6Node.vo);
			outputTask6.time = 2;
			outputTask6.ptRatio = 2;

			outputTask1Node.addChildren([ outputTask2Node, outputTask3Node ]);
			outputTask3Node.addChildren([ outputTask4Node, outputTask5Node, outputTask6Node ]);

			return { input: task1Node, outputSortedByPtRatio: outputTask1Node };
		}
	}
}
