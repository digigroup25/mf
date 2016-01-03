package uiengine
{


	import commonutils.Attribute;

	import mx.controls.TextArea;
	import mx.core.UIComponent;

	import org.flexunit.asserts.assertTrue;

	import testclasses.*;

	import uiengine.datarenderer.*;


	public class DataRendererHelperTest
	{
		[Test]
		public function testRender_object_propertyKeyword():void
		{
			var map:ViewKeywordControlMap = ViewKeywordControlMap.getInstance();
			map.add(new ViewKeywordControlMapItem("propertyA", ClassAControl));

			var drh:DataRendererHelper = new DataRendererHelper(DefaultControlMap.getInstance());

			var attr:Attribute = new Attribute("propertyA", "String");
			//overridden with propertyKeyword
			var res:UIComponent = drh.createControl(attr);
			assertTrue(res is ClassAControl);

			//no entry, use default assignment
			res = drh.createControl(new Attribute("propertyB", "String"));
			assertTrue(res is TextArea);
		}
	}
}