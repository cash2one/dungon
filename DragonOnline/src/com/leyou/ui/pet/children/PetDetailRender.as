package com.leyou.ui.pet.children
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetAttackInfo;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.pet.PetAttributeUtil;
	import com.leyou.util.ZDLUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	
	public class PetDetailRender extends AutoSprite
	{
		private var qmdLbl:Label;
		
		private var nameLbl:Label;
		
		private var raceLbl:Label;
		
		private var returnLbl:Label;
		
		private var lvLbl:Label;
		
		private var attLbl:Label;
		
		private var hpLbl:Label;
		
		private var smartLbl:Label;
		
		private var attSpeedLbl:Label;
		
		private var reviveLbl:Label;
		
		private var addAttLbl:Label;
		
		private var addDefenceLbl:Label;
		
		private var addHpLbl:Label;
		
		private var addCritLbl:Label;
		
		private var addHitLbl:Label;
		
		private var addSlayLbl:Label;
		
		private var addTenacityLbl:Label;
		
		private var addDodgeLbl:Label;
		
		private var addGuardLbl:Label;
		
		private var numV:RollNumWidget;
		
		private var desLbl:TextArea;
		
		private var switchMethod:Function;
		
		private var cpetId:int;
		
		public function PetDetailRender(){
			super(LibManager.getInstance().getXML("config/ui/pet/serventCard2.xml"))
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			returnLbl = getUIbyID("returnLbl") as Label;
			qmdLbl = getUIbyID("qmdLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			raceLbl = getUIbyID("raceLbl") as Label;
			lvLbl = getUIbyID("lvLbl") as Label;
			attLbl = getUIbyID("attLbl") as Label;
			hpLbl = getUIbyID("hpLbl") as Label;
			smartLbl = getUIbyID("smartLbl") as Label;
			attSpeedLbl = getUIbyID("attSpeedLbl") as Label;
			reviveLbl = getUIbyID("reviveLbl") as Label;
			addAttLbl = getUIbyID("addAttLbl") as Label;
			addDefenceLbl = getUIbyID("addDefenceLbl") as Label;
			addHpLbl = getUIbyID("addHpLbl") as Label;
			addCritLbl = getUIbyID("addCritLbl") as Label;
			addHitLbl = getUIbyID("addHitLbl") as Label;
			addSlayLbl = getUIbyID("addSlayLbl") as Label;
			addTenacityLbl = getUIbyID("addTenacityLbl") as Label;
			addDodgeLbl = getUIbyID("addDodgeLbl") as Label;
			addGuardLbl = getUIbyID("addGuardLbl") as Label;
			desLbl = getUIbyID("desLbl") as TextArea;
			
			var style:StyleSheet = new StyleSheet()
			var aHover:Object = new Object();
			aHover.color = "#ff0000";
			style.setStyle("a:hover", aHover);
			returnLbl.styleSheet = style;
			returnLbl.mouseEnabled = true;
			var text:String = returnLbl.text;
			returnLbl.htmlText = StringUtil_II.addEventString(text, text, true);
			returnLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			numV = new RollNumWidget();
			numV.loadSource("ui/num/{num}_zdl.png");
			numV.alignLeft();
			numV.x = 133;
			numV.y = 227;
			addChild(numV);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			if(null != switchMethod){
				switchMethod.call(this, event);
			}
		}
		
		public function updateInfo(petTId:int):void{
			if(cpetId == petTId){
				return;
			}
			cpetId = petTId;
			
			// 表格数据
			cpetId = petTId;
			var petInfo:TPetInfo = TableManager.getInstance().getPetInfo(petTId);
			
			// 用户数据
			var level:int = 1;
			var qmdLv:int = 1;
			var starLv:int = 1;
			var petEntry:PetEntryData = DataManager.getInstance().petData.getPetById(petTId);
			if(null != petEntry){
				qmdLv = petEntry.qmdLv;
				level = petEntry.level;
				starLv = petEntry.starLv;
			}
			qmdLbl.text = qmdLv+"";
			lvLbl.text = level+"";
			
			// 宠物星级和宠物等级
			var petStarLvInfo:TPetStarInfo = TableManager.getInstance().getPetStarLvInfo(petTId, starLv);
			var petLvInfo:TPetAttackInfo = TableManager.getInstance().getPetLvInfo(starLv, level);
			nameLbl.text = petInfo.name;
			raceLbl.text = PetAttributeUtil.getRaceName(petInfo.race);
			
			attLbl.text = int(petStarLvInfo.fixedAtt*Math.pow(1.05, level/3) + petLvInfo.fixedAtt)+"";
			hpLbl.text = int(petStarLvInfo.hp*Math.pow(1.15, level/13) + petLvInfo.fixedAtt)+"";
			smartLbl.text = PetAttributeUtil.getSmartLv(petStarLvInfo.skillRate);
			reviveLbl.text = (petStarLvInfo.revive+petLvInfo.revive)+PropUtils.getStringById(2146);
			attSpeedLbl.text = petStarLvInfo.attSpeed/1000+PropUtils.getStringById(2157)
			
			// 主人加成
			var rate:Number = Math.pow((10000 + ConfigEnum.servent20)/10000, (qmdLv-1));
			addAttLbl.text = int(petInfo.phyAtt*rate)+"";
			addDefenceLbl.text = int(petInfo.phyDef*rate)+"";
			addHpLbl.text = int(petInfo.hp*rate)+"";
			addCritLbl.text = int(petInfo.crit*rate)+"";
			addHitLbl.text = int(petInfo.hit*rate)+"";
			addSlayLbl.text = int(petInfo.slay*rate)+"";
			addTenacityLbl.text = int(petInfo.tenacity*rate)+"";
			addDodgeLbl.text = int(petInfo.dodge*rate)+"";
			addGuardLbl.text = int(petInfo.guard*rate)+"";
			var zdlNum:int = int(ZDLUtil.computation(petInfo.hp, 0, petInfo.phyAtt, petInfo.phyDef, petInfo.magicAtt, petInfo.magicDef, petInfo.crit, petInfo.tenacity, petInfo.hit, petInfo.dodge, petInfo.slay, petInfo.guard, petInfo.fixedAtt, petInfo.fixedDef)*Math.pow((10000 + ConfigEnum.servent20)/10000, (qmdLv-1)));
			numV.setNum(zdlNum);
			
			desLbl.setText(PropUtils.getStringById(2151));
		}
		
		public function regristerSwitch(method:Function):void{
			switchMethod = method;
		}
	}
}