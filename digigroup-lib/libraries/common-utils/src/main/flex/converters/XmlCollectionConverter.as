package converters
{
	public class XmlCollectionConverter implements IXmlConverter
	{
		public function toXml(treeNode:*):XML
		{
			var c:IXmlConverter = XmlCollectionConverterFactory.createLatest();
			return c.toXml(treeNode);
		}
		
		public function fromXml(root:XML, treeNode:*):*
		{
			var version:String = new XmlCollectionInspector().getVersion(root);
			var c:IXmlConverter = XmlCollectionConverterFactory.create(version);
			return c.fromXml(root, treeNode);
		}
	}
}