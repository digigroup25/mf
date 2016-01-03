package collections.tree {
	import collections.*;

	import commonutils.ArrayUtil;

	import mx.utils.ObjectUtil;

	public class TreeWeightSorter implements ITreeSorter {
		private const cloner:TreeCollectionExCloner = new TreeCollectionExCloner();

		private var weightPropertyName:String;

		public function sort(tree:TreeCollectionEx, weightPropertyName:String):TreeCollectionEx {
			var res:TreeCollectionEx = tree;
			this.weightPropertyName = weightPropertyName;
			//var res:TreeCollectionEx = cloner.cloneStructure(tree);
			_sort(res);
			return res;
		}

		private function _sort(tree:TreeCollectionEx):void {
			if (!tree.hasChildren())
				return;

			//sort children
			//uses stable merge sort
			ArrayUtil.sort(tree.children.source, sortFunction);

			//recursively apply sorting to children subtrees
			for each (var child:TreeCollectionEx in tree.children) {
				_sort(child);
			}

		}

		private function sortFunction(a:Object, b:Object, fields:Array = null):int {
			var weightA:Number = a.vo.hasOwnProperty(this.weightPropertyName) ? a.vo[weightPropertyName] : int.MIN_VALUE;
			var weightB:Number = b.vo.hasOwnProperty(this.weightPropertyName) ? b.vo[weightPropertyName] : int.MIN_VALUE;
			var res:int;
			if (weightA == weightB)
				res = 0;
			else if (weightA > weightB)
				res = -1;
			else
				res = 1;
			return res;
		}
	}
}
