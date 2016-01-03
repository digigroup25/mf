package collections
{
	import assertions.Require;
	
	import commonutils.ICloneable;
	
	import flash.utils.flash_proxy;
	
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;
	
	use namespace flash_proxy;
	
	public dynamic class AliasHashMap extends ObjectProxy implements ICloneable
	{
		public var aliasMap:Object = new Object();
		
		public function AliasHashMap(item:Object=null, uid:String=null, proxyDepth:int=-1)
		{
			super(item, uid, proxyDepth);
		}
		
		override flash_proxy function getProperty(name:*):* {
			var propertyName:String = this.getPropertyNameForAlias(name);
			var res:Object = super.flash_proxy::getProperty(propertyName);
			return res;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			var propertyName:String = this.getPropertyNameForAlias(name);
			super.flash_proxy::setProperty(propertyName, value);
		}
		
		public function addAlias(alias:String, propertyName:String):void {
			Require.notNull(alias, "alias");
			Require.notNull(propertyName, "propertyName");
			
			if (alias==propertyName)
				throw new ArgumentError("Alias cannot reference the property with the same name");
			
			//prevent circular aliasing
			if (isAlias(propertyName)) {
				var chain:Array = [alias];
				var curPropertyName:String = propertyName;
				while (isAlias(curPropertyName)) {
					if (chain.indexOf(curPropertyName)!=-1) {
						throw new ArgumentError (StringUtil.substitute("Circular dependency: alias={0}, propertyName={1}, " + 
								"property chain={2}", alias, propertyName, chain.toString()));
					}
					chain.push(curPropertyName);
					curPropertyName = aliasMap[curPropertyName];
				}
			}
			aliasMap[alias] = propertyName;	
		}
		
		public function removeAlias(alias:String):void {
			delete aliasMap[alias];
		}
		
		public function getAliases():Array {
			var res:Array = [];
			for (var alias:String in aliasMap) {
				res.push({alias:alias, propertyName:aliasMap[alias]});
			}
			return res;
		}
		
		public function isAlias(alias:String):Boolean {
			return aliasMap[alias] != undefined;
		}
		
		private function getPropertyNameForAlias(alias:String):String {
			if (!isAlias(alias)) return alias; //alias is property name
			var curPropertyName:String = aliasMap[alias];
			while (isAlias(curPropertyName)) {
				curPropertyName = aliasMap[curPropertyName];
			}
			return curPropertyName;
		}		
		
		public function clone():Object {
			var res:AliasHashMap = new AliasHashMap();
			
			res.copyFrom(this);
			
			return res;
		}
		
		public function copyFrom(source:AliasHashMap):void {
			//copy key/value pairs
			for (var key:String in source) {
				this[key] = source[key];
			}
			
			//copy aliases
			var aliases:Array = source.getAliases();
			for each (var aliasValue:Object in aliases) {
				this.addAlias(aliasValue.alias, aliasValue.propertyName);
			}
		}
	}
}