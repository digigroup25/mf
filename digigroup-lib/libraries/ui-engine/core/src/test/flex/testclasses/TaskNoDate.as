package testclasses
{
	
	import collections.*;
	[Bindable]
	dynamic public class TaskNoDate
	{
		public var name:String;
		public var priority:int;
		public var complexity:int;
		public var done:int;
		public var description:String;

		public function toString():String
		{
			return name;
		}
	}
}