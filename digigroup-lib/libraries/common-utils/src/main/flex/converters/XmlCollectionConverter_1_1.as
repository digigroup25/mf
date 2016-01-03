package converters {
	import collections.*;

	import commonutils.*;

	import mx.core.ClassFactory;
	import mx.rpc.xml.*;
	import mx.utils.StringUtil;

	public class XmlCollectionConverter_1_1 implements IXmlConverter {
		private var ci:ClassInspector = new ClassInspector();


		/*
		get schema of tree node
		for each (tree node in tree)
			create xml node
				for each attribute in schema
					write attribute to xml node
		*/

		private var _namespace:String = "vos";

		//link to items to be encoded
		//http://www.w3.org/TR/REC-html40/charset.html
		private const charsToEncode:Array = [{ decoded: "&", encoded: "&amp;" }, //make it first, otherwise it would encode ampersands of already encoded values
			{ decoded: "<", encoded: "&lt;" },
			{ decoded: ">", encoded: "&gt;" },
			{ decoded: '"', encoded: "&quot;" }];

		public function set nameSpace(value:String):void {
			_namespace = value;
		}

		public function toXml(treeNode:*):XML {
			//reset counter
			//TreeCollectionEx.counter = 0;
			return new XML(toXmlString(treeNode));
		}

		public function toXmlString(treeNode:*):String {
			//XML.prettyPrinting = false;
			//add node attributes
			//for each child
			//	treeNodeToXml

			//add node attributes
			var res:String = "<graph version=\"1.1\">";


			var counter:int = 0;
			var cur:TreeCollectionEx;
			//var encoder:SimpleXMLEncoder = new SimpleXMLEncoder(null);
			//reset ids
			var it:IIterator = treeNode.createIterator();
			while (it.hasNext()) {
				cur = TreeCollectionEx(it.next());
				cur.id = ++counter;
			}

			it = treeNode.createIterator();
			while (it.hasNext()) {
				cur = TreeCollectionEx(it.next());

				var vo:* = cur.vo;
				res += "<node id=\"" + cur.id + "\"><data><" + ci.getClassName(vo, true) + ">";
				var attrs:Array = ci.getDataAttributes(vo);

				for each (var attr:Attribute in attrs) {
					if (attr.name == "children")
						continue;
					var value:String = vo[attr.name];
					var encodedValue:String = encode(value);
					//should encode text values instead
					/* var encodedValue:XMLNode = encoder.encodeValue(voValue, new QName(new Namespace(), attr.name),
					new XMLNode(XMLNodeType.ELEMENT_NODE, "")); */
					res += "<" + attr.name + ">" + encodedValue + "</" + attr.name + ">";
				}
				res += "</" + ci.getClassName(vo, true) + ">";
				res += "</data>";
				if ((cur.children != null) && (cur.children.length > 0)) {
					res += "<relations>";
					for each (var child:TreeCollectionEx in cur.children) {
						res += "<relation targetNodeId=\"" + child.id + "\" type=\"child\"/>";
					}
					res += "</relations>";
				}
				res += "</node>";
			}
			res += "</graph>"
			return res;
		}

		public function encode(value:String):String {
			if (value == null)
				return value;
			for each (var char:Object in charsToEncode) {
				var r:RegExp = new RegExp(mx.utils.StringUtil.substitute("{0}", char.decoded));
				value = value.replace(r, char.encoded);
			}
			return value;
		}

		public function decode(value:String):String {
			if (value == null)
				return value;
			for each (var char:Object in charsToEncode) {
				var r:RegExp = new RegExp(mx.utils.StringUtil.substitute("{0}", char.encoded));
				value = value.replace(r, char.decoded);
			}
			return value;
		}

		/*
		for each node element in graph
			create node object
			get data element and create vo object parsing all its properties into fields
			if (relations not empty)
				for each (relation in relations)
					put [targetNodeId, node.id] in childParentMap
			if (node.id in childParentMap)
				get parentNodeId (remove from childParentMap)
				find parent based on parentNodeId
				add node as a child to parent
		*/
		public function fromXml(root:XML, treeNode:*):* {
			var nodeList:XMLList = root.node;
			var res:* = null;
			if (nodeList.length() == 0)
				return res; //empty graph

			var nodeTypeName:String = ci.getClassName(treeNode, true);
			var nodeFactory:ClassFactory = new ClassFactory(ci.getClass(treeNode));
			res = nodeFactory.newInstance();

			//for each node element in graph
			var firstNode:Boolean = true;
			var childParentMap:Object = new Object();
			for each (var nodeXml:XML in nodeList) {
				//create node object
				var node:* = nodeFactory.newInstance();
				node.id = nodeXml.@id;
				//TreeCollectionEx.setMaxCounter(node.id);
				var nodeDataXml:XML = XML(nodeXml.data[0]).children()[0];
				var nodeType:String = nodeDataXml.localName().toString();
				var voType:Class = ci.createClass(_namespace + "." + nodeType);
				var vo:* = new voType();
				node.vo = vo;

				xmlToVo(nodeDataXml, vo);

				if (firstNode)
					res = node;
				firstNode = false;

				//if (relations not empty)
				//for each (relation in relations)
				//	put [targetNodeId, node.id] in childParentMap
				var relations:XMLList = nodeXml.relations.children();
				for each (var relation:XML in relations) {
					var targetNodeId:int = int(relation.@targetNodeId);
					childParentMap[targetNodeId] = node.id;
				}

				//if (node.id in childParentMap)
				//	get parentNodeId (remove from childParentMap)
				//	find parent based on parentNodeId
				//	add node as a child to parent
				var parentNodeId:Object = childParentMap[node.id];
				if (parentNodeId != null) {
					var parentNode:* = res.findById(int(parentNodeId));
					//if (parentNode!=null) //VR_Hack: should not need to check
					parentNode.addCollectionItem(node);
				}
			}
			return res;
		}

		protected function xmlToVo(nodeDataXml:XML, vo:*):void {
			return xmlToVoByDataAttributes(nodeDataXml, vo);
		}

		//this is unfinished work, not sure if need to continue
		/*private function xmlToVoByElements(nodeDataXml:XML, vo:*):void {
			for each (var element:XML in nodeDataXml.elements()) {
				var elementName:String = element.name().toString();
				if (!vo.hasOwnProperty(elementName) || element.hasComplexContent())
					continue;
				var elementValue:String = element.toString();
				try {
					if (elementValue == "null") {
						vo[elementName] = null;
						continue;
					}
				} catch (e:Error) {
				}
			}
		}*/

		private function xmlToVoByDataAttributes(nodeDataXml:XML, vo:*):void {
			//get schema of data section
			var dataAttributes:Array = ci.getDataAttributes(vo);

			for each (var attr:Attribute in dataAttributes) {
				if (attr.name == "children")
					continue;
				var c:Class = ci.createClass(attr.type);
				var val:Object = nodeDataXml.elements(attr.name)[0];
				if ((val == "null") || (val == null)) {
					//vo[attr.name] = attr.type == "Number" ? NaN : null;
					continue; //skip assigning null values, let object default values be set instead
				} else if (attr.type == "Date") {
					val = new Date(val.toString());
					//do not convert to date type
					vo[attr.name] = val;
				} else if (attr.type == "String") {
					vo[attr.name] = decode(String(val));
				} else if (attr.type == "Boolean") {
					var booleanString:String = val.toString().toLowerCase();
					var booleanValue:Boolean = booleanString == "false" ? false : new Boolean(booleanString);
					vo[attr.name] = booleanValue;
				} else {
					vo[attr.name] = c(val);
				}
			}
		}
	}
}
