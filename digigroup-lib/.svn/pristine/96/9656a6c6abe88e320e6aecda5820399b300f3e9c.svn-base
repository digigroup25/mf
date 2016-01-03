package collections
{
	import mx.core.ClassFactory;
	
	public class Singleton
	{
		private static var map:Object = new Object();
		
		public static function getInstance(type:Class):*
		{
			var res:*=map[type];
			if (res==null)
			{
				var cf:ClassFactory = new ClassFactory(type);
				
				var obj:* = cf.newInstance();
				map[type]=obj;
				res = obj;
			}
			return res;
		}
	}
}