package  factories
{


	import collections.*;

	import org.flexunit.asserts.assertEquals;


	public class TreeFactoryTest
	{
		/*
		 public function TreeFactoryTest( methodName:String )
		 {
		 super( methodName );
		 }

		 public static function suite():TestSuite {
		 var ts:TestSuite = new TestSuite();

		 ts.addTest( new TreeFactoryTest( "createFullTree" ) );
		 return ts;
		 }
		 */

		[Test]
		public function testCreateFullTree():void
		{
			var col:TreeCollectionEx = new TreeFactory().createFullTree(3, 3);
			assertEquals(13, col.size);

			col = new TreeFactory().createFullTree(4, 2);
			assertEquals(5, col.size);
		}
	}
}