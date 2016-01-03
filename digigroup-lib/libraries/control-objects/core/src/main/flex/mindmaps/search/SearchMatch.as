package mindmaps.search
{
	public class SearchMatch
	{
		//reference to an object whose property got matched
		public var element:*;
		//property of an object inside which the match was found
		public var elementProperty:*;
		
		//contains all search terms that were matched
		[ArrayElementType(String)]
		public var termsMatched:Array;
		
		public function SearchMatch(element:*, elementProperty:*, termsMatched:Array)
		{
			this.element = element;
			this.elementProperty = elementProperty;
			this.termsMatched = termsMatched;
		}

	}
}