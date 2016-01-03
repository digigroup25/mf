package mindmaps
{
	import collections.*;
	
	import mindmaps.elementderivatives.ProjectParser;
	import mindmaps.elementderivatives.ProjectTexts;
	
	import mx.containers.*;
	
	import vos.Task;
	
	public class TestTreeFactory
	{
		public function createData():TreeCollectionEx
		{
			var vo:Task = new Task();
			vo.name = "abc";
			var d:TreeCollectionEx = new TreeCollectionEx(vo);
			return d;
		}
		
		public function tasksFromSampleProject():TreeCollectionEx {
			return tasksFromProject(ProjectTexts.sampleProject.text);
		}
		
		public function tasksFromSampleProjectSnippet():TreeCollectionEx {
			return tasksFromProject(ProjectTexts.sampleProjectSnippet.text);
		}
		
		private function tasksFromProject(text:String):TreeCollectionEx {
			var parsedTasks:Array = new ProjectParser().parse(text);
			
			var rootTask:Task = new Task();
			rootTask.name = "Sample Software Project";
			var root:TreeCollectionEx = new TreeCollectionEx(rootTask);
			
			for each (var parsedTask:Object in parsedTasks) {
				var task:Task = new Task();
				task.name = parsedTask.label;
				task.assignedTo = parsedTask.groups;
				var node:TreeCollectionEx = new TreeCollectionEx(task);
				root.addChild(node);
			}
			
			return root;
		}
	}
}