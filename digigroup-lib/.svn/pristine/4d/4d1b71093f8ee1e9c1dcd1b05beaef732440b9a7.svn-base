package mindmaps.map {
	import actions.AbstractAction;
	import actions.AbstractUserAction;

	import vos.*;

	public class TestMapContextFactory extends MapContextFactory {
		public function TestMapContextFactory() {
			super();
		}

		public function createTaskAppointment():MapContext {
			var elementTypes:Array = [ Task, Appointment ];
			var res:MapContext = new MapContext(elementTypes);
			return res;
		}

		public function createTaskAndActions():MapContext {
			var elementTypes:Array = [ Task ];
			var res:MapContext = new MapContext(elementTypes);
			return res;
		}

		public function createRootAction():MapContext {
			var elementTypes:Array = [ Task ];
			var res:MapContext = new MapContext(elementTypes);
			return res;
		}
	}
}
