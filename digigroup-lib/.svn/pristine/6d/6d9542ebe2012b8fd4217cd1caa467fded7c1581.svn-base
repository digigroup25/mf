package actions
{


	import mx.utils.StringUtil;


	public class ActionParser
	{
		public function ActionParser()
		{
		}


		private static const statusShortToLong:Object = {
			"NS": ActionStatus.NOT_STARTED,
			"CI": ActionStatus.COMPLETING,
			"CD": ActionStatus.COMPLETED,
			"FI": ActionStatus.FAILING,
			"FD": ActionStatus.FAILED
		};


		public function toShortStatus(longStatus:String):String
		{
			for (var key:String in statusShortToLong)
			{
				if (statusShortToLong[key] == longStatus)
				{
					return key;
				}
			}
			throw new Error("Unknown status: " + longStatus);
		}


		public function toLongStatus(shortStatus:String):String
		{
			var res:String = statusShortToLong[shortStatus];
			if (res == null)
			{
				throw new Error("Unknown status: " + shortStatus);
			}
			return res;
		}


		private function removeWhiteSpaces(items:Array):void
		{
			for each (var item:String in items)
			{
				item = StringUtil.trim(item);
			}
		}


		public function parse(factoryObject:Object, value:String):ActionParserResult
		{
			var res:ActionParserResult;
			var parsedValues:Array = value.split(",");
			removeWhiteSpaces(parsedValues);
			var name:String = parsedValues[0];
			var action:AbstractAction;
			if (name == "")
			{
				action = AbstractAction(factoryObject.result);
			}
			else if (isNaN(parseInt(name)))
			{
				action = AbstractAction(factoryObject.accessors[name]);
			}
			else
			{ //number
				action = AbstractAction(factoryObject.result);
				//use each number as an index to children array
				for (var i:int = 0; i < name.length; i++)
				{
					var index:int = parseInt(name.charAt(i));
					if (index < 0 || index >= action.numChildren)
					{
						throw new Error("Trying to access non-existent child at index " + i);
					}
					action = action.children[index];
				}
			}
			var status:String = toLongStatus(parsedValues[1]);
			var targetAction:AbstractAction;
			if (parsedValues.length >= 3)
			{
				targetAction = AbstractAction(factoryObject.accessors[parsedValues[2]]);
			}
			res = new ActionParserResult(action, status, targetAction);
			return res;
		}
	}
}