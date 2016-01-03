package persistence
{
	import mx.collections.ArrayCollection;
	
	public interface IPersistor
	{
		function contains(item:*):Object;
		function save(item:*, name:String, useCatalog:Boolean=true): void;
		function remove(name:String, useCatalog:Boolean=true):void;
		function removeAll():void;
		function load(name:String, item:*, types:Array=null):*;
		function loadCatalog(itemType:*=null):ArrayCollection;
		function rename(item:*, oldName:String, newName:String):void;
	}
}