package mindmaps2.elements
{
	import commonutils.ClassInspector;
	import mx.core.ClassFactory;
	import commonutils.Attribute;
	
	public class ElementConverter
	{
		private static var ci:ClassInspector = new ClassInspector();
		public static function convert(vo:*, toType:Class):*
		{
			var cf:ClassFactory = new ClassFactory(toType);
			var res:* = cf.newInstance();
			var das:Array = ci.getDataAttributes(vo);
			for each (var da:Attribute in das)
			{
				if (ci.hasProperty(res, da.name))
				{
					res[da.name]=vo[da.name];
				}
			}
			return res;
		}
	}
}