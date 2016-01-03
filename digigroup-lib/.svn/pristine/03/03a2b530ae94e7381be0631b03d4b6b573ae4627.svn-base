package mf.utils
{
	import flash.utils.*;
	
	public class ClassUtil
	{
		public function ClassUtil()
		{
		}
		
		public function createClass(className:String):Class
		{
			return getDefinitionByName(className) as Class;			
		}
		
		public function getClass(o:*):Class
		{
			return createClass(getClassName(o));
		}
		
		public function getClassName(o:*, ignoreNs:Boolean=false):String
		{
			var typeDesc:XML = describeType(o);
			var className:String = String(typeDesc.@name);
			if (className=="null")
				return null;
			if (ignoreNs)
			{
				className = extractClassName(className);
			}
			return className;
		}
		
		private function extractClassName(fullClassName:String):String
		{
			var res:Array = fullClassName.split("::");
			return	String(res[res.length-1]);	
		}
		
		public function getBaseClass(c:Class):Class
		{
			var r:XML = describeType(c);
			var f:XML = r.factory[0];
			var baseClassXml:XML = f.extendsClass[0];
			
			var baseClass:Class = createClass(baseClassXml.@type);
			if (baseClass==Object)
				return null;
			else return baseClass;
		}
	}
}