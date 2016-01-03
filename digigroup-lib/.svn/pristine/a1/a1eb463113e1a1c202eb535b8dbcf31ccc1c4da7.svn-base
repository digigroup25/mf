package mindmaps.search
{
	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;
	
	import mindmaps.map.MapModel2;
	
	public class SearchController extends AbstractController
	{
		private var searcher:Searcher;
		
		public function SearchController(modelProvider:IModelProvider=null, mb:IMessageBroker=null)
		{
			super(modelProvider, mb);
			searcher = new Searcher();
		}
		
		override public function receive(m:Message):void {
			switch (m.name) {
				case SearchMessages.SEARCH: 
					var searchValue:String = String(m.body.searchValue);
					var map:MapModel2 = MapModel2(m.body.map);
					var searchResults:ArrayCollection = searcher.search(searchValue, map.nodes);
					var searchResultMessage:Message = new Message(SearchMessages.SEARCH_RESULT, this, {result:searchResults, map:map});
					this.send(searchResultMessage);
					break;
			}
		}
	}
}