package converters
{
	import collections.*;
	
	import commonutils.*;
	
	import mx.core.ClassFactory;
	import mx.rpc.xml.*;
	
	public class XmlCollectionConverter_1_0 implements IXmlConverter
	{
		private var ci:ClassInspector = new ClassInspector();
		
		/*
		get schema of tree node 
		for each (tree node in tree)
			create xml node
				for each attribute in schema
					write attribute to xml node
		*/
		
		private var _namespace:String = "vos";
		public function set nameSpace(value:String):void
		{
			_namespace = value;
		}
		public function toXml(treeNode:*):XML
		{
			//reset counter
			//TreeCollectionEx.counter = 0;
			return new XML(toXmlString(treeNode));
		}
		
		public function toXmlString(treeNode:*):String
		{
			//add node attributes
			//for each child
			//	treeNodeToXml
			
			//add node attributes
			var res:String = "<graph version=\"1.0\">";
			
			var it:IIterator = treeNode.createIterator();
			var counter:int = 0;
			var cur:TreeCollectionEx;
			//reset ids
			while (it.hasNext())
			{
				
				cur = TreeCollectionEx(it.next());
				cur.id = ++counter;
			}
			
			it = treeNode.createIterator();
			while (it.hasNext())
			{
				cur = TreeCollectionEx(it.next());
				//TreeCollectionEx.counter++;
				
				var vo:* = cur.vo;
				res += "<node id=\""+cur.id /*TreeCollectionEx.counter*/+"\"><data><"+ci.getClassName(vo, true)+" ";
				var attrs:Array = ci.getDataAttributes(vo);
	
				for each(var attr:Attribute in attrs)
				{
					if (attr.name=="children")
						continue;
					res+=attr.name+"=\""+vo[attr.name]+"\" ";
				}
				res +="/>";
				res +="</data>";
				if ((cur.children!=null) && (cur.children.length>0))
				{
					res += "<relations>";
					for each (var child:TreeCollectionEx in cur.children)
					{
						res += "<relation targetNodeId=\"" + child.id + "\" type=\"child\"/>";
					}
					res += "</relations>";
				}
				res += "</node>";
			}
			res += "</graph>"
			return res;
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
		public function fromXml(root:XML, treeNode:*):*
		{
			var nodeList:XMLList = root.node;
			var res:* = null;
			if (nodeList.length()==0)
				return res;  //empty graph
				
			var nodeTypeName:String = ci.getClassName(treeNode, true);
			var nodeFactory:ClassFactory = new ClassFactory(ci.getClass(treeNode));
			res = nodeFactory.newInstance();
			
			//for each node element in graph
			var firstNode:Boolean = true;
			var childParentMap:Object = new Object();
			for each (var nodeXml:XML in nodeList)
			{
				//create node object
				var node:* = nodeFactory.newInstance();
				node.id = nodeXml.@id;
				//TreeCollectionEx.setMaxCounter(node.id);
				var nodeDataXml:XML = XML(nodeXml.data[0]).children()[0];
				var nodeType:String = nodeDataXml.localName().toString();
				var voType:Class = ci.createClass(_namespace+"."+nodeType);
				var vo:* = new voType();
				node.vo = vo;
				
				//get schema of data section
				var attrs:Array = ci.getDataAttributes(vo);
				
				//for each attribute in schema
				for each(var attr:Attribute in attrs)
				{
					if (attr.name=="children")
						continue;
					var c:Class = ci.createClass(attr.type);
					var val:Object = nodeDataXml.attribute(attr.name)[0];
					if ((val=="null") || (val==null))
						vo[attr.name] = null;
					else
					{
						if (attr.type=="Date")
						{
							val = new Date(val.toString());
							//do not convert to date type
							vo[attr.name] = val;
						}
						else
							vo[attr.name] = c(val);
					}
				}
				if (firstNode)
					res = node;
				firstNode = false;
				
				//if (relations not empty)
				//for each (relation in relations)
				//	put [targetNodeId, node.id] in childParentMap
				var relations:XMLList = nodeXml.relations.children();
				for each (var relation:XML in relations)
				{
					var targetNodeId:int = int(relation.@targetNodeId);
					childParentMap[targetNodeId] = node.id;
				}
				
				//if (node.id in childParentMap)
				//	get parentNodeId (remove from childParentMap)
				//	find parent based on parentNodeId
				//	add node as a child to parent
				var parentNodeId:Object = childParentMap[node.id];
				if (parentNodeId!=null)
				{
					var parentNode:* = res.findById(int(parentNodeId));
					//if (parentNode!=null) //VR_Hack: should not need to check
					parentNode.addCollectionItem(node);
				}
			}
			return res;
		}
	}
}