package vos
{
	import collections.IPluggableObject;
	
	import flash.net.registerClassAlias;
	
	import mx.utils.StringUtil;
	
	registerClassAlias("vos.Contact", Contact);
	
	[Bindable]
	dynamic public class Contact implements IPluggableObject
	{
		public var name:String;
		public var company:String;
		public var phone:String;
		public var email:String;
		
		public function toString():String {
			return name;
		}
		
		public function toLongString():String {
			return StringUtil.substitute("{0}, {1}, {2}, {3}", name, company, phone, email);
		}
	}
}