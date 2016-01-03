package mindmaps.importexport
{
	import collections.TreeCollectionEx;
	
	import converters.XmlCollectionConverter;

	public class MapXmlImporter implements IMapImporter
	{
		public function MapXmlImporter()
		{
		}
		public function importFrom(text:String):TreeCollectionEx {
			var converter:XmlCollectionConverter = new XmlCollectionConverter();
			var tree:TreeCollectionEx = converter.fromXml(new XML(text), new TreeCollectionEx());
			return tree;
		}
	}
}