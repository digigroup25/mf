package {
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class MiscTest {

		[Test]
		public function int_Number_null():void {
			var i:int;
			assertTrue(i == 0);
			assertFalse(isNaN(i));
			var n:Number;
			assertTrue(isNaN(n));
			n = null;
			//	assertTrue(n == null);
		}
	}
}
