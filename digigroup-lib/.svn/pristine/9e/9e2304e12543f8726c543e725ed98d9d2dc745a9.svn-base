package actions
{
	public class VariableSuccessSyncAction extends AbstractAction
	{
		public static var failExecutionsWhenCounterIs:Array = [];
		internal static var counter:int = -1;
		public var result:String = "not done";
		
		public function VariableSuccessSyncAction(name:String="VariableSuccessSyncAction") {
			super(name);
		}
		
		protected override function doExecute():void {
			counter++;
			if (shouldFail()) {
				this.fail();
			}
			else {
				result = "done";
				this.setCompleted();
			}
			
		}
		
		private function shouldFail():Boolean {
			for each (var failIndex:int in failExecutionsWhenCounterIs) {
				if (failIndex==counter)
					return true;
			}
			return false;
		}
		
		public static function resetCounter():void {
			counter=-1;
		}
	}
}