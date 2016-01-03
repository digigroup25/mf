package mindmaps2.storage.services 
{
	import mindmaps.map.MapModel2;
	
	import mindmaps2.storage.PersistentMap;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.flexunit.async.TestResponder;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	
	import services.MapPersistorMock;

	public class LocalMapRepositoryTest
	{
		private static const repo:LocalMapRepository = new LocalMapRepository([]);
		private static var mapPersistor:MapPersistorMock;
		private static const TIMEOUT:uint = 200;
		private static const name:String = "test";
		private static const newName:String = "test2";
		
		public function LocalMapRepositoryTest()
		{
		}
		
		[Before]
		public function setup():void {
			mapPersistor = new MapPersistorMock();
			repo.setPersistor(mapPersistor);
		}
		
		[Test(async)]
		public function getMaps():void {
			var token:AsyncToken = repo.getMaps();
			token.addResponder(Async.asyncResponder(this, new TestResponder(getMapsResult, fault), TIMEOUT));
			
		}
		
		private function getMapsResult(event:ResultEvent, token:Object):void {
			assertThat(event.result, hasProperty("maps"));
			assertThat(event.result.maps, hasProperty("length", mapPersistor.maps.length));
		}
		
		[Test(async)]
		public function addNewMap():void {
			var mapModel:MapModel2 = new MapModel2(null, name);
			var token:AsyncToken = repo.addMap(mapModel, {});
			token.addResponder(Async.asyncResponder(this, new TestResponder(addNewMapResult, fault), TIMEOUT));
				
		}
		
		private function addNewMapResult(event:ResultEvent, token:Object):void {
			assertThat(event.result, hasProperty("result", true));
			assertThat(event.result, hasProperty("mapModel", instanceOf(MapModel2)));
			assertThat(event.result, not(hasProperty("foo")));
		}
		
		[Test(async)]
		public function addMapWithExistingName():void {
			assertThat(mapPersistor.maps, hasProperty("length", greaterThan(0)));
			var lastPersistentMap:PersistentMap = PersistentMap(mapPersistor.maps.getItemAt(mapPersistor.maps.length-1));
			var mapModel:MapModel2 = new MapModel2(null, lastPersistentMap.name);
			var token:AsyncToken = repo.addMap(mapModel, {});
			token.addResponder(Async.asyncResponder(this, new TestResponder(addMapWithExistingNameResult, fault), TIMEOUT));
			
		}
		
		private function addMapWithExistingNameResult(event:ResultEvent, token:Object):void {
			assertThat(event.result, hasProperty("result", false));
			assertThat(event.result, hasProperty("mapModel", instanceOf(MapModel2)));
		}
		
		private function fault(event:FaultEvent, token:Object):void {
			
		}
		
		[Test(async)]
		public function renameMap_newName():void {
			var mapModel:MapModel2 = new MapModel2(null, name);
			var token:AsyncToken = repo.renameMap(mapModel, newName, {});
			token.addResponder(Async.asyncResponder(this, new TestResponder(renameNewMapResult, fault), TIMEOUT));
			
		}
		
		private function renameNewMapResult(event:ResultEvent, token:Object):void {
			assertThat(event.result, hasProperty("result", true));
			assertThat(event.result, hasProperty("mapModel", instanceOf(MapModel2)));
			assertThat(event.result.mapModel, hasProperty("name", newName));
		}
		
		[Test(async)]
		public function renameMap_existingName():void {
			var lastPersistentMap:PersistentMap = PersistentMap(mapPersistor.maps.getItemAt(mapPersistor.maps.length-1));
			var mapModel:MapModel2 = new MapModel2(null, lastPersistentMap.name);
			var token:AsyncToken = repo.renameMap(mapModel, lastPersistentMap.name, {});
			token.addResponder(Async.asyncResponder(this, new TestResponder(renameExistingNameMapResult, fault), TIMEOUT));
			
		}
		
		private function renameExistingNameMapResult(event:ResultEvent, token:Object):void {
			assertThat(event.result, hasProperty("result", false));
			assertThat(event.result, hasProperty("error", notNullValue()));
		}
		
		[Test(async)]
		public function saveMap_existingName():void {
			var lastPersistentMap:PersistentMap = PersistentMap(mapPersistor.maps.getItemAt(mapPersistor.maps.length-1));
			var mapModel:MapModel2 = new MapModel2(null, lastPersistentMap.name);
			var token:AsyncToken = repo.saveMap(mapModel, {});
			token.addResponder(Async.asyncResponder(this, new TestResponder(saveExistingNameMapResult, fault), TIMEOUT));
		}
		
		private function saveExistingNameMapResult(event:ResultEvent, token:Object):void {
			assertThat(event.result, hasProperty("result", true));
		}
		
		[Test(async)]
		public function saveMap_newName():void {
			var lastPersistentMap:PersistentMap = PersistentMap(mapPersistor.maps.getItemAt(mapPersistor.maps.length-1));
			var mapModel:MapModel2 = new MapModel2(null, newName);
			var token:AsyncToken = repo.saveMap(mapModel, {});
			token.addResponder(Async.asyncResponder(this, new TestResponder(saveNewNameMapResult, fault), TIMEOUT));
			
		}
		
		private function saveNewNameMapResult(event:ResultEvent, token:Object):void {
			assertThat(event.result, hasProperty("result", false));
			assertThat(event.result, hasProperty("error", notNullValue()));
		}
	}
}