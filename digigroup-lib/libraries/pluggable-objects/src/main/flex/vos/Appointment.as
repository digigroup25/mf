package vos
{
	import collections.*;
	
	import flash.net.registerClassAlias;
	
	import mx.utils.StringUtil;
	
	registerClassAlias("vos.Appointment", Appointment);
	
	[Bindable]
	dynamic public class Appointment implements IPluggableObject
	{
		public var name:String;
		public var location:String;
		public var description:String;
		public var date:Date;
		
		public function toString():String {
			return name;
		}
		
		public function toLongString():String {
			return StringUtil.substitute("{0}, {1}, {2}, {3}", name, location, description, date);
		}
	}
}