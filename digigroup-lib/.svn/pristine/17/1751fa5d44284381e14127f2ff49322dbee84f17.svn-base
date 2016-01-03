package commonutils {

	import collections.*;

	import com.adobe.utils.ArrayUtil;

	import flash.utils.*;

	import mx.utils.ObjectUtil;

	public class ClassInspector {
		public function createClass(className:String):Class {
			return getDefinitionByName(className) as Class;
		}

		public function getClass(o:*):Class {
			var className:String = getClassName(o);
			if (className == null)
				return null;
			return createClass(className);
		}

		public function getClassName(o:*, ignoreNs:Boolean = false):String {
			var typeDesc:XML = describeType(o);
			var className:String = String(typeDesc.@name);
			if (className == "null")
				return null;
			if (ignoreNs) {
				className = extractClassName(className);
			}
			return className;
		}

		//prevent circular references
		public function getClassNames(o:*, res:Array = null):Array {
			if (res == null)
				res = new Array();
			if (o == null)
				return res;
			var traversedObjects:Dictionary = new Dictionary();
			getClassNamesRecursively(o, res, traversedObjects);
			return com.adobe.utils.ArrayUtil.createUniqueCopy(res);
			//return res;
		}

		public function getCollectionClassNames(o:*, res:Array):void {
			var it:IIterator = o.createIterator();
			if (it.hasNext())
				it.next();
			while (it.hasNext()) {
				var o:* = it.next();
				var iRes:Array = getClassNames(o, res);
				for each (var iResElem:String in iRes)
					res.push(iResElem);
			}
		}

		public function hasConstructorArgs(o:*):Boolean {
			var typeDesc:XML = describeType(o);
			var constructors:XMLList = typeDesc.constructor;
			if (constructors.length() == 0)
				return false;
			var parameters:XMLList = constructors[0].parameter;
			return (parameters.length() > 0);
		}

		public function hasProperty(o:*, name:String):Boolean {
			var result:Boolean = false;
			var attrs:Array = getDataAttributes(o);
			for each (var attr:Attribute in attrs) {
				if (attr.name == name) {
					result = true;
					break;
				}
			}
			return result;
		}

		public function getClassVariables(o:*):Array {
			var r:XML = describeType(o);
			var attrs:XMLList;
			if (o is Class)
				attrs = r.factory[0].variable;
			else
				attrs = r.variable;
			return populateAttributes(attrs);
		}

		public function getClassAccessors(o:*):Array {
			var r:XML = describeType(o);
			var attrs:XMLList;
			if (o is Class)
				attrs = r.factory[0].accessor;
			else
				attrs = r.accessor;
			return populateAttributes(attrs);
		}

		public function getDynamicAttributes(o:*):Array {
			var res:Array = new Array();
			for (var a:String in o)
				res.push(new Attribute(a, getClassName(o[a])));
			return res;
		}

		public function getTypeInfo(value:Class):XML {
			return describeType(value);
		}

		public function getDataAttributes(o:*):Array {
			var res:Array; // = new Array();
			var variables:Array = getClassVariables(o);
			var accessors:Array = getClassAccessors(o);
			var dynamicAttributes:Array = getDynamicAttributes(o);
			res = variables.concat(accessors);
			res = res.concat(dynamicAttributes);
			return res;
		}

		public function implementsInterface(o:Class, interfaceA:Class):Boolean {
			if (o == null)
				return false;
			var r:XML = describeType(o);
			var f:XML = r.factory[0];
			var res:XMLList = f.implementsInterface;
			var interfaceName:String = getClassName(interfaceA, true);
			for each (var e:XML in res) {
				if (extractClassName(e.@type) == interfaceName)
					return true;
			}
			return false;
		}

		public function getPropertyType(o:*, propName:String):String {
			var r:Array = getClassAccessors(o);

			for each (var a:Attribute in r) {
				if (a.name == propName)
					return a.type;
			}
			return null;
		}

		public function getBaseClass(c:Class):Class {
			var r:XML = describeType(c);
			var f:XML = r.factory[0];
			var baseClassXml:XML = f.extendsClass[0];

			var baseClass:Class = createClass(baseClassXml.@type);
			if (baseClass == Object)
				return null;
			else
				return baseClass;
		}

		private function getClassNamesRecursively(o:*, res:Array, traversedObjects:Dictionary):void {
			var className:String = getClassName(o);
			res.push(className);
			var attrs:Array = getDataAttributes(o);
			for each (var attr:Attribute in attrs) {
				if (attr.type != "*" && attr.type != null) {
					if (res.indexOf(attr.type) == -1) {
						res.push(attr.type);
						trace("adding type", attr.type);
					}
				}
				if (!o.hasOwnProperty(attr.name))
					continue;

				var embObj:* = null;
				try {
					embObj = o[attr.name];
				} catch (e:Error) {
					continue;
				}
				if (embObj == null)
					continue;
				if (ObjectUtil.isSimple(embObj))
					continue;
				if (traversedObjects[embObj] != null) {
					continue;
				}
				traversedObjects[embObj] = embObj;
				getClassNamesRecursively(embObj, res, traversedObjects);
			}
			/*if (o is ArrayCollection)
			{
				for each (var elem:* in o)
					res.push(getClassName(elem));
			}*/
			if (o is ICollection)
				getCollectionClassNames(o, res);
		}

		private function extractClassName(fullClassName:String):String {
			var res:Array = fullClassName.split("::");
			return String(res[res.length - 1]);
		}

		private function populateAttributes(attrs:XMLList):Array {
			var r:Array = new Array();
			for each (var x:XML in attrs) {
				//ignore attributes that only have setters
				if (x.@access == "writeonly")
					continue;
				var attr:Attribute = new Attribute(x.@name, x.@type);
				r.push(attr);
			}
			r.sortOn("name");
			return r;
		}
	}
}
