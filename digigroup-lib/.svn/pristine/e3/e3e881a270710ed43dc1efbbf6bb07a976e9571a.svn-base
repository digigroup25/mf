package uiengine.datarenderer
{
	import commonutils.*;
		
	public class ViewDataFilter
	{
		public var dataSequence:Array = new Array();
		public var ignoreData:Array = new Array();
		public var showOnlyData:Array = new Array();
		
		public function addIgnoreData(... properties):void
		{
			for (var i:uint = 0; i < properties.length; i++)
		    {
		        ignoreData.push(properties[i]);
		    }
		}
		
		/**
		 * Allows to specify the order of data attribute appearance
		 * e.g. "name", "priority", "done"
		 * @param properties
		 * 
		 */		
		public function addDataSequence(... properties):void
		{
		    for (var i:uint = 0; i < properties.length; i++)
		    {
		        dataSequence.push(properties[i]);
		    }
		}
		
		/**
		 * Allows to specify data attributes to be shown
		 * e.g. show only "name" and "priority"
		 * @param propName
		 * 
		 */		
		public function addShowOnlyData(propName:String):void
		{
			showOnlyData.push(propName);
			dataSequence.push(propName);
		}
		//remove ignored attributes
		private function removeIgnoredData(attrs:Array):void
		{
			if (attrs == null) return;
			for each (var propName:String in ignoreData)
			{
				for (var i:int=0; i<attrs.length; i++)
				{
					if (objectHasProperty(attrs[i], propName))
						attrs.splice(i, 1);
				}
			}
		}
		
		private function objectHasProperty(item:*, propName:String):Boolean
		{
			var success:Boolean = false;
			if (item is Attribute)
			{	
				if (item.name==propName)
					success = true;
			}
			else if (item.dataField==propName)
			{
				success = true;
			}
			return success;
		}
		
		private function getNamePropertyValue(item:*):String
		{
			if (item==null)
				return "-1"; //when testing attrs are empty, so need this hack
			if (item is Attribute)
				return item.name;
			else return item.dataField;
		}
		public function orderData(attrs:Array):void
		{
			//order data
			for (var i:int=0; i<this.dataSequence.length; i++)
			{
				var actualProp:String = getNamePropertyValue(attrs[i]);
				var seqProp:String = dataSequence[i];
				if (actualProp!=seqProp)
				{
					//find and swap
					for (var j:int = 0; j<attrs.length; j++)
					{
						//ds:name, priority, done
						//attrs: description, done, name, priority
						if (objectHasProperty(attrs[j], seqProp))
						{
							//found
							//remove attr[j]
							var prop:* = attrs.splice(j, 1)[0];
							//insert in i position
							attrs.splice(i, 0, prop);
							break;
						}
					}
				}
			}	
		}
		
		public function filter(attrs:Array):Array
		{
			if (showOnlyData.length>0)
				attrs = showData(attrs);
			else
				removeIgnoredData(attrs);
			orderData(attrs);
			return attrs;
		}
		
		private function showData(attrs:Array):Array
		{
			var res:Array = new Array();
			//remove all data not in showOnlyData
			for (var i:int=0; i<attrs.length; i++)
			{
				for each (var propName:String in showOnlyData)
				{
					if (objectHasProperty(attrs[i], propName))
					{
						res.push(attrs[i]);
					}
				}
			}
			return res;
		}
	}
}