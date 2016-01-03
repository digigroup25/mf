package
{


	import collections.*;

	import commonutils.*;

	import mx.controls.*;

	import org.flexunit.asserts.assertEquals;

	import reflection.*;

	import uiengine.datarenderer.*;


	public class UIEngineTest
	{
		private var e:AbstractDataRenderer = new AbstractDataRenderer();
		private var eHelper:DataRendererHelper = new DataRendererHelper(null);
		private var defaultMap:DefaultControlMap = DefaultControlMap.getInstance();
		private var mi:ModelInspector = new ModelInspector();
		/*
		 public function getElements():void
		 {
		 var r:XMLList = e.getElements(Config.modelData, "Task");
		 assertEquals(3, r.length());
		 }

		 public function getAttributes():void
		 {

		 var r:Array = e.getAttributes(Config.modelDef, "Task");
		 assertEquals(2, r.length);
		 assertEquals("name", r[0].name);
		 assertEquals("string", r[0].type);
		 assertEquals("priority", r[1].name);
		 }

		 public function getElementTypes():void
		 {
		 var r:Array = e.getElementTypes(Config.modelDef);
		 assertEquals(2, r.length);
		 assertEquals("Task", r[0]);
		 }

		 public function getFullType():void
		 {
		 var attr:Attribute = new Attribute("priority", "integer");
		 var r:String = e.getFullType("Task", attr);
		 assertEquals("Task.@priority", r);
		 }

		 public function doNeedToOverrideP():void
		 {
		 var attr:Attribute = new Attribute("priority", "integer");
		 var r:Boolean = e.doNeedToOverride(Config.view, "Task", attr);
		 assertTrue(r);
		 }

		 public function doNeedToOverrideF():void
		 {
		 var attr:Attribute = new Attribute("name", "string");
		 var r:Boolean = e.doNeedToOverride(Config.view, "Task", attr);
		 assertFalse(r);
		 }

		 public function getNewControlTypeP():void
		 {
		 var attr:Attribute = new Attribute("priority", "integer");
		 var r:String = e.getNewControlType(Config.view, "Task", attr);
		 assertEquals("TextBox", r);
		 }


		 public function getElementPropertiesReflection():void
		 {
		 var t:TaskComposite = TaskFactory.createTasks1();
		 var res:XMLList = e.getElementPropertiesReflection(t);
		 assertEquals(6, res.length());
		 }

		 public function getPropertyTypesReflection():void
		 {
		 var t:TaskComposite = TaskFactory.createTasks1();
		 var res:Array = e.getPropertyTypesReflection(t);
		 assertEquals(6, res.length);
		 assertEquals("String", res[4].type);
		 //assertEquals("int", res[1]);
		 }*/

		[Test]
		public function getControl():void
		{
			var r:Class = defaultMap.getControl("int");
			assertEquals(NumericStepper, r);
		}


		[Test]
		public function getControlForNonExistingType():void
		{
			var r:Class = defaultMap.getControl("xxx");
			assertEquals(TextArea, r);
		}


		[Test]
		public function getType():void
		{
			var r:String = defaultMap.getType(TextArea);
			assertEquals("String", r);
		}


		[Test]
		public function filterViewDescriptorIgnoreData():void
		{
			var ci:ClassInspector = new ClassInspector();
			var t:TreeCollectionEx = new TreeCollectionEx();
			var attrs:Array = ci.getDataAttributes(t);
			var attrsCount:int = attrs.length;
			var vd:ViewDataFilter = new ViewDataFilter();
			vd.addIgnoreData("children");

			attrs = vd.filter(attrs);

			assertEquals(attrsCount - 1, attrs.length);
		}


		[Test]
		public function orderData():void
		{
			//data sequence:name, priority, done
			//attrs: description, done, name, priority

			var attrs:Array = new Array();
			attrs.push(new Attribute("description"));
			attrs.push(new Attribute("done"));
			attrs.push(new Attribute("name"));
			attrs.push(new Attribute("priority"));

			var vd:ViewDataFilter = new ViewDataFilter();
			vd.addDataSequence("name");
			vd.addDataSequence("priority");
			vd.addDataSequence("done");


			vd.orderData(attrs);


			assertEquals("name", attrs[0].name);
			assertEquals("priority", attrs[1].name);
			assertEquals("done", attrs[2].name);
			assertEquals("description", attrs[3].name);
		}


	}
}