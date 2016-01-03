package mindmaps2.actions.element
{
	import actions.AbstractIOAction;

	import actions.AbstractUserAction;

	import assertions.Require;

	import collections.TreeCollectionEx;

	import com.adobe.utils.ArrayUtil;

	import commonutils.ClassInspector;

	import flash.display.DisplayObject;

	import mf.framework.Container2;
	import mf.framework.IReceiver;
	import mf.framework.Message;

	import mindmaps.map.MapContext;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;
	import mindmaps.map.ui.actions.messages.MapMessageFactory;

	import mindmaps2.AppSettings;
	import mindmaps2.elements.ui.ConvertElementWindow;
	import mindmaps2.elements.ui.ConvertElementWindowEvent;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	import vos.Task;

	public class ConvertElementToType extends AbstractIOAction implements IReceiver
	{
		private static const ci:ClassInspector = new ClassInspector();

		private static var nodeMessages:NodeMessageFactory;

		public function ConvertElementToType(name:String = "convertElementToType")
		{
			super(name);
			nodeMessages = new NodeMessageFactory(this);
			this.preconditions = [ checkPreconditions ];
		}

		private var container:Container2;

		private var node:TreeCollectionEx;

		public function receive(m:Message):void
		{
			switch (m.name)
			{
				case NodeMessages.CONVERTED_NODE:
					onConvertedNode(m);
					break;
			}
		}

		override public function uninitialize():void
		{
			if (container != null)
				container.mb.unsubscribe(this);
			container = null;
			node = null;
			super.uninitialize();
		}


		override protected function doExecute():void
		{
			container = Container2(this.input.mapContainer);
			container.mb.subscribe(this);

			node = TreeCollectionEx(this.input.node);
			var convertElementToType:Class = Class(this.input.convertElementToType);
			container.send(nodeMessages.ConvertNode(node, convertElementToType));
		}

		private function checkPreconditions():Boolean
		{
			Require.notNull(this.input.mapContainer, "mapContainer");
			Require.notNull(this.input.node, "node");
			Require.notNull(this.input.convertElementToType, "convertElementToType");
			return true;
		}

		private function onConvertedNode(m:Message):void
		{
			//container.send(nodeMessages.SelectNode(node, false));
			super.doExecute();
		}
	}
}
