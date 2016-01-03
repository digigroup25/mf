package  collections
{
	import classes.*;

	import commonutils.*;

	import converters.*;

	import org.flexunit.asserts.assertEquals;


	public class Base64Test
 	{
		[Test]
 		public function testEncode():void
 		{
 			var col:TreeCollectionEx = new TreeFactory().createSimpleCollection();
 			XML.prettyPrinting = false;
 			var xmlString:String = new XmlCollectionConverter_1_0().toXml(col).toXMLString();
 			
 			var encodedString:String = Base64.encode(xmlString);
 			
 			assertEquals(xmlString, Base64.decode(encodedString));
 		}
  	}
}