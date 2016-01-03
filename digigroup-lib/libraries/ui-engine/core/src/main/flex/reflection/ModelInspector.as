package reflection
{
	import commonutils.*;
	import collections.*;
	
	public class ModelInspector
	{
		public function getVOType(model:*, property:String):Class
		{
			var voType:Class = new ClassInspector().getClass(model[property]);
			return voType;
		}
		
		public function getModelVO(model:*, property:String, treatAsObject:Boolean=false):*
		{
			return getVO(model[property], treatAsObject);
		}
		
		public function getVO(vo:*, treatAsObject:Boolean):*
		{
			if (vo==null)
				return null;
			if (!treatAsObject)
			{
				if (vo is ICollection)
					return vo;
			}
			if (vo.hasOwnProperty("vo"))
				return vo.vo;
			else return vo;
		}
	}
}