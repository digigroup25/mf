package collections
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.core.IsNotMatcher;
	import org.hamcrest.core.not;
	import org.hamcrest.object.hasProperty;

	public class SetTest
	{
		private var set:Set;
		private static const object1:Object = {};
		private static const object2:Object = {};
		
		[Before]
		public function setUp():void
		{
			set = new Set();
		}
		
		[After]
		public function tearDown():void
		{
			set = null;
		}
		
		[Test]
		public function ctor():void {
			assertThat(set.isEmpty());
			assertThat(set, hasProperty("size", 0));
			assertThat(set.toArray(), emptyArray());
		}
		
		[Test]
		public function addPrimitive():void {
			set.add(1);
			assertThat(not(set.isEmpty()));
			assertThat(set.size==1);
			assertThat(set.contains(1));
			assertThat(set.toArray(), array(1));
		}
		
		[Test]
		public function addMultiplePrimitives():void {
			set.add(1);
			set.add(2);
			set.add(3);
			assertThat(not(set.isEmpty()));
			assertThat(set.size==3);
			assertThat(set.contains(1));
			assertThat(not(set.contains(0)));
			assertThat(set.toArray(), array(1,2,3));
		}
		
		[Test]
		public function addSamePrimitiveTwice():void {
			set.add(1);
			set.add(2);
			set.add(2);
			assertThat(set.size==2);
			assertThat(set.contains(2));
			assertThat(set.toArray(), array(1,2));
		}
		
		[Test]
		public function addObject():void {
			set.add(object1);
			assertThat(set.size==1);
			assertThat(set.contains(object1));
			assertThat(set.toArray(), array(object1));
		}
		
		[Test]
		public function addMultipleObjects():void {
			set.add(object1);
			set.add(object2);
			assertThat(set.size==2);
			assertThat(set.contains(object1));
			assertThat(set.toArray(), array(object1, object2));
		}
		
		[Test]
		public function addSameObjectTwice():void {
			set.add(object1);
			set.add(object2);
			set.add(object2);
			assertThat(set.size==2);
			assertThat(set.toArray(), array(object1, object2));
		}
		
		[Test]
		public function addEqualObjectTwice():void {
			set = new Set(true);
			set.add(object1);
			set.add(object2);
			assertThat(set.size==1);
			assertThat(set.toArray(), array(object1));
		}
		
		[Test]
		public function addNullObject():void {
			set.add(null);
			set.add(null);
			assertThat(set.size==1);
			assertThat(set.toArray(), array(null));
		}
		
		[Test]
		public function removeExistingObject():void {
			set.add(object1);
			set.add(object2);
			set.remove(object1);
			assertThat(set.size==1);
			assertThat(set.toArray(), array(object2));
		}
		
		[Test]
		public function removeNonExistentObject():void {
			set.add(object1);
			set.remove(object2);
			assertThat(set.size==1);
			assertThat(set.toArray(), array(object1));
		}
		
		[Test]
		public function removeNonExistentObjectFromEmptySet():void {
			set.remove(object1);
			assertThat(set.size==0);
			assertThat(set.toArray(), emptyArray());
		}
		
		[Test]
		public function clear():void {
			set.clear();
			assertThat(set.size==0);
			assertThat(set.toArray(), emptyArray());
		}
		
		[Test]
		public function indexOfExistingElement_compareByReference():void {
			set.add(object1);
			set.add(object2);
			
			var index:int = set.indexOf(object2);
			
			assertThat(index==1);
		}
		
		[Test]
		public function indexOfExistingElement_compareByValue():void {
			set = new Set(true);
			
			set.add(object1);
			
			var index:int = set.indexOf(object2);
			
			assertThat(index==0);
		}
		
		[Test]
		public function fromArray():void {
			set.fromArray([1,2,2,3]);
			assertThat(set, hasProperty("size", 3));
			assertThat(set.toArray(), [1,2,3]);
		}
		
		[Test]
		public function containsAll():void {
			set.fromArray([1,2,3]);
			var set2:Set = new Set();
			set2.fromArray([1,3]);
			
			var result:Boolean = set.containsAll(set2);
			
			assertThat(result);
		}
		
		[Test]
		public function doesNotContainAll():void {
			set.fromArray([1,2,3]);
			var set2:Set = new Set();
			set2.fromArray([1,4]);
			
			var result:Boolean = set.containsAll(set2);
			
			assertThat(not(result));
		}
		
		[Test]
		public function addAll():void {
			set.fromArray([1,2]);
			var set2:Set = new Set();
			set2.fromArray([1,3]);
			
			set.addAll(set2);
			
			assertThat(set, hasProperty("size", 3));
			assertThat(set.toArray(), array(1,2,3));
		}
		
		[Test]
		public function removeAll():void {
			set.fromArray([1,2]);
			var set2:Set = new Set();
			set2.fromArray([2,3]);
			
			set.removeAll(set2);
			
			assertThat(set, hasProperty("size", 1));
			assertThat(set.toArray(), array(1));
		}
		
		[Test]
		public function retainAll_intersection():void {
			set.fromArray([1,2]);
			var set2:Set = new Set();
			set2.fromArray([2,3]);
			
			set.retainAll(set2);
			
			assertThat(set, hasProperty("size", 1));
			assertThat(set.toArray(), array(2));
		}
		
		[Test]
		public function retainAll_noIntersection():void {
			set.fromArray([1,2]);
			var set2:Set = new Set();
			set2.fromArray([3]);
			
			set.retainAll(set2);
			
			assertThat(set, hasProperty("size", 0));
			assertThat(set.toArray(), emptyArray());
		}
	}
}