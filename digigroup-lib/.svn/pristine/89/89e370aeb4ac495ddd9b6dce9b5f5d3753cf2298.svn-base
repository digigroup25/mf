package actions
{
	public class VariableSuccessSyncRepeatableAction extends AbstractRepeatableAction
	{
		public static var failExecutionsWhenCounterIs:Array = [];
		internal static var counter:int = -1;
		public var result:String = "not done";
		
		public function VariableSuccessSyncRepeatableAction(name:String="VariableSuccessSyncRepeatableAction", 
			repeat:int=3)
		{
			super(name, repeat);
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
			for each (var failIndex:uint in failExecutionsWhenCounterIs) {
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