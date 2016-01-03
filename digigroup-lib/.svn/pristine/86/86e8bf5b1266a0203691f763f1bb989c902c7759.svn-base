package mindmaps2.elements.ui {
	import commonutils.ClassInspector;

	import flash.utils.Dictionary;

	import vos.*;

	public class ElementEditorFactory {

		public function ElementEditorFactory() {
			initializeMap();
		}

		private var elementToEditorMap:Dictionary = new Dictionary(true);

		private const ci:ClassInspector = new ClassInspector();

		private var elementToEditorMappings:Array = [[ Note, NoteEditor ],
			[ Task, TaskEditor ],
			[ Appointment, AppointmentEditor ],
			[ Contact, ContactEditor ],
			[ Iteration, IterationEditor ]];

		public function createEditorFor(element:Object):ElementEditorTemplate {
			var res:ElementEditorTemplate = null;
			var elementClass:Class = ci.getClass(element);
			var editorClass:Class = elementToEditorMap[elementClass];

			if (editorClass != null)
				res = new editorClass();
			return res;
		}

		private function initializeMap():void {
			for each (var mapping:Array in elementToEditorMappings) {
				elementToEditorMap[mapping[0]] = mapping[1];
			}
		}
	}
}
