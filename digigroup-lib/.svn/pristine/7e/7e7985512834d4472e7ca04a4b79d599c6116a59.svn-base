package mindmaps2.storage.services {
	import mf.framework.IManagedLifecycle;

	import mindmaps.map.MapModel2;

	import mx.rpc.AsyncToken;

	public interface IMapRepository extends IManagedLifecycle {
		function getMaps():AsyncToken;
		function getMap(name:String, mapId:String):AsyncToken;
		function addMap(map:MapModel2, token:Object):AsyncToken;
		function saveMap(mapModel:MapModel2, token:Object):AsyncToken;
		function deleteMap(name:String, callback:Function):void;
		function renameMap(map:MapModel2, newName:String, token:Object):AsyncToken;
		function deleteAllMaps(callback:Function):void;
	}
}
