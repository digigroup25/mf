package commonutils {

	public class ArrayUtil {
		// merge sort algorithm
		public static function sort(theArray:Array, compareFunction:Function):void {
			if (theArray.length < 2)
				return;

			var firstHalf:uint = Math.floor(theArray.length / 2);
			var secondHalf:uint = theArray.length - firstHalf;
			var arr1:Array = new Array(firstHalf);
			var arr2:Array = new Array(secondHalf);

			var i:uint = 0;

			for (i = 0; i < firstHalf; i++) {
				arr1[i] = theArray[i];
			}

			for (i = firstHalf; i < firstHalf + secondHalf; i++) {
				arr2[i - firstHalf] = theArray[i];
			}

			sort(arr1, compareFunction);
			sort(arr2, compareFunction);

			i = 0;
			var j:uint = 0;
			var k:uint = 0;

			while (arr1.length != j && arr2.length != k) {
				if (compareFunction(arr1[j], arr2[k]) != 1) {
					theArray[i] = arr1[j];
					i++;
					j++;
				} else {
					theArray[i] = arr2[k];
					i++;
					k++;
				}
			}

			while (arr1.length != j) {
				theArray[i] = arr1[j];
				i++;
				j++;
			}

			while (arr2.length != k) {
				theArray[i] = arr2[k];
				i++;
				k++;
			}

		}
	}
}
