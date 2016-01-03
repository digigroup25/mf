package mindmaps.importexport
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.object.hasProperty;

	public class MaxScoreListTest
	{		
		private var list:MaxScoreList;
		
		private var item1:Object = {};
		private var item2:Object = {};
		
		[Before]
		public function setUp():void
		{
			list = new MaxScoreList();
		}
		
		[After]
		public function tearDown():void
		{
			list = null;
		}
		
		[Test]
		public function ctor():void {
			assertThat(list, hasProperty("maxScore", int.MIN_VALUE));
			var items:Array = list.toArray();
			assertThat(items, emptyArray());
		}
		
		[Test]
		public function add1item():void {
			list.add(item1, 0);
			assertThat(list, hasProperty("maxScore", 0));
			assertThat(list, hasProperty("length", 1));
			var items:Array = list.toArray();
			assertThat(items, array(item1));
		}
		
		[Test]
		public function addItemWithHigherScore():void {
			list.add(item1, 0);
			list.add(item2, 1);
			assertThat(list, hasProperty("maxScore", 1));
			assertThat(list, hasProperty("length", 1));
			var items:Array = list.toArray();
			assertThat(items, array(item2));
		}
		
		[Test]
		public function addItemWithLowerScore():void {
			list.add(item1, 1);
			list.add(item2, 0);
			assertThat(list, hasProperty("maxScore", 1));
			assertThat(list, hasProperty("length", 1));
			var items:Array = list.toArray();
			assertThat(items, array(item1));
		}
		
		[Test]
		public function addItemWithSameScore():void {
			list.add(item1, 1);
			list.add(item2, 1);
			assertThat(list, hasProperty("maxScore", 1));
			assertThat(list, hasProperty("length", 2));
			var items:Array = list.toArray();
			assertThat(items, array(item1, item2));
		}
		
		[Test]
		public function clear():void {
			list.add(item1, 1);
			list.clear();
			assertThat(list, hasProperty("maxScore", int.MIN_VALUE));
			assertThat(list, hasProperty("length", 0));
			var items:Array = list.toArray();
			assertThat(items, emptyArray());
		}
	}
}