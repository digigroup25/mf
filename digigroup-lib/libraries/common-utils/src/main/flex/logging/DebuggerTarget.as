package logging {
	import com.demonsters.debugger.MonsterDebugger;

	import mx.logging.AbstractTarget;
	import mx.logging.LogEvent;

	public class DebuggerTarget extends AbstractTarget {
		public static const SEPARATOR:String = "\t\t";

		private var debugger:MonsterDebugger;

		override public function initialized(document:Object, id:String):void {
			super.initialized(document, id);
			//filters = [ "com.*" ];

			MonsterDebugger.initialize(document);
		}

		override public function logEvent(event:LogEvent):void {
			var level:String = "[" + LogEvent.getLevelString(event.level) + "]";

			var category:String = event.target.category;

			MonsterDebugger.trace(event.target, [ level, category, event.message ].join(SEPARATOR));
		}
	}
}
