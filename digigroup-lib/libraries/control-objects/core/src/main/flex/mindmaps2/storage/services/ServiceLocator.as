package mindmaps2.storage.services
{
	import mf.framework.IManagedLifecycle;
	
	public class ServiceLocator implements IManagedLifecycle
	{
		
		public var mapPersistorClass:Class = MapPersistor;
		public var voTypes:Array;
		private var mapPersistorInstance:MapPersistor;
		private static var instance:ServiceLocator;
		private var serviceMap:Object;
		
		public static function getInstance():ServiceLocator {
			if (instance==null)
				instance = new ServiceLocator();
			return instance;
		}
		
		public function ServiceLocator() {
			if (instance)
				throw new Error("Can only create one instance of ServiceLocator");
		}
		
		public function createMapPersistor(catalogName:String=null, voTypes:Array=null):MapPersistor {
			if (mapPersistorInstance==null)
				mapPersistorInstance = new mapPersistorClass(catalogName, voTypes);
				
			return mapPersistorInstance;
		}
		
		public function getMapRepository(repositoryType:String):IMapRepository {
			return IMapRepository(serviceMap[repositoryType]);
		}
		
		public function initialize():void {
			for each (var service:IManagedLifecycle in serviceMap) {
				service.initialize();
			}
		}
		
		public function register(serviceName:String, service:IManagedLifecycle):void {
			if (!serviceMap) serviceMap = new Object();
			serviceMap[serviceName] = service;
		}
		public function uninitialize():void {
			for each (var service:IManagedLifecycle in serviceMap) {
				service.uninitialize();
			}
			serviceMap = null;
		}
	}
}