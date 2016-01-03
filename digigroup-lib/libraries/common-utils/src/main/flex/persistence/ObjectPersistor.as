package persistence {
	import collections.*;

	import com.adobe.utils.ArrayUtil;

	import commonutils.*;

	import flash.net.*;

	import mx.collections.ArrayCollection;

	public class ObjectPersistor implements IPersistor {
		private static var ci:ClassInspector = new ClassInspector();

		public static function registerClassAliases(item:*):void {
			var classNames:Array = ci.getClassNames(item);
			for each (var className:String in classNames)
				registerClassAlias(className, ci.createClass(className));
		}

		public static function replaceIllegalCharacters(identifier:String):String {
			//var pattern:RegExp = /[~%&\;:\"\&apos;<>\?#]/g;
			var pattern:RegExp = /[ ]/g;

			return identifier.replace(pattern, "_");
		}

		public function ObjectPersistor(catalogName:String = null, useItemName:Boolean = true) {
			if (catalogName != null)
				this._catalogName = catalogName;
			this.useItemName = useItemName;
		}

		private var _catalogName:String = "_catalog";

		private var useItemName:Boolean; //specifies if to write item.name or name that were passed to save method

		public function get catalogName():String {
			return _catalogName;
		}

		public function save(item:*, name:String, useCatalog:Boolean = true):void {
			if (useCatalog)
				if (useItemName)
					addToCatalog(item);
				else
					addToCatalog(name);
			write(item, name);
		}

		public function remove(name:String, useCatalog:Boolean = true):void {
			if (useCatalog)
				removeFromCatalog(name);
			deleteItem(name);
		}

		public function load(name:String, item:*, types:Array = null):* {
			if (item != null)
				registerClassAliases(item);
			if (types != null) //need types b/c Array might contain Task but Task is not registered
				for each (var type:Class in types) {
					var typeName:String = ci.getClassName(type);
					registerClassAlias(typeName, type);
				}

			typeName = ci.getClassName(ArrayCollection);
			registerClassAlias(typeName, ArrayCollection);
			var lso:SharedObject;
			var result:*;
			try {
				lso = SharedObject.getLocal(replaceIllegalCharacters(name));
				result = lso.data.obj;
			} catch (e:Error) {
				trace(e);
			}
			return result;
		}

		public function contains(item:*):Object {
			var result:ArrayCollection = loadCatalog();

			return _contains(item, result);
		}

		public function loadCatalog(itemType:* = null):ArrayCollection {
			var result:ArrayCollection = load(catalogName, itemType);
			if (result == null)
				result = new ArrayCollection();
			return result;
		}

		public function rename(item:*, oldName:String, newName:String):void {
			deleteItem(item);
			save(item, newName);
		}

		public function removeAll():void {
			var catalog:ArrayCollection = loadCatalog();
			for (var i:int = 0; i < catalog.length; i++) {
				var itemName:String = useItemName ? catalog[i].name : catalog[i];
				deleteItem(itemName);
			}
			clearCatalog();
		}

		public function clearCatalog():void {
			this.deleteItem(catalogName);
		}

		public function addToCatalog(item:*):void {
			var result:ArrayCollection = loadCatalog();

			var containsResult:Object = _contains(item, result);
			if (containsResult.result) {
				const index:int = containsResult.index;
				result.setItemAt(item, containsResult.index);
			} else {
				result.addItem(item);
			}
			saveCatalog(result);
		}

		public function removeFromCatalog(name:String):void {
			var result:ArrayCollection = loadCatalog();
			for (var i:int = 0; i < result.length; i++) {
				var item:* = useItemName ? result[i].name : result[i];
				if (item == name) {
					result.removeItemAt(i);
					break;
				}
			}
			saveCatalog(result);
		}

		private function _contains(item:*, result:ArrayCollection):Object {
			for (var i:int = 0; i < result.length; i++) {
				var catalogItem:* = result[i];
				var namedCatalogItem:* = useItemName ? catalogItem.name : catalogItem;
				var namedItem:* = item is String ? item : (useItemName) ? item.name : item;
				if (namedCatalogItem == namedItem) {
					return { result: true, index: i };
				}
			}

			return { result: false };
		}

		private function saveCatalog(result:ArrayCollection):void {
			write(result, catalogName);
		}

		private function deleteItem(name:String):void {
			var lso:SharedObject;
			try {
				lso = SharedObject.getLocal(replaceIllegalCharacters(name));
				lso.clear();
			} catch (e:Error) {
				trace(e);
			}
		}

		private function write(item:*, name:String):void {
			registerClassAliases(item);
			//need to register ArrayCollection explicitly
			var typeName:String = ci.getClassName(ArrayCollection);
			registerClassAlias(typeName, ArrayCollection);


			var lso:SharedObject;

			try {
				name = replaceIllegalCharacters(name);
				lso = SharedObject.getLocal(name);

				// Write the class instance to the local shared object
				lso.data.obj = item;
				lso.flush();
			} catch (e:Error) {
				trace(e);
			}
		}
	}
}
