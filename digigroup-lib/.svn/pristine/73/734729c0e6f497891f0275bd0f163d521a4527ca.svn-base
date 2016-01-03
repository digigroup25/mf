package converters {
	import collections.*;

	import commonutils.*;
	import commonutils.StringUtil;

	import flash.utils.Dictionary;

	import mx.core.ClassFactory;
	import mx.rpc.xml.*;
	import mx.utils.StringUtil;

	public class XmlCollectionConverter_1_2 extends XmlCollectionConverter_1_1 {
		private var ci:ClassInspector = new ClassInspector();

		override public function toXmlString(treeNode:*):String {
			var s:StringBuffer = new StringBuffer();
			s.add("<graph version=\"1.2\">");

			var cur:TreeCollectionEx;
			var it:IIterator = treeNode.createIterator();
			resetTreeNodeIds(it);

			it = treeNode.createIterator();
			var classDefaultInstanceMap:Dictionary = new Dictionary();

			while (it.hasNext()) {
				cur = TreeCollectionEx(it.next());

				var vo:* = cur.vo;
				var defaultInstance:* = getOrCreateDefaultInstance(classDefaultInstanceMap, vo);
				var className:String = ci.getClassName(vo, true);
				s.add("<node id=\"" + cur.id + "\"><data><" + className + ">");
				var attrs:Array = ci.getDataAttributes(vo);

				for each (var attr:Attribute in attrs) {
					if (attr.name == "children")
						continue;
					var value:String = vo[attr.name];
					var defaultValue:String = defaultInstance[attr.name];
					if (value == defaultValue || commonutils.StringUtil.isNullOrEmpty(value))
						continue; //skip translating to xml if actual value is the same as the default value or value is empty
					var encodedValue:String = encode(value);
					//should encode text values instead
					/* var encodedValue:XMLNode = encoder.encodeValue(voValue, new QName(new Namespace(), attr.name),
					new XMLNode(XMLNodeType.ELEMENT_NODE, "")); */
					s.add("<" + attr.name + ">" + encodedValue + "</" + attr.name + ">");
				}
				s.add("</" + className + ">");
				s.add("</data>");
				if ((cur.children != null) && (cur.children.length > 0)) {
					s.add("<relations>");
					for each (var child:TreeCollectionEx in cur.children) {
						s.add("<relation targetNodeId=\"" + child.id + "\" type=\"child\"/>");
					}
					s.add("</relations>");
				}
				s.add("</node>");
			}
			s.add("</graph>");
			return s.toString();
		}

		private function getOrCreateDefaultInstance(map:Dictionary, vo:*):* {
			var clazz:Class = ci.getClass(vo);
			if (map[clazz] == undefined)
				map[clazz] = new clazz();
			return map[clazz];
		}

		private function resetTreeNodeIds(it:IIterator):void {
			var counter:uint = 0;
			var cur:TreeCollectionEx;
			while (it.hasNext()) {
				cur = TreeCollectionEx(it.next());
				cur.id = ++counter;
			}
		}
	}
}
