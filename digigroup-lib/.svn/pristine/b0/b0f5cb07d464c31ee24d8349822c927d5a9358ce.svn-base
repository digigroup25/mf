package mindmaps.search
{
	import mf.framework.Container2;
	import mf.framework.IContainer;
	import mf.framework.IMessageBroker;
	
	import mindmaps.search.SearchController;
	
	public class SearchContainerFactory
	{
		public static function createService(mb:IMessageBroker):IContainer
		{
			var res:IContainer = new Container2(mb, null, [new SearchController()]);
			return res;
		}

	}
}