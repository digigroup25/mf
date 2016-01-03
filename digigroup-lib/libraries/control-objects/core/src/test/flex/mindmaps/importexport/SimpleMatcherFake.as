package mindmaps.importexport
{
	public class SimpleMatcherFake implements IMatcher
	{
		public static const type:String = "SimpleMatcherFakeType";
		public static const value:* = "SimpleMatcherFakeValue";
		
		public function SimpleMatcherFake()
		{
		}
		
		public function match(value:*):Match
		{
			return new Match(type, value).setScore(1);
		}
	}
}