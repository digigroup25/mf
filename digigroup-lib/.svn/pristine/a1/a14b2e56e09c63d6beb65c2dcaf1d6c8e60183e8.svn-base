package vos
{
	
	import collections.*;
	
	import flash.net.registerClassAlias;
	
	import mx.utils.StringUtil;
	
	registerClassAlias("vos.Note", Note);
	
	[Bindable]
	dynamic public class Note implements IPluggableObject
	{
		public var name:String;
		public var description:String;
		
		public function toString():String {
			return name;
		}
		
		public function toLongString():String {
			return StringUtil.substitute("{0}, {1}", name, description);
		}
	}
}