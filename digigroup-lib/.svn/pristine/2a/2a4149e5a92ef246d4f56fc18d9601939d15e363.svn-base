package mindmaps.importexport
{
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.utils.XMLUtil;

	public class MapImporterFactory
	{
		public function MapImporterFactory()
		{
		}
		
		public function createImporterFor(text:String):IMapImporter {
			var result:IMapImporter;
			try {
				var xmlText:XMLDocument = XMLUtil.createXMLDocument(text);
				var xmlNode:XMLNode = xmlText.firstChild;
				if (xmlNode.nodeName == null)
					result = new MapTextImporter();
				else
					result = new MapXmlImporter();
			}
			catch (e:Error) {
				result = new MapTextImporter();
			}
			finally {
				return result;
			}
		}
	}
}