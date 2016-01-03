package mindmaps2.storage.services
{
	public class MapRepositoryFactory
	{
		public static var localRepoClass:Class = LocalMapRepository;
		public static var webRepoClass:Class = WebMapRepository;
		
		public static function localRepo():IMapRepository {
			return new localRepoClass();
		}
		
		public static function webRepo():IMapRepository {
			return new webRepoClass();
		}
	}
}