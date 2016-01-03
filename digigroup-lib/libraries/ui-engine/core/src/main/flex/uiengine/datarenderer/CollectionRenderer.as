package uiengine.datarenderer
{
	import collections.tree.ITreeData;
	
	import commonutils.*;
	
	import mx.controls.*;
	import mx.controls.dataGridClasses.*;
	import mx.core.*;
	
	import reflection.*;
	
	import uiengine.*;
	
	public class CollectionRenderer extends AbstractDataRenderer
	{
		private var voInspector:VOInspector = new VOInspector();
		private var uiControlUtil:UIControlUtil = new UIControlUtil();
		
		protected override function assignContainer(context:DataRendererContext):UIComponent
		{
			var res:UIComponent;
			if (context.vo is ITreeData)
			{
				var tree:Tree = new Tree();
				tree.percentWidth = 100;
				tree.dragEnabled = true;
				tree.dropEnabled = true;
				res = tree;
			}
			else if (context.vo.length==0)
			{
				var label:Label = new Label();
				label.text = "empty";
				res = label;
			} 
			else
			{
				var grid:DataGrid = new DataGrid();
				grid.percentWidth = 100;
				res = grid;
			}
			res.percentHeight = 100;
			return res;
		}
		
		protected override function getAllProperties(context:DataRendererContext, container:UIComponent):Array
		{
			if (context.vo is ITreeData)
				return null;
			var d:DataGrid = DataGrid(container);
			d.dataProvider = context.vo;
			//d.selectedIndex = 0;
			//d.editable = true;
			
			if (context.vo[0].hasOwnProperty("vo"))
			{
				//create new columns based on vo properties
				var attrs:Array = new ClassInspector().getDataAttributes(context.vo[0].vo);
				var columns:Array = new Array();
				for each (var attr:Attribute in attrs)
				{
					var column:DataGridColumn = new DataGridColumn(attr.name);
					columns.push(column);
				}
				d.columns = columns;
				//assign size to each column
				autoSizeColumns(context, d, attrs);
				d.labelFunction = labelFunction;
			}
			
			return d.columns;
		}
		
		protected function autoSizeColumns(context:DataRendererContext, control:DataGrid, attrs:Array):void
		{
			var i:int=0;
			for each (var attr:Attribute in attrs)
			{
				var r:DataGridItemRenderer = new DataGridItemRenderer();
				control.addChild(r);
				var textToMeasure:String;
				var voText:String = context.vo[0].vo[attr.name];
				if (voText==null) voText = "";
				var headerText:String = control.columns[i].headerText;
				if (voText.length>headerText.length)
					textToMeasure = voText;
				else textToMeasure = headerText;
				r.text = textToMeasure;
				control.columns[i].width = r.measuredWidth+10;
				control.removeChild(r);
				i++;
			}
		}
		
		protected override function assignDataToControl(context:DataRendererContext, container:UIComponent, properties:Array):void
		{
			if (context.vo is ITreeData)
				Tree(container).dataProvider = context.vo;
			else
				DataGrid(container).columns = properties;
		}
		
		protected override function addEventHandling(context:DataRendererContext, container:UIComponent):void
		{
			//UIControlUtil.addEventListener(container, MouseEvent.CLICK, ObjectListener.getInstance().onObjectSelect);
			
		}
		
		private function labelFunction(item:Object, column:DataGridColumn):String
		{
			return item.vo[column.dataField];
		}
	}
}