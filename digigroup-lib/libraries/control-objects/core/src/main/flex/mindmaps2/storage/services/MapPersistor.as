package mindmaps2.storage.services
{
	import commonutils.*;
	
	import mindmaps2.storage.PersistentMap;
	
	import mx.collections.ArrayCollection;
	
	import persistence.ObjectPersistor;
	
	
	public class MapPersistor
	{
		private var catalogName:String = "_maps";
		private var p:ObjectPersistor;
		private var voTypes:Array;
		
		private function get catalogContextName():String
		{
			return catalogName + "Context";
		} 
		
		public function MapPersistor(catalogName:String=null, voTypes:Array=null)
		{
			if (catalogName!=null)
				this.catalogName = catalogName;
			
			this.voTypes = (voTypes!=null) ? voTypes : new Array();
			p = new ObjectPersistor(this.catalogName, true);
		}
		
		//save map, context
		public function save(map:PersistentMap):void
		{
			//forego standard way of saving to catalog and then item b/c catalog stores collection of maps but do not 
			//want to store map.data in catalog
			var mapStripped:PersistentMap = PersistentMap(DeepCopy.clone(map));
			//map.version++;
			mapStripped.mapData = null;
			p.addToCatalog(mapStripped);
			p.save(map, map.name, false);
		}
		
		public function contains(mapName:String):Boolean {
			return p.contains(mapName).result as Boolean;
		}
		
		//open context, map
		public function loadLastOpened():PersistentMap
		{
			var context:MapCatalogContext = p.load(catalogContextName, new MapCatalogContext());
			if (context==null)
				return null;
			var res:PersistentMap;
			try
			{
				res = load(context.lastOpenedMap);//, new Map(), getRegisteredTypes()));
			}
			catch (er:Error) {}
			return res;
		}
		
		public function load(name:String):PersistentMap
		{
			var context:MapCatalogContext = new MapCatalogContext();
			context.lastOpenedMap = name;
			p.save(context, catalogContextName, false); //overrides whatever context was there
			
			//var m:Map = new Map();
			//m.mapData = null;
			var o:Object = p.load(name, new PersistentMap(), getRegisteredTypes());
			var res:PersistentMap = PersistentMap(o);
			var cloneRes:PersistentMap = PersistentMap(DeepCopy.clone(res));
			return cloneRes;
		}
		
		public function rename(map:PersistentMap, newName:String):void
		{
			//need prevMap because it has actual mapData, map doesn't have it because it is passed from mapCatalog
			var prevMap:PersistentMap = load(map.name);
			remove(map.name);
			map.mapData = prevMap.mapData;
			map.name = newName;
			save(map);
		}
		
		public function removeAll():void
		{
			p.removeAll();
			p.remove(catalogContextName);
		}
		
		public function remove(name:String):void
		{
			var context:MapCatalogContext = p.load(catalogContextName, new MapCatalogContext());
			if (context!=null && context.lastOpenedMap==name) //remove lastOpenedMap 
				p.remove(catalogContextName, false);
			p.remove(name);
		}
		
		public function loadMaps():ArrayCollection
		{
			return p.loadCatalog(new PersistentMap());
		}
		
		
		private function getRegisteredTypes():Array
		{
			//return TypeMap.getInstance().get();
			return voTypes;
		}
	}
}