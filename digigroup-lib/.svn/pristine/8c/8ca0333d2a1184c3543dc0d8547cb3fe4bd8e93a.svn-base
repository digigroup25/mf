package uiengine.datarenderer
{
	public class ControlMapItem
	{
		public var type:String; //data type
		private var _dataProperty:String;
		
		public var control:Class; //control type
		public var controlValue:String; //control value where data is assigned to
		public var useObjectHandles:Boolean; //whether control allows object handles
		
		private var _isCustomRenderer:Boolean;
		
		//not used yet
		public function get dataProperty():String {
			return _dataProperty;
		}
		
		public function get isCustomRenderer():Boolean {
			return _isCustomRenderer;
		}
		
		public function ControlMapItem(type:String, control:Class, 
			controlValue:String=null, useObjectHandles:Boolean=true, isCustomRenderer:Boolean=false,
			dataProperty:String=null)
		{
			this.type = type;
			this.control = control;
			this.controlValue = controlValue;
			this.useObjectHandles = useObjectHandles;
			this._isCustomRenderer = isCustomRenderer;
			this._dataProperty = dataProperty;
		}
	}
}