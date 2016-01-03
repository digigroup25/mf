package mindmaps2.actions.element
{
	import actions.AbstractIOAction;
	
	import collections.TreeCollectionEx;
	
	import commonutils.ClassInspector;
	
	import mf.framework.Container2;
	import mf.framework.IReceiver;
	import mf.framework.Message;
	
	import mindmaps.map.messages.NodeMessages;

	public class SelectNode extends AbstractIOAction implements IReceiver
	{
		private const ci:ClassInspector = new ClassInspector();
		internal var nodeType:Class;
		
		public function SelectNode(nodeType:Class=null)
		{
			super("select " + (nodeType==null) ? "element" : ci.getClassName(nodeType, true));
			this.nodeType = nodeType;
		}
		
		override protected function doExecute():void {
			trace("SelectNode.doExecute");
			var container:Container2 = Container2(this.input.invocationContainer);
			container.mb.subscribe(this);
		}
		
		public function receive(m:Message):void {
			switch (m.name) {
				case NodeMessages.SELECTED_NODE:
					onSelectedNode(m);
					break;
			}
		}
		
		private function onSelectedNode(m:Message):void {
			//copy mechanism on repeatable actions does not quite work correctly
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			if (nodeType!=null && !node.hasDataOfType(nodeType)) {
				super.fail();
				return;
			}
			this.output.invocationContainer = m.body.elementContainer;
			super.doExecute();
		}
		
		override protected function doExecuteFail():void {
			var container:Container2 = Container2(this.input.invocationContainer);
			container.mb.unsubscribe(this);
			super.doExecuteFail();
		}
		
		override public function copy():Object {
			var res:SelectNode = SelectNode(super.copy());
			res.nodeType = this.nodeType;
			return res;
		} 
	}
}