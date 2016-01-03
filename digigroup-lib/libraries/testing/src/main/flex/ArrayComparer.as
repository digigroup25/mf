package
{
	public class ArrayComparer
	{
		public static function compare(exp:Array, act:Array):ArrayComparerResult
  		{
  			if (act.length!=exp.length)
  				return new ArrayComparerResult(false, "Different lengths: e=" + exp.length + 
  					", a=" + act.length + ", arrays: " + addCompareMessage(exp, act));
  			for (var i:int = 0; i<act.length; i++)
  			{
  				if (act[i]!=exp[i])
  					return new ArrayComparerResult(false, "Elements are different at position "+
  						i+", arrays: " + addCompareMessage(exp, act));
  			}
  			return new ArrayComparerResult(true, "Arrays are equal");
  		}
  		
  		public static function addCompareMessage(exp:Array, act:Array):String
  		{
  			return "e="+exp.toString()+", a="+act.toString();
  		}
	}
}