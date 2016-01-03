package mindmaps.importexport {
	import commonutils.ClassInspector;

	import flash.utils.Dictionary;

	import mf.utils.ClassUtil;

	import mindmaps.importexport.iteration.IterationExporter;
	import mindmaps.importexport.task.TaskExporter;

	import vos.Iteration;
	import vos.Task;

	public class ElementExporterFactory {
		private static const ci:ClassInspector = new ClassInspector();

		public function ElementExporterFactory() {
			map = new Dictionary(true);
			map[Task] = { type: TaskExporter };
			map[Iteration] = { type: IterationExporter };
		}

		private var map:Dictionary;

		public function getExporter(element:Object):IElementExporter {
			var mapEntry:Object = map[ci.getClass(element)];
			if (mapEntry == null)
				return null;
			if (mapEntry.instance == null) {
				mapEntry.instance = new mapEntry.type();
			}
			return IElementExporter(mapEntry.instance);
		}
	}
}
