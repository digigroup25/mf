package mindmaps2.central {
	import logging.LogUtil;

	import mf.framework.Container2;
	import mf.framework.IMessageBroker;
	import mf.framework.Message;
	import mf.framework.ViewContainer;

	import mindmaps2.central.ui.CentralArea;
	import mindmaps2.central.ui.CentralViewController;
	import mindmaps2.map.ui.MindMapMessages;

	import mx.logging.ILogger;

	public class CentralContainer extends ViewContainer {
		private static const logger:ILogger = LogUtil.getLogger(CentralContainer);

		public function CentralContainer(centralArea:CentralArea, mb:IMessageBroker) {
			super(mb, null, centralArea, null, null, null);
			var centralViewController:CentralViewController = new CentralViewController(this.viewProvider, mb);
			this.controllers = [ centralViewController ];
		}

		override public function receive(m:Message):void {
			switch (m.name) {
				case MindMapMessages.CLOSE_MAP:
					onCloseMap(m);
					break;
				case MindMapMessages.OPEN_MAP:
					onOpenMap(m);
					break;
			}
		}

		private function onOpenMap(m:Message):void {
			var container:Container2 = m.body.container;
			this.addContainer(container);
		}

		private function onCloseMap(m:Message):void {
			logger.debug("onCloseMap");
			var container:Container2 = m.body.container;
			this.removeContainer(container);
		}
	}
}
