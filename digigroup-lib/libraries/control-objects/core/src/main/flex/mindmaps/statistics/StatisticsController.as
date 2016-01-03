package mindmaps.statistics {
	import components.FloatingWindow;
	import components.FloatingWindowFactory;

	import flash.display.DisplayObjectContainer;

	import mf.framework.AbstractController;
	import mf.framework.Message;

	import mindmaps.map.MapModel2;
	import mindmaps.map.ui.PopUpMessagesFactory;
	import mindmaps.map.ui.actions.messages.MapMessages;
	import mindmaps.statistics.ui.StatisticsWindow;

	public class StatisticsController extends AbstractController {

		private static const analyzer:StatisticsAnalyzer = new StatisticsAnalyzer();

		public function StatisticsController(parent:DisplayObjectContainer) {
			this.model = parent;
			this.popupMessages = new PopUpMessagesFactory(this);
		}

		private var popupMessages:PopUpMessagesFactory;

		override public function receive(m:Message):void {
			switch (m.name) {
				case MapMessages.STATISTICS:
					onStatistics(m);
					break;
			}
		}

		private function get parent():DisplayObjectContainer {
			return DisplayObjectContainer(model);
		}

		private function onStatistics(m:Message):void {
			var map:MapModel2 = MapModel2(m.body.map);
			var result:Statistics = analyzer.analyze(map.nodes);
			var window:StatisticsWindow = new StatisticsWindow();
			window.statistics = result;
			this.send(popupMessages.addPopUp(window, "Map statistics", null, null));
		}
	}
}
