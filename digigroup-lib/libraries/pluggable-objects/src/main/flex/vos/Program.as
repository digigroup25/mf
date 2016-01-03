package vos
{
	
	import collections.*;
	
	import flash.net.registerClassAlias;
	
	import mx.utils.StringUtil;
	
	registerClassAlias("vos.Program", Program);
	
	[Bindable]
	dynamic public class Program implements IPluggableObject
	{
		public var name:String;
		public var text:String;
		
		public function toString():String {
			return name;
		}
		
		public function toLongString():String {
			return StringUtil.substitute("{0}, {1}", name, text);
		}
	}
}