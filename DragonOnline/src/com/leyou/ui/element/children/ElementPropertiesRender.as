package com.leyou.ui.element.children
{
	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TElementInfo;
	import com.ace.gameData.table.TPassivitySkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.vip.child.VipSkillGrid;
	import com.leyou.util.ZDLUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	
	public class ElementPropertiesRender extends AutoSprite
	{
		private var titleLbl:Label;
//		private var skillDesLbl:Label;
		private var property1Lbl:Label;
		private var property2Lbl:Label;
		private var property3Lbl:Label;
		private var property4Lbl:Label;
		private var property5Lbl:Label;
		private var property6Lbl:Label;
//		private var property7Lbl:Label;
		
		private var property1VLbl:Label;
		private var property2VLbl:Label;
		private var property3VLbl:Label;
		private var property4VLbl:Label;
		private var property5VLbl:Label;
		private var property6VLbl:Label;
//		private var property7VLbl:Label;
		
		private var property1AVLbl:Label;
		private var property2AVLbl:Label;
		private var property3AVLbl:Label;
		private var property4AVLbl:Label;
		private var property5AVLbl:Label;
		private var property6AVLbl:Label;
//		private var property7AVLbl:Label;
		
		private var propertyList:Vector.<Label>;
		private var propertyVList:Vector.<Label>;
		private var propertyAVList:Vector.<Label>;
		
		private var upgradeBtn:NormalButton;
		private var hasNext:Boolean;
		private var grid:VipSkillGrid;
		private var num:RollNumWidget;
		
		public function ElementPropertiesRender(){
			super(LibManager.getInstance().getXML("config/ui/element/elementRender2.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			titleLbl = getUIbyID("titleLbl") as Label;
			propertyList = new Vector.<Label>();
			property1Lbl = getUIbyID("property1Lbl") as Label;
			property2Lbl = getUIbyID("property2Lbl") as Label;
			property3Lbl = getUIbyID("property3Lbl") as Label;
			property4Lbl = getUIbyID("property4Lbl") as Label;
			property5Lbl = getUIbyID("property5Lbl") as Label;
			property6Lbl = getUIbyID("property6Lbl") as Label;
//			property7Lbl = getUIbyID("property7Lbl") as Label;
			propertyList.push(property1Lbl);
			propertyList.push(property2Lbl);
			propertyList.push(property3Lbl);
			propertyList.push(property4Lbl);
			propertyList.push(property5Lbl);
			propertyList.push(property6Lbl);
//			propertyList.push(property7Lbl);
			
			propertyVList = new Vector.<Label>();
			property1VLbl = getUIbyID("property1VLbl") as Label;
			property2VLbl = getUIbyID("property2VLbl") as Label;
			property3VLbl = getUIbyID("property3VLbl") as Label;
			property4VLbl = getUIbyID("property4VLbl") as Label;
			property5VLbl = getUIbyID("property5VLbl") as Label;
			property6VLbl = getUIbyID("property6VLbl") as Label;
//			property7VLbl = getUIbyID("property7VLbl") as Label;
			propertyVList.push(property1VLbl);
			propertyVList.push(property2VLbl);
			propertyVList.push(property3VLbl);
			propertyVList.push(property4VLbl);
			propertyVList.push(property5VLbl);
			propertyVList.push(property6VLbl);
//			propertyVList.push(property7VLbl);
			
			propertyAVList = new Vector.<Label>();
			property1AVLbl = getUIbyID("property1AVLbl") as Label;
			property2AVLbl = getUIbyID("property2AVLbl") as Label;
			property3AVLbl = getUIbyID("property3AVLbl") as Label;
			property4AVLbl = getUIbyID("property4AVLbl") as Label;
			property5AVLbl = getUIbyID("property5AVLbl") as Label;
			property6AVLbl = getUIbyID("property6AVLbl") as Label;
//			property7AVLbl = getUIbyID("property7AVLbl") as Label;
			propertyAVList.push(property1AVLbl);
			propertyAVList.push(property2AVLbl);
			propertyAVList.push(property3AVLbl);
			propertyAVList.push(property4AVLbl);
			propertyAVList.push(property5AVLbl);
			propertyAVList.push(property6AVLbl);
//			propertyAVList.push(property7AVLbl);
			
//			skillDesLbl = getUIbyID("skillDesLbl") as Label;
			upgradeBtn = getUIbyID("upgradeBtn") as NormalButton;
			upgradeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			skillDesLbl.multiline = true;
//			skillDesLbl.wordWrap = true;
			num = new RollNumWidget();
			num.x = 71;
			num.y = 30;
			num.loadSource("ui/num/{num}_zdl.png");
			addChild(num);
			
			grid = new VipSkillGrid();
			grid.x = 61;
			grid.y = 218;
			addChild(grid);
		}
		
		public function playCD(skillId:int):void{
			var tskill:TPassivitySkillInfo = TableManager.getInstance().getPassiveSkill(skillId);
			grid.playCD(tskill.cd);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			if(0 == DataManager.getInstance().elementData.ctype){
				return;
			}
			UILayoutManager.getInstance().open(WindowEnum.ELEMENT, WindowEnum.ELEMENT_UPGRADE);
		}
		
		public function updateInfo(elementInfo:TElementInfo, nelementInfo:TElementInfo, elv:int):void{
			var zdl:int = ZDLUtil.computation(elementInfo.extraHp, 0, elementInfo.p_attack, elementInfo.p_defense, 0, 0, elementInfo.crit, elementInfo.tenacity, elementInfo.hit, elementInfo.dodge, elementInfo.slay, elementInfo.guard, 0, 0,0, elementInfo.damageE);
			num.setNum(zdl);
			titleLbl.text = elementInfo.name;
			hasNext = (elv < ConfigEnum.servent15);
			for each(var lbl:Label in propertyList){
				lbl.visible = false;
			}
			for each(var lblv:Label in propertyVList){
				lblv.visible = false;
			}
			for each(var lblav:Label in propertyAVList){
				lblav.visible = false;
			}
			grid.updataInfo(elementInfo.passiveSkill);
			var skillInfo:TPassivitySkillInfo = TableManager.getInstance().getPassiveSkill(elementInfo.passiveSkill);
			
//			var num1:int=(skillInfo.addition1 + skillInfo.addition2 * 1) / 100;
//			var num2:int=skillInfo.addition4 + skillInfo.addition3 * 1;
			
//			skillDesLbl.text = StringUtil.substitute(skillInfo.des/*, num1, num2*/);
			var index:int = 0;
			var plbl:Label = propertyList[index];
			var plblV:Label = propertyVList[index];
			var plblAV:Label = propertyAVList[index];
			if(elementInfo.damageE > 0){
				plbl.visible = true;
				plblV.visible = true;
				plblAV.visible = hasNext;
				if(1 == elementInfo.type){
					plbl.text = PropUtils.getStringEasyById(43);
				}else if(2 == elementInfo.type){
					plbl.text = PropUtils.getStringEasyById(44);
				}else if(3 == elementInfo.type){
					plbl.text = PropUtils.getStringEasyById(45);
				}else if(4 == elementInfo.type){
					plbl.text = PropUtils.getStringEasyById(46);
				}else if(5 == elementInfo.type){
					plbl.text = PropUtils.getStringEasyById(47);
				}
				plblV.text = "+"+elementInfo.damageE;
				if(hasNext){
					plblAV.text = "+"+nelementInfo.damageE;
				}
				index++;
			}
			if(elementInfo.p_attack > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblAV = propertyAVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblAV.visible = hasNext;
				plbl.text = PropUtils.getStringEasyById(4);
				plblV.text = "+"+elementInfo.p_attack;
				if(hasNext){
					plblAV.text = "+"+nelementInfo.p_attack;
				}
				index++;
			}
			if(elementInfo.p_defense > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblAV = propertyAVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblAV.visible = hasNext;
				plbl.text = PropUtils.getStringEasyById(5);
				plblV.text = "+"+elementInfo.p_defense;
				if(hasNext){
					plblAV.text = "+"+nelementInfo.p_defense;
				}
				index++;
			}
			if(elementInfo.extraHp > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblAV = propertyAVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblAV.visible = hasNext;
				plbl.text = PropUtils.getStringEasyById(1);
				plblV.text = "+"+elementInfo.extraHp;
				if(hasNext){
					plblAV.text = "+"+nelementInfo.extraHp;
				}
				index++;
			}
			if(elementInfo.crit > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblAV = propertyAVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblAV.visible = hasNext;
				plbl.text = PropUtils.getStringEasyById(8);
				plblV.text = "+"+elementInfo.crit;
				if(hasNext){
					plblAV.text = "+"+nelementInfo.crit;
				}
				index++;
			}
			if(elementInfo.tenacity > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblAV = propertyAVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblAV.visible = hasNext;
				plbl.text = PropUtils.getStringEasyById(9);
				plblV.text = "+"+elementInfo.tenacity;
				if(hasNext){
					plblAV.text = "+"+nelementInfo.tenacity;
				}
				index++;
			}
			if(elementInfo.hit > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblAV = propertyAVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblAV.visible = hasNext;
				plbl.text = PropUtils.getStringEasyById(10);
				plblV.text = "+"+elementInfo.hit;
				if(hasNext){
					plblAV.text = "+"+nelementInfo.hit;
				}
				index++;
			}
			if(elementInfo.dodge > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblAV = propertyAVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblAV.visible = hasNext;
				plbl.text = PropUtils.getStringEasyById(11);
				plblV.text = "+"+elementInfo.dodge;
				if(hasNext){
					plblAV.text = "+"+nelementInfo.dodge;
				}
				index++;
			}
			if(elementInfo.slay > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblAV = propertyAVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblAV.visible = hasNext;
				plbl.text = PropUtils.getStringEasyById(12);
				plblV.text = "+"+elementInfo.slay;
				if(hasNext){
					plblAV.text = "+"+nelementInfo.slay;
				}
				index++;
			}
			if(elementInfo.guard > 0){
				plbl = propertyList[index];
				plblV = propertyVList[index];
				plblAV = propertyAVList[index];
				plbl.visible = true;
				plblV.visible = true;
				plblAV.visible = hasNext;
				plbl.text = PropUtils.getStringEasyById(13);
				plblV.text = "+"+elementInfo.guard;
				if(hasNext){
					plblAV.text = "+"+nelementInfo.guard;
				}
				index++;
			}
		}
	}
}