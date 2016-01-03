package vos
{
	import collections.*;
	
	import flash.net.registerClassAlias;
	registerClassAlias("vos.Item", Item);
	
	[Bindable]
	dynamic public class Item implements IPluggableObject
	{
		public var name:String;

		public function toString():String
		{
			return name;
		}
		
		public function toLongString():String {
			return this.toString();
		}
	}
}