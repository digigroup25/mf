package mindmaps.importexport {
	import collections.TreeCollectionEx;

	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	public class TreeAsserter {
		public function TreeAsserter() {
		}

		/**
		 * Compares whether subTree is a proper subset of tree
		 * @param tree - a tree to be compared against
		 * @param subTree - test object that represents a tree
		 * @return result object {result:true/false, details:{expectedValue:String, actualValue:String, message:String}}
		 *
		 */
		public function isSubset(tree:TreeCollectionEx, subTree:Object):Object {
			return recursiveCompare(tree, subTree);
		}

		private function recursiveCompare(tree:Object, subTree:Object):Object {
			if (tree == null && subTree == null)
				return { result: true };
			if (tree == null && subTree != null)
				return fail('null', 'not null');
			if (tree != null && subTree == null)
				return fail('not null', 'null');

			var result:Object;

			for (var key:String in subTree) {
				if (!tree.hasOwnProperty(key)) {
					return fail(StringUtil.substitute('property {0} exists', key), StringUtil.substitute('property {0} does not exist', key));
				}

				if (ObjectUtil.isSimple(subTree[key])) {
					if (subTree[key] is Array) {
						if (tree[key] == null || !(tree[key].hasOwnProperty("length"))) {
							return fail('non-empty array for property ' + key, 'empty array for property ' + key);
						}
						for (var i:uint = 0; i < subTree[key].length; i++) {
							if (tree[key].length <= i) {
								return fail('have an item at index ' + i, 'no item at index ' + i);
							}
							result = recursiveCompare(tree[key][i], subTree[key][i]);
							if (result.result == false)
								return result;
						}
					} else {
						if (tree[key] != subTree[key]) {
							return fail(
								StringUtil.substitute('property {0} with value {1}', key, subTree[key]),
								StringUtil.substitute('property {0} with value {1}', key, tree[key]));
						}
					}

				} else { //complex
					result = recursiveCompare(tree[key], subTree[key]);
					if (result.result == false)
						return result;
				}
			}
			return { result: true };
		}

		private function getDetails(expectedValue:String, actualValue:String):Object {
			return { expectedValue: expectedValue,
					actualValue: actualValue,
					message: StringUtil.substitute("tree: expected='{0}', actual='{1}'", expectedValue, actualValue)};
		}

		private function fail(expectedValue:String, actualValue:String):Object {
			return { result: false, details: getDetails(expectedValue, actualValue)};
		}
	}
}
