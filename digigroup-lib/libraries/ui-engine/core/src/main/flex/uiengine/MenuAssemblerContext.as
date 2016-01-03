package uiengine
{
	import mx.collections.ArrayCollection;
	
	public class MenuAssemblerContext
	{
		public var menuRepo:ArrayCollection = new ArrayCollection();
		public var menuAliases:ArrayCollection = new ArrayCollection();
		
		public function MenuAssemblerContext()
		{
		}
		
		public function addMenuDescriptor(item:MenuDescriptor):void {
			menuRepo.addItem(item);
		}
		
		public function addAlias(descriptor:Object):void {
			menuAliases.addItem(descriptor);
		}
	}
}