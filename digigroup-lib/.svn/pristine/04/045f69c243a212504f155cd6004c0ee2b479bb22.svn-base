package mindmaps.importexport
{
	import mx.utils.XMLUtil;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;

	public class MapImporterFactoryTest
	{
		private static const factory:MapImporterFactory = new MapImporterFactory();
		
		[Test]
		public function validXml():void {
			var text:String = "<abc/>";
			var importer:IMapImporter = factory.createImporterFor(text);
			assertThat(importer, isA(MapXmlImporter));
		}
		
		[Test]
		public function invalidXml():void {
			var text:String = "<abc>";
			var importer:IMapImporter = factory.createImporterFor(text);
			assertThat(importer, isA(MapTextImporter));
		}
		
		[Test]
		public function text():void {
			var text:String = "abc";
			var importer:IMapImporter = factory.createImporterFor(text);
			assertThat(importer, isA(MapTextImporter));
		}
		
		[Test]
		public function emptyText():void {
			var text:String = "";
			var importer:IMapImporter = factory.createImporterFor(text);
			assertThat(importer, isA(MapTextImporter)); 
		}
	}
}