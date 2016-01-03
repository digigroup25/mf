package mindmaps.map.ui
{
	import collections.TreeCollectionEx;
	
	import commonutils.ClassInspector;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mf.framework.AbstractController;
	import mf.framework.Message;
	
	import mindmaps.map.MapModel2;
	import mindmaps.map.NodeLocation;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;
	import mindmaps.map.ui.tree.components.TreeView2;
	
	import mindmaps2.map.ui.controllers.NodeState;
	
	import mx.controls.Tree;
	import mx.events.ListEvent;

	[Deprecated(message="Delete this class",replacement="MindMapTreeKeyboardController",since="")]
	public class NodeKeyboardInteractionController extends AbstractController
	{
		private var map:MapModel2;
		private var messages:NodeMessageFactory;
		private var nodeToRemoveIndex:int = -1;
		private var nodeState:NodeState;
		private var nodeToCutOrCopy:TreeCollectionEx;
		private var nodeToCutOrCopyParent:TreeCollectionEx;
		private var cutOrCopyOperation:String = null;
		
		private var prevActionMessage:Message = null; //holds last action that can be undoed
		
		private const ci:ClassInspector = new ClassInspector();
		
		private function get thisView():TreeView2 { return TreeView2(this.model); }
		private function get thisModel():MapModel2 { return MapModel2(map); }
		private function get treeView():Tree { 
			return Tree(thisView.allNodes.getChildAt(0));
		}
		
		private function get selectedNode():TreeCollectionEx { return TreeCollectionEx(treeView.selectedItem); }
		
		private function get state():String {
			return nodeState.state;
		}
		private function set state(value:String):void {
			nodeState.state = value;
		}
		
		private static const CUT:String = "cut";
		private static const COPY:String = "copy";
		
		public function NodeKeyboardInteractionController(map:MapModel2, nodeState:NodeState)
		{
			this.map = map;
			this.nodeState = nodeState;
			this.messages = new NodeMessageFactory(this);
		}
		
		public override function initialize():void {
			super.initialize();
			
			//instead of callLater, removes listener explicitly in renderAllNodes
			thisView.addEventListener(Event.RENDER, onRender);
			
		}
		
		override public function receive(m:Message):void {
			switch (m.name) {
				case NodeMessages.REMOVE_NODE: 	prevActionMessage = m; 	break;
				case NodeMessages.REMOVED_NODE: onRemovedNode(m); 		break;
			}
		}
		
		
		private function onRemovedNode(m:Message):void {
			treeView.selectedIndex = nodeToRemoveIndex-1;
		}
		
		private function onRender(e:Event):void {
			treeView.addEventListener(KeyboardEvent.KEY_UP, onKeyPress, false, 0, true);
			thisView.removeEventListener(Event.RENDER, onRender);
		}
		
		private function onKeyPress(event:KeyboardEvent):void {
			trace("onKeyPress", event.keyCode, event.ctrlKey, event.altKey, event.shiftKey);
			var key:uint = event.keyCode;
			
			var parentNode:TreeCollectionEx;
			var curNode:TreeCollectionEx;
			
			//insert as sibling
			if ((key==Keyboard.ENTER) && (!event.ctrlKey) && (!event.shiftKey) && (!event.altKey)) {
				if (state==NodeState.EDITING) {
					state = NodeState.UNSELECTED;
					return;
				}
				parentNode = TreeCollectionEx(selectedNode.findParent(thisModel.nodes));
				addNewNode(parentNode, selectedNode, selectedNode);
			}
			//insert as parent
			else if ((key==Keyboard.ENTER) && (event.altKey)) {
				//get parent
				curNode = TreeCollectionEx(selectedNode.findParent(thisModel.nodes));
				if (curNode==null) return;
				parentNode = TreeCollectionEx(curNode.findParent(thisModel.nodes));
				addNewNode(parentNode, curNode, selectedNode);
			}
			//insert as child
			else if ((key==Keyboard.INSERT) || ((key==Keyboard.ENTER) && ((event.ctrlKey) || (event.shiftKey)))) {
				addNewNode(selectedNode, selectedNode, selectedNode);
			}
			//delete node
			else if ((key==Keyboard.DELETE) || (key==Keyboard.BACKSPACE)) {
				if (state==NodeState.EDITING) return;
				curNode = selectedNode;
				parentNode = TreeCollectionEx(curNode.findParent(thisModel.nodes));
				if (parentNode==null) return;
				
				var curNodeIndex:int = parentNode.getChildIndex(curNode);
				nodeToRemoveIndex = treeView.selectedIndex;
				var message:Message = messages.RemoveNode(curNode, new NodeLocation(parentNode, curNodeIndex));
				//prevActionMessage = message;
				send(message);
			}
			else if (((key==90/*z*/) || (key==26)) && event.ctrlKey) {
				if (prevActionMessage==null)
					return;
				if (prevActionMessage.name == NodeMessages.REMOVE_NODE) {
					var location:NodeLocation = NodeLocation(prevActionMessage.body.location);
					parentNode = location.parentNode; 
					var childNodeIndex:int = location.childNodeIndex;
					var node:TreeCollectionEx = TreeCollectionEx(prevActionMessage.body.node);
					state = NodeState.UNDOING;
					send(messages.AddNode(node, new NodeLocation(parentNode, childNodeIndex)));
					prevActionMessage = null;
				}
			}
			else if ((key==113/*F2*/) || (key==Keyboard.SPACE)) {
				//send(messages.SelectedNode(TreeCollectionEx(treeView.selectedItem).vo));
				if (state!=NodeState.EDITING) {
					state = NodeState.EDITING;
					treeView.dispatchEvent(new ListEvent(ListEvent.ITEM_EDIT_BEGINNING, false, false, 0, treeView.selectedIndex));
				}
			}
			//cut
			else if ((key==24/*x*/) && event.ctrlKey) {
				nodeToCutOrCopy = selectedNode;
				nodeToCutOrCopyParent = TreeCollectionEx(nodeToCutOrCopy.findParent(thisModel.nodes));
				cutOrCopyOperation = CUT;
			}
			//copy
			else if ((key==3/*c*/) && event.ctrlKey) {
				nodeToCutOrCopy = selectedNode;
				nodeToCutOrCopyParent = TreeCollectionEx(nodeToCutOrCopy.findParent(thisModel.nodes));
				cutOrCopyOperation = COPY;
			}
			//paste
			else if ((key==22/*v*/) && event.ctrlKey) {
				if (nodeToCutOrCopy==null) return;
				curNode = selectedNode;
				if ((nodeToCutOrCopyParent==null) || (curNode==null)) return;
				if (nodeToCutOrCopy==curNode) return;
				
				if (cutOrCopyOperation == COPY) {
					var clone:TreeCollectionEx = TreeCollectionEx(nodeToCutOrCopy.clone());
					curNode.addChild(clone);
				}
				else if (cutOrCopyOperation == CUT) {
					nodeToCutOrCopyParent.removeChild(nodeToCutOrCopy);
					curNode.addChild(nodeToCutOrCopy);
					//cut and past can only be done once
					nodeToCutOrCopy=null;
					nodeToCutOrCopyParent=null;
				}
				updateTree();
				
			}
		}
		
		private function updateTree():void {
			this.treeView.validateNow();
		}
		
		private function addNewNode(parent:TreeCollectionEx, sibling:TreeCollectionEx, nodePrototype:TreeCollectionEx):void {
			if ((parent==null) || (sibling==null) || (nodePrototype==null)) return;
			var nodeType:Class = ci.getClass(nodePrototype.vo);
			var token:Object = {reason:"new"};
			var message:Message = (parent==sibling) ? messages.AddChildNodeType(nodeType, parent, token) :
				messages.AddSiblingNodeType(nodeType, parent, sibling, token);
			send(message);
		}
		
		override public function uninitialize():void {
			//using weak reference
			//treeView.removeEventListener(KeyboardEvent.KEY_UP, onKeyPress);
			super.uninitialize();
		}
	}
}