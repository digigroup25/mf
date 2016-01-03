package mindmaps.importexport {
	import collections.*;
	import collections.tree.*;

	import mindmaps.map.MapModel2;

	import mx.utils.StringUtil;

	public class MapTextExporter {
		private static const factory:ElementExporterFactory = new ElementExporterFactory();

		private static const defaultIndentationSeparator:String = "\t";

		public function MapTextExporter(indentationSeparator:String = defaultIndentationSeparator) {
			this._indentationSeparator = indentationSeparator;
		}

		private var _indentationSeparator:String;

		public function get indentationSeparator():String {
			return _indentationSeparator;
		}

		public function export(map:MapModel2):String {
			var it:AbstractTreeIterator = new TreeIterator(map.nodes);
			return _export(it);
		}

		public function exportNode(node:TreeCollectionEx):String {
			return _export(new TreeIterator(node));
		}

		private function _export(it:AbstractTreeIterator):String {
			var res:String = "";
			while (it.hasNext()) {
				var item:TreeIteratorItem = it.currentIteratorItem;
				var depth:int = item.depth;
				var indentation:String = getIndentation(depth, indentationSeparator);
				var node:TreeCollectionEx = TreeCollectionEx(it.next());
				var exporter:IElementExporter = factory.getExporter(node.vo);
				var nodeInfo:String = exporter ? exporter.export(node.vo) : node.vo.toString(); // : node.vo.toLongString();
				var row:String = StringUtil.substitute("{0}{1}\n", indentation, nodeInfo);
				res += row;
			}
			return res;
		}

		private function getIndentation(depth:int, indentationSeparator:String):String {
			var res:String = "";
			for (var i:int = 0; i < depth; i++) {
				res += indentationSeparator;
			}
			return res;
		}
	}
}
