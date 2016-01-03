package converters {
	import classes.Task;
	import classes.TreeFactory;

	import collections.TreeCollectionEx;

	import commonutils.ObjectHelper;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class XmlCollectionConverter_1_2_Test {
		private static const converter:XmlCollectionConverter_1_2 = new XmlCollectionConverter_1_2();

		private static const oldConverter:XmlCollectionConverter_1_1 = new XmlCollectionConverter_1_1();

		private static const treeFactory:TreeFactory = new TreeFactory();

		[Test]
		public function setVariablesInXML():void {
			var version:Number = 1.1;
			var res:XML = <graph version="0"/>;
			res.@version = version;
		}

		[Test]
		public function testConvertToXml_1NodeCollection():void {
			var tree:TreeCollectionEx = treeFactory.create1NodeCollection();
			var res:XML = converter.toXml(tree);
			var oldRes:XML = oldConverter.toXml(tree);
		}
	}
}
