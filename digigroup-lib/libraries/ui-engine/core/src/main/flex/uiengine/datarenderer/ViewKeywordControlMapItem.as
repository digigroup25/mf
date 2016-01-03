package uiengine.datarenderer
{
	public class ViewKeywordControlMapItem
	{
		public var propertyKeyword:String;
		public var control:Class;
		public function ViewKeywordControlMapItem(propertyKeyword:String,
			control:Class)
		{
			this.propertyKeyword = propertyKeyword;
			this.control = control;
		}
	}
}