package mindmaps.importexport
{
	import mx.collections.ArrayCollection;

	/**Keeps items with the highest score
	 * If an item with a higher score is added
	 * existing elements with the lower score are removed
	 **/
	public class MaxScoreList
	{
		private var list:ArrayCollection;
		private var _maxScore:Number;
		
		public function MaxScoreList()
		{
			reset();
		}
		
		private function reset():void {
			list = new ArrayCollection();
			_maxScore = int.MIN_VALUE;
		}
		
		public function get maxScore():Number {
			return _maxScore;
		}
		
		public function add(item:Object, score:Number):Array {
			var result:Array = [];
			if (score>maxScore) {
				result = list.toArray();
				list.removeAll();
				list.addItem(item);
				_maxScore = score;
			} else if (score==maxScore) {
				list.addItem(item);
			}
			return result;
		}
		
		public function toArray():Array {
			return list.toArray();
		}
		
		public function clear():void {
			reset();
		}
		
		public function get length():uint {
			return list.length;
		}
	}
}