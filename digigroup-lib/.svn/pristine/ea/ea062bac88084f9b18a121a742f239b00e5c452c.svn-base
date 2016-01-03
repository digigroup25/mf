package mf.framework
{

	public final class Container2Fake extends Container2
	{
		public var numDoInitializeExecuted:int = 0;
		public var numDoUninitializeExecuted:int = 0;
		
		public function Container2Fake()
		{
			super();
		}
		
		protected override function doInitialize():void {
			numDoInitializeExecuted++;
			super.doInitialize();
		}
		
		protected override function doUninitialize():void {
			numDoUninitializeExecuted++;
			super.doUninitialize();
		}
	}
}