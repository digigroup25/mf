package uiengine.datarenderer
{
	import collections.Singleton;
	
	import commonutils.ClassInspector;
	
	public class IocDataRendererFactory
	{
		public function IocDataRendererFactory()
		{
		}
		public static function createClassInspector():ClassInspector {
			return ClassInspector(Singleton.getInstance(ClassInspector));
		}
		
		public static function createDataRendererHelper(controlMap:DefaultControlMap):DataRendererHelper {
			return new DataRendererHelper(controlMap);
		}
	}
}