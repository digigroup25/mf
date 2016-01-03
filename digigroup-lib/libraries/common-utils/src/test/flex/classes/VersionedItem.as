package classes
{
	public class VersionedItem
	{
		public var name:String;
		public var version:int;
		
		public function VersionedItem(name:String=null, version:int=0)
		{
			this.name = name;
			this.version = version;
		}
	}
}