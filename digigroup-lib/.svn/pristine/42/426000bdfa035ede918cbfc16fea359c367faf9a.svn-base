package converters {
	import classes.Task;

	import collections.TreeCollectionEx;

	import commonutils.ObjectHelper;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class XmlCollectionConverter_1_1_Test {
		private static const converter:XmlCollectionConverter_1_1_TestProxy = new XmlCollectionConverter_1_1_TestProxy();

		public function XmlCollectionConverter_1_1_Test() {
		}

		private const testData:Array = [{ name: "task with name and priority", input: new XML('<Task><name>a</name><priority>1</priority></Task>'), output: new Task().setName("a").setPriority(1)},
			{ name: "task with extra xml field", input: new XML('<Task><name>a</name><foo>1</foo></Task>'), output: new Task().setName("a")},
			{ name: "task with incompatible field type", input: new XML('<Task><name>a</name><priority>foo</priority></Task>'), output: new Task().setName("a")},
			{ name: "task with missing xml field", input: new XML('<Task><name>a</name></Task>'), output: new Task().setName("a")},
			{ name: "task with boolean field true", input: new XML('<Task><committed>true</committed></Task>'), output: new Task().setCommitted(true)},
			{ name: "task with boolean field false", input: new XML('<Task><committed>false</committed></Task>'), output: new Task().setCommitted(false)}

			];

		[Test]
		public function fromXml_1Task():void {
			for each (var testCase:Object in testData) {
				var vo:Task = new Task();
				converter.xmlToVoProxy(testCase.input, vo);
				assertTrue(testCase.name, ObjectHelper.compare(testCase.output, vo));
			}
		}

		[Test]
		public function xmlEquality():void {
			var aXml1:XML = <item><a/></item>;
			var aXml2:XML = <item><a/></item>;
			var aXml3:XML = <item><a><b/></a></item>;
			var bXml1:XML = <item><b/></item>;
			var bXml2:XML = <item>b</item>;

			assertTrue(aXml1 == aXml2);
			assertFalse(aXml1 === aXml2);
			assertFalse(aXml2 == aXml3);
			assertFalse(aXml1 == bXml1);
			assertEquals(aXml1, aXml2);
			assertFalse(bXml1 == bXml2);
		}

		[Test]
		public function xmlFragment_variable():void {
			var xmlFragment:XML = <abc/>;
			var actualXml:XML = <a>{xmlFragment}</a>;
			var actualXmlString:String = actualXml.toXMLString();
			var expectedXmlString:String = new XML(<a><abc/></a>).toXMLString();
			assertEquals(expectedXmlString, actualXmlString);
		}

		[Test]
		public function xmlFragment_functionReturn():void {
			var xml:XML = <a>{returnXmlFragment()}</a>;
			assertEquals(xml, <a><abc/></a>);
		}

		private function returnXmlFragment():XML {
			return <abc/>;
		}
	}
}
