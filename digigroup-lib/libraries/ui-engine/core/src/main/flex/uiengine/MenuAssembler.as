package uiengine
{
	import actions.AbstractUserAction;
	
	import commonutils.ClassInspector;
	
	import mf.framework.IMessageBroker;
	import mf.framework.Message;
	
	
	public class MenuAssembler
	{
		private var ci:ClassInspector = new ClassInspector();
		private var mb:IMessageBroker;
		private var menuLookup:Object;
		private var context:MenuAssemblerContext;
		
		public function MenuAssembler(mb:IMessageBroker, context:MenuAssemblerContext){
			this.mb = mb;
			this.context = context;
		}
		
		private function getAlias(vo:*):String {
			var voAlias:String = ci.getClassName(vo, true);
			for each (var o:Object in context.menuAliases) {
				if (o.name==voAlias) return o.alias;
			}
			return voAlias;
		}
		
		private function addVoActions(allActions:ActionRepository, vo:*, root:MessageableUserAction):void {
			if (vo==null) return; //if no vo present, return 
			var actionz:Array = allActions.getByVOType(ci.getClass(vo));
			//if contains another vo, add actionz for this vo
			if (vo.hasOwnProperty("vo")) {
				var voActions:Array = allActions.getByVOType(ci.getClass(vo.vo));
				actionz = actionz.concat(voActions);
			}
						//set vo 
			var originalVo:* = vo; //used to pass to menuGenerator
			vo = (vo.hasOwnProperty("vo")) ? vo.vo : vo;
			var menuName:String = getAlias(vo);//(voAlias==null) ? ci.getClassName(vo, true) : voAlias;
			var voMenu:MessageableUserAction = getMenuNode(menuName); //create vo menu
			
			
			for each (var action:ActionDescriptor2 in actionz){
				var menuLabel:String = getMenuLabel(action, vo);
				var menuNode:MessageableUserAction = getMenuNode(menuLabel);
				var menuDescriptor:MenuDescriptor = getMenuDescriptor(action.label);
				var newNode:MessageableUserAction;
				if (menuDescriptor!=null) {
					//if menuDescriptor has a different name for menu label
					if (menuNode.label!=menuDescriptor.menuLabel) {
						newNode = new MessageableUserAction(mb, action.label);
						menuNode.addChild(newNode);
						menuNode = newNode;
					}
					//create new menu generator
					menuNode.menuGenerator = new menuDescriptor.menuGeneratorClass(
						menuDescriptor.menuGeneratorParams, originalVo);
				}
				else {
					var messageBody:Object = originalVo;
					newNode = new MessageableUserAction(mb, action.label, 
						new Message(action.messageType, menuNode, messageBody), null);
					menuNode.addChild(newNode);
				}
				
			}
			for each (var topMenu:MessageableUserAction in menuLookup){
				root.addChild(topMenu);
			}
		}
		
		private function addNonVoActions(allActions:ActionRepository, root:MessageableUserAction):void {
			var nonVoActions:Array = allActions.getNonVoActions();
			if (nonVoActions.length==0) return;
			//add top level action
			var topAction:MessageableUserAction = new MessageableUserAction(null, "Actions");
			
			for each (var action:AbstractUserAction in nonVoActions) {
				var availableActions:Array = action.getAvailableActions();
				topAction.addChildren(availableActions);
			}
				
			root.addChild(topAction);
		}
		
		public function assemble(allActions:ActionRepository, vo:*, includeVoActions:Boolean=true,
			includeNonVoActions:Boolean=true):MessageableUserAction {
			menuLookup = new Object();

			var root:MessageableUserAction = new MessageableUserAction(null, null);//has empty root node
			if (includeVoActions) addVoActions(allActions, vo, root);
			if (includeNonVoActions) addNonVoActions(allActions, root);
			
			root.initialize(); //execute menu generators 
			return root;
		}
		
		//applies additional mappings for menu defined in the constructor 
		private function getMenuLabel(action:ActionDescriptor2, vo:*):String {
			for each (var menu:MenuDescriptor in context.menuRepo) {
				if (menu.actionLabel==action.label){
					if (menu.menuLabel==null)
						break; //return name of object
					return menu.menuLabel;
				}
					
			}
			//return name of object
			
			return getAlias(vo);//ci.getClassName(vo, true);
		}
		
		private function getMenuNode(name:String):MessageableUserAction {
			if (menuLookup[name]==undefined) {
				menuLookup[name] = new MessageableUserAction(mb, name);
			}
			return menuLookup[name];
		}
		
		private function getMenuDescriptor(actionLabel:String):MenuDescriptor {
			for each (var menu:MenuDescriptor in context.menuRepo) {
				if (menu.actionLabel == actionLabel) return menu;
			}
			return null;
		}
		
	}
}