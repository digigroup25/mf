package mindmaps2.storage.services {
	import collections.TreeCollectionEx;

	import converters.XmlCollectionConverter;

	import flash.events.Event;

	import mf.framework.*;

	import mindmaps.map.MapModel2;
	import mindmaps.map.MapModel2Factory;

	import mindmaps2.storage.*;
	import mindmaps2.storage.PersistentMap;
	import mindmaps2.storage.services.web.*;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;
	import mx.utils.URLUtil;

	use namespace mx_internal;

	public class WebMapRepository implements IMapRepository {
		public function WebMapRepository() {
		}

		public var messageListener:ISender;

		private var mapService:RemoteObject;

		private var _webAvailable:Boolean = true;

		private var userName:String;

		public function initialize():void {
			var url:String = FlexGlobals.topLevelApplication.loaderInfo.url;
			var hostName:String = URLUtil.getServerName(url);
			var gatewayUrl:String = (hostName == "localhost") ? "/gateway/" : "/vtm/gateway/";
			var channel:AMFChannel = new AMFChannel("pyamf-channel", gatewayUrl);

			// Create a channel set and add your channel(s) to it
			var channels:ChannelSet = new ChannelSet();
			channels.addChannel(channel);

			// Create a new remote object and add listener(s)
			mapService = new RemoteObject("map"); // this is the service id
			mapService.channelSet = channels;


		/*mapService.put_map.addEventListener(ResultEvent.RESULT, onPutMapComplete);
		mapService.put_map.addEventListener(FaultEvent.FAULT, onMapFault);

		mapService.get_maps.addEventListener(ResultEvent.RESULT, onGetMapsComplete);
		mapService.get_maps.addEventListener(FaultEvent.FAULT, onMapFault);

		mapService.get_map.addEventListener(ResultEvent.RESULT, onGetMapComplete);
		mapService.get_map.addEventListener(FaultEvent.FAULT, onMapFault);*/
		}

		public function uninitialize():void {
		}

		public function login(userName:String, password:String):void {
			this.userName = userName;
		}

		public function logout():void {
			this.userName = null;
		}

		public function getMap(name:String, mapId:String):AsyncToken {
			var token:AsyncToken =  mapService.get_map(userName, parseInt(mapId));
			token.addResponder(new AsyncResponder(onGetMapComplete, onMapFault));
			return token;
		}


		public function addMap(mapModel:MapModel2, token:Object):AsyncToken {
			var m:MapModel2 = new MapModel2Factory().createPriorityMap();
			var persistentMap:PersistentMap = new PersistentMap();
			persistentMap.fromMapModel(m);

			var asyncToken:AsyncToken =  mapService.put_map(userName, 'test_map', new Date(), persistentMap.mapData, 1, true);
			asyncToken.addResponder(new AsyncResponder(onPutMapComplete, onMapFault, { mapModel: m }));
			return asyncToken;
		}

		public function saveMap(mapModel:MapModel2, token:Object):AsyncToken {
			return addMap(mapModel, token);
		}

		public function getMaps():AsyncToken {
			var token:AsyncToken = mapService.get_maps(userName);
			token.addResponder(new AsyncResponder(onGetMapsComplete, onMapFault));
			return token;
		}

		public function deleteMap(name:String, callback:Function):void {
			var mapId:int = parseInt(name);
			var token:AsyncToken = mapService.delete_map(userName, mapId);
			token.addResponder(new AsyncResponder(onDeleteMapComplete, onMapFault, { callback: callback }));
		}

		public function renameMap(mapModel:MapModel2, newName:String, token:Object):AsyncToken {
			return null;
		}

		public function deleteAllMaps(callback:Function):void {

		}


		protected function get webAvailable():Boolean {
			return _webAvailable;
		}

		protected function set webAvailable(val:Boolean):void {
			if (_webAvailable == val)
				return;
			_webAvailable = val;
			var m:Message = (val) ? new Message(MapStorageMessages.WEB_AVAILABLE, this) : new Message(MapStorageMessages.WEB_UNAVAILABLE, this, { message: "web is unavailable" });
			this.messageListener.send(m);
		}

		private function onDeleteMapComplete(event:ResultEvent, token:Object):void {
			var callback:Function = token.callback as Function;
			callback();
		}

		private function onGetMapsComplete(event:ResultEvent, token:Object = null):void {
			var persistentMaps:Array = event.result as Array;
			var mapModels:ArrayCollection  = new ArrayCollection();
			for each (var persistentMap:PersistentMap in persistentMaps) {
				var mapModel:MapModel2 = new MapModel2(null, persistentMap.name, persistentMap.lastModified);
				mapModel.id = persistentMap.id.toString();
				mapModels.addItem(mapModel);
			}

			var res:Object = { result: true, maps: mapModels };
			event.mx_internal::setResult(res); //rewrite result so that the caller will get this result instead of the result from server

			this.webAvailable = true;
		}

		private function onGetMapComplete(event:ResultEvent, token:Object = null):void {
			var persistentMap:PersistentMap = PersistentMap(event.result);
			var nodes:TreeCollectionEx = new XmlCollectionConverter().fromXml(XML(persistentMap.mapData),
				new TreeCollectionEx());
			var map:MapModel2 = new MapModel2(nodes, persistentMap.name);
			map.id = persistentMap.id.toString();
			event.mx_internal::setResult(map);
		}

		private function onPutMapComplete(event:ResultEvent, token:Object = null):void {
			var mapModel:MapModel2 = MapModel2(token.mapModel);
			mapModel.id = event.result.id.toString();
			var result:Object = { result: true, mapModel: mapModel };
			//Alert.show(event.result.toString());
			event.mx_internal::setResult(result);
		}

		private function onMapFault(e:FaultEvent, token:Object = null):void {
			this.webAvailable = false;
			Alert.show(e.fault.toString());
		}
	}
}
