package vos {
	import collections.IPluggableObject;

	import flash.net.registerClassAlias;

	import mx.utils.ObjectUtil;
	registerClassAlias("vos.Iteration", Iteration);

	[Bindable]
	public dynamic class Iteration implements IPluggableObject {

		public var name:String;

		public var start:Date;

		public var end:Date;

		public function toString():String {
			return name;
		}

		public function toLongString():String {
			return ObjectUtil.toString(this);
		}
	}
}
