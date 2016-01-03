package converters
{
	public interface IXmlConverter
	{
		function toXml(o:*):XML;
		function fromXml(xml:XML, o:*):*;
	}
}