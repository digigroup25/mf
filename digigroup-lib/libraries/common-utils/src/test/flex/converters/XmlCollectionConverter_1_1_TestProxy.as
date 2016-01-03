package converters
{
	public class XmlCollectionConverter_1_1_TestProxy extends XmlCollectionConverter_1_1
	{
		public function XmlCollectionConverter_1_1_TestProxy()
		{
			super();
		}
		
		public function xmlToVoProxy(nodeDataXml:XML, vo:*):void {
			super.xmlToVo(nodeDataXml, vo);
		}
	}
}