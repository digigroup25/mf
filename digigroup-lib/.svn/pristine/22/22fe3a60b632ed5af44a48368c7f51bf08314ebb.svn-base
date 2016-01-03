package commonutils 
{
	import classes.TreeFactory;

	import collections.*;

	import converters.*;

	import flexunit.framework.TestSuite;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;


	public class HasherTest
 	{	
   		private function convertToString(t:TreeCollectionEx):String
   		{
   			var xmlConverter:XmlCollectionConverter_1_0 = new XmlCollectionConverter_1_0();
   			var txml:XML = xmlConverter.toXml(t);
   			return txml.toString();
   		}
   		
   		//t1==t3!=t2
		[Test]
   		public function hash():void
  		{
  			var t1:TreeCollectionEx = new TreeFactory().createPriorityTaskTree();
  			var t2:TreeCollectionEx = new TreeFactory().createPriorityTaskTree2();
  			var t3:TreeCollectionEx = new TreeFactory().createPriorityTaskTree();
  			
  			var res1:String = Hasher.hash(convertToString(t1));
  			var res2:String = Hasher.hash(convertToString(t2));
  			var res3:String = Hasher.hash(convertToString(t3));
  			
  			assertFalse(res1==res2);
  			assertEquals(res1, res3);
  		}
  	}
}