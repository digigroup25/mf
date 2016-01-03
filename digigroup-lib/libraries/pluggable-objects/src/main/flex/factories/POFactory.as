package factories
{
	import mx.collections.ArrayCollection;
	import collections.*;
	import vos.*;
	
	public class POFactory
	{
		public static function createTasks1():Array
		{
			var tasks:Array = new Array();
			
			var t1:Task = new Task();
			t1.name = "Task1";
			t1.priority = 2;
			t1.done = 0;
			t1.description = "b";
			tasks.push(t1);
			
			var t2:Task = new Task();
			t2.name = "Task2";
			t2.priority = 1;
			t2.done = 1;
			t2.date = new Date(2000, 0, 1);
			tasks.push(t2);
			
			var t3:Task = new Task();
			t3.name = "Task3";
			t3.description = "a";
			tasks.push(t3);
			
			var a1:Appointment = new Appointment();
			a1.name = "Appt1";
			a1.location = "Location1";
			tasks.push(a1);
			return tasks;
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
  			res.addChild(task);
  			
  			task = new Task();
			task.name = "A";
  			TreeCollectionEx(res.children[0]).addCollectionItem(task);;
  			
  			task = new Task();
			task.name = "D";
  			TreeCollectionEx(res.children[0]).addCollectionItem(task);;
  			
  			task = new Task();
			task.name = "C";
  			TreeCollectionEx(res.children[0].children[1]).addCollectionItem(task);;
  			
  			task = new Task();
			task.name = "E";
  			TreeCollectionEx(res.children[0].children[1]).addCollectionItem(task);;
  			
  			task = new Task();
			task.name = "G";
  			res.addChild(task);
  			
  			task = new Task();
			task.name = "I";
  			TreeCollectionEx(res.children[1]).addCollectionItem(task);;
  			
  			task = new Task();
			task.name = "H";
  			TreeCollectionEx(res.children[1].children[0]).addCollectionItem(task);;
  			
  			return res;
  		}
  		
  		
		
		
	}
}