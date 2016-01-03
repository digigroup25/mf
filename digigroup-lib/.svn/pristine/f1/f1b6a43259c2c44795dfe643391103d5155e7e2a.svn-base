package mindmaps.importexport.iteration {
	import assertions.*;

	import collections.IPluggableObject;

	import commonutils.MinutePrecisionTimeSpan;
	import commonutils.TimeSpan;
	import commonutils.TimeSpanFormatter;

	import flash.globalization.DateTimeStyle;

	import mindmaps.importexport.IElementExporter;

	import mx.utils.StringUtil;

	import spark.formatters.DateTimeFormatter;

	import vos.Iteration;

	public class IterationExporter implements IElementExporter {

		private static const timeSpanFormatter:TimeSpanFormatter = new TimeSpanFormatter();

		private static const dateFormatter:DateTimeFormatter = new DateTimeFormatter();

		public function IterationExporter() {
			dateFormatter.dateStyle = DateTimeStyle.SHORT;
			dateFormatter.timeStyle = DateTimeStyle.NONE;
		}

		public function export(element:IPluggableObject):String {
			Require.instanceOf(element, Iteration, "element");

			var result:String = "";
			var iteration:Iteration = Iteration(element);
			var start:String = dateFormatter.format(iteration.start);
			var end:String = dateFormatter.format(iteration.end);
			result = StringUtil.substitute("{0} {1}-{2}", iteration.name, start, end);
			return result;
		}
	}
}
