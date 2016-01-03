package mindmaps.importexport.task {
	import assertions.*;

	import collections.IPluggableObject;

	import commonutils.MinutePrecisionTimeSpan;
	import commonutils.TimeSpan;
	import commonutils.TimeSpanFormatter;

	import mindmaps.importexport.IElementExporter;

	import mx.utils.StringUtil;

	import vos.Task;

	public class TaskExporter implements IElementExporter {

		private static const timeSpanFormatter:TimeSpanFormatter = new TimeSpanFormatter();

		public function TaskExporter() {
		}

		public function export(element:IPluggableObject):String {
			Require.instanceOf(element, Task, "element");

			var result:String = "";
			var task:Task = Task(element);
			var priority:String = task.priority > 0 ? "R" + task.priority.toString() + " " : "";
			var reviewed:String = task.reviewed ? "r" : "";
			var done:String = task.done == 1 ? "x" : "";
			var committed:String = task.committed ? "c" : "";
			var taskName:String = task.name != null ? task.name : "";
			var assignedTo:String = task.assignedTo != null ? getAssignedTo(task.assignedTo) + " " : "";

			var estimatedHoursFormattedString:String = !isNaN(task.estimatedHours) ? timeSpanFormatter.format(MinutePrecisionTimeSpan.fromHours(task.estimatedHours)) : "";
			var actualHoursFormattedString:String = !isNaN(task.actualHours) ? "/" + timeSpanFormatter.format(MinutePrecisionTimeSpan.fromHours(task.actualHours)) : "";
			result = StringUtil.substitute("{0}{1}{2}{3} {4} {5}{6}{7}", priority, reviewed, done,
				committed, taskName, assignedTo, estimatedHoursFormattedString, actualHoursFormattedString);
			result = StringUtil.trim(result);
			return result;
		}

		private function getAssignedTo(assignedTo:String):String {
			var result:String = StringUtil.trim(assignedTo);
			var matches:Array = result.match(",");
			if (matches == null && result.length > 0) {
				result += ",";
			}
			return result;
		}
	}
}
