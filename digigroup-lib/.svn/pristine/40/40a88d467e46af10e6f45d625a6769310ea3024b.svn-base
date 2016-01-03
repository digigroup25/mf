package mindmaps.search.ui {
	import collections.TreeCollectionEx;

	import flash.display.DisplayObjectContainer;

	import mf.framework.*;

	import mindmaps.map.MapModel2;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.ui.PopUpMessagesFactory;
	import mindmaps.search.SearchMatch;
	import mindmaps.search.SearchMessages;
	import mindmaps.search.SearchResult;

	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;

	public class SearchWindowController extends AbstractController {

		public function SearchWindowController(parent:DisplayObjectContainer) {
			this.parent = parent;
			this.nodeMessages = new NodeMessageFactory(this);
			this.popupMessages = new PopUpMessagesFactory(this);
		}

		protected var parent:DisplayObjectContainer;

		private var nodeMessages:NodeMessageFactory;

		private var popupMessages:PopUpMessagesFactory;

		override public function receive(m:Message):void {
			switch (m.name) {
				case SearchMessages.SEARCH_RESULT:
					onSearchResult(m);
					break;
			}
		}

		private function extractElementsFromSearchResults(searchResults:ArrayCollection):ArrayCollection {
			var res:ArrayCollection = new ArrayCollection();
			for each (var e:SearchMatch in searchResults) {
				res.addItem(e.element);
			}
			return res;
		}

		private function onSearchResult(m:Message):void {
			var searchResults:SearchResult = SearchResult(m.body.result);
			var result:ArrayCollection = extractElementsFromSearchResults(searchResults.matches);

			var window:SearchResultsWindow = new SearchResultsWindow();

			var titleWithSearchTerms:String = StringUtil.substitute("Search results for \"{0}\"", searchResults.searchTerms);
			this.send(popupMessages.addPopUp(window, titleWithSearchTerms, null, null)); //do not include map name in search results + " in \"{0}\" map", map, "name"));

			window.addEventListener(SearchResultEvent.SELECT, onSearchResultSelect, false, 0, true);
			window.dataProvider = result;
		}

		private function onSearchResultSelect(event:SearchResultEvent):void {
			var node:TreeCollectionEx = TreeCollectionEx(event.node);
			this.send(nodeMessages.SelectNode(node, false));
		}
	}
}
