package com.leyou.ui.dragonBall.children
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDragonBallPropertyInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.dargonball.DragonBallData;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.util.ZDLUtil;
	
	import flash.events.MouseEvent;
	
	public class DragonBallPropertyRender extends AutoSprite
	{
		public var attackProperitys:Vector.<DragonBallPropertyItem>;
		
		public var defentProperitys:Vector.<DragonBallPropertyItem>;
		
		private var plusImg:Image;
		
		private var zdlNum:RollNumWidget;
		
		private var addZdlNum:RollNumWidget;
		
		private var saveBtn:NormalButton;
		
		private var shortcutBtn:NormalButton;
		
		private var costLbl:Label;
		
		public function DragonBallPropertyRender(){
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBall3Render.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			costLbl = getUIbyID("costLbl") as Label;
			plusImg = getUIbyID("plusImg") as Image;
			saveBtn = getUIbyID("saveBtn") as NormalButton;
			shortcutBtn = getUIbyID("shortcutBtn") as NormalButton;
			plusImg.visible = false;
			zdlNum = new RollNumWidget();
			addZdlNum = new RollNumWidget();
			zdlNum.loadSource("ui/num/{num}_zdl.png");
			addZdlNum.loadSource("ui/num/{num}_zdl.png");
			zdlNum.alignLeft();
			addZdlNum.alignLeft();
			
			addChild(zdlNum);
			addChild(addZdlNum);
			zdlNum.x = 108;
			zdlNum.y = 6;
			addZdlNum.y = 6;
			addZdlNum.visible = false;
			
			var aIndex:int;
			var dIndex:int;
			attackProperitys = new Vector.<DragonBallPropertyItem>();
			defentProperitys = new Vector.<DragonBallPropertyItem>();
			var properityDic:Object = TableManager.getInstance().getDragonBallPropertyDic();
			for(var key:String in properityDic){
				var info:TDragonBallPropertyInfo = properityDic[key];
				var properityItem:DragonBallPropertyItem = new DragonBallPropertyItem();
				properityItem.registerListener(onAddDegree);
				properityItem.updateInfo(info);
				addChild(properityItem);
				if(1 == info.propertyType){
					// 攻击属性
					attackProperitys.push(properityItem);
					properityItem.x = 23;
					properityItem.y = 76 + aIndex * 53;
					aIndex++;
				}else if(2 == info.propertyType){
					// 防御属性
					defentProperitys.push(properityItem);
					properityItem.x = 320;
					properityItem.y = 76 + dIndex * 53;
					dIndex++;
				}
			}
			
			saveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			shortcutBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			shortcutBtn.visible = false;
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "saveBtn":
					addProperty();
					break;
				case "shortcutBtn":
					Cmd_Longz.cm_Longz_Z();
					break;
			}
		}
		
		private function addProperty():void{
			var lastItem:DragonBallPropertyItem;
			for each(var saitem:DragonBallPropertyItem in attackProperitys){
				if(0 < saitem.getPropertyValue()){
					if(null == lastItem){
						lastItem = saitem;
						continue;
					}
					Cmd_Longz.cm_Longz_P(saitem.id, saitem.getPropertyValue());
				}
			}
			for each(var sditem:DragonBallPropertyItem in defentProperitys){
				if(0 < sditem.getPropertyValue()){
					if(null == lastItem){
						lastItem = sditem;
						continue;
					}
					Cmd_Longz.cm_Longz_P(sditem.id, sditem.getPropertyValue());
				}
			}
			if(null != lastItem){
				Cmd_Longz.cm_Longz_P(lastItem.id, lastItem.getPropertyValue(), 1);
			}
		}
		
		protected function onAddDegree(item:DragonBallPropertyItem):void{
			regreshRemainProperty();
			plusImg.x = zdlNum.x + zdlNum.width;
			addZdlNum.x = plusImg.x + plusImg.width;
			var zdl:int = ZDLUtil.computation(defentProperitys[0].getPropertyValue(), 0, attackProperitys[0].getPropertyValue(), defentProperitys[1].getPropertyValue(), 0, 0, attackProperitys[1].getPropertyValue(), defentProperitys[2].getPropertyValue(), attackProperitys[2].getPropertyValue(), defentProperitys[3].getPropertyValue(), attackProperitys[3].getPropertyValue(), defentProperitys[4].getPropertyValue(), 0, 0);
			addZdlNum.setNum(zdl);
			addZdlNum.visible = (zdl > 0);
			plusImg.visible = (zdl > 0);
		}
		
		private function regreshRemainProperty():void{
			var value:int = UIManager.getInstance().backpackWnd.lh;
			for each(var aitem:DragonBallPropertyItem in attackProperitys){
				value -= aitem.getUsedVlaue();
			}
			for each(var ditem:DragonBallPropertyItem in defentProperitys){
				value -= ditem.getUsedVlaue();
			}
//			trace("================================")
			for each(var saitem:DragonBallPropertyItem in attackProperitys){
				saitem.setLimit(value + saitem.getUsedVlaue());
			}
			for each(var sditem:DragonBallPropertyItem in defentProperitys){
				sditem.setLimit(value + sditem.getUsedVlaue());
			}
//			trace("================================")
			costLbl.text = (UIManager.getInstance().backpackWnd.lh - value)+"";
		}
		
		public function updateInfo():void{
			var data:DragonBallData = DataManager.getInstance().dragonBallData;
			var properityDic:Object = TableManager.getInstance().getDragonBallPropertyDic();
			var attributes:Object = data.attributes;
			for each(var aitem:DragonBallPropertyItem in attackProperitys){
				aitem.updateCurrentValue(attributes[aitem.id]);
			}
			for each(var ditem:DragonBallPropertyItem in defentProperitys){
				ditem.updateCurrentValue(attributes[ditem.id]);
			}
			var zdl:int = ZDLUtil.computation(attributes[1], 0, attributes[4], attributes[5], 0, 0, attributes[8], attributes[9], attributes[10], attributes[11], attributes[12], attributes[13], 0, 0);
			zdlNum.setNum(zdl);
			regreshRemainProperty();
			costLbl.text="0";
			addZdlNum.visible = false;
			plusImg.visible = false;
		}
	}
}