package collections
{
	import mx.collections.*;
	
	public class ArrayCollectionViewer
	{
		private var context:ArrayCollectionViewerContext;

		/**
		 * Returns all items that belong to a particular type
		 * @param collection - initial collection
		 * @param filterClass - class that is to be filtered on
		 * @return 
		 * 
		 */		
		private function filter(collection:ArrayCollection, filterClass:Class):ArrayCollection
		{
			var res:ArrayCollection = new ArrayCollection();
			for each(var item:* in collection)
			{
				if ((filterClass==null) || (item is filterClass) || (item.vo is filterClass))
					res.addItem(item);
			}
			return res;
		}

		//Algorithm:
		//if filter defined - filter
		//sort
		public function createView(collection:ArrayCollection, context:ArrayCollectionViewerContext):ArrayCollection
		{
			this.context = context;
			
			if (context.skipFirst)
				collection.removeItemAt(0);
				
			var filtered:ArrayCollection = filter(collection, context.filterClass); //if filterClass is null, just copies collection over
			if (context.sortByPropName!=null)
			{
				filtered.filterFunction = filterFunction;
				var sort:Sort = new Sort();		
				sort.fields = [new SortField(context.sortByPropName, false, context.descending)];
				sort.compareFunction = compareFunction;
				filtered.sort = sort;
				filtered.refresh();
			}
			return filtered;
		}
		
		//filters out objects having null as their property
		private function filterFunction(item:*):Boolean
		{
			//if (!acFilter.filterFunction(item))
			//	return false;
			if (item.hasOwnProperty("vo"))
				return (item.vo[context.sortByPropName]!=null);
			else return (item[context.sortByPropName]!=null);
		}
		
		private function compareFunction(a:*, b:*, fields:Array=null):int
		{
			var field:* = fields[0];
			var f:String = field.name;
			var res:int;
			if (a.vo[f]==b.vo[f])
				return 0;
			else if (a.vo[f]>b.vo[f]) 
				res=1;
			else res=-1;
			if (context.descending)
				res = -res;
			return res;
		}

		
		/**
		 * Sorts all items
		 * @param collection
		 * @param property
		 * @param descending
		 * @return 
		 * 
		 *		
		public function sortVO(collection:ArrayCollection, property:String, descending:Boolean=false):ArrayCollection
		{
			var res:ArrayCollection = collection;
			var sort:Sort = new Sort();
			sort.fields = [new SortField(property, false, descending)];
			this.descending = descending;
			sort.compareFunction = compareFunction;
			res.sort = sort;
			var val:Boolean = res.refresh();
			return res;
		}		
		*/		
	}
}