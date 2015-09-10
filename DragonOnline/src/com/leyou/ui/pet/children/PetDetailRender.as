package com.leyou.ui.pet.children
{
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetAttackInfo;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.pet.PetAttributeUtil;
	import com.leyou.util.ZDLUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
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
		
		private var bgImg:Image;
		
		private var critLbl:Label;
		
		private var hitLbl:Label;
		
		private var cattLbl:Label;
		
		public function PetDetailRender(){
			super(LibManager.getInstance().getXML("config/ui/pet/serventCard2.xml"))
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			bgImg = getUIbyID("bgImg") as Image;
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
			critLbl = getUIbyID("critLbl") as Label;
			hitLbl = getUIbyID("hitLbl") as Label;
			cattLbl = getUIbyID("cattLbl") as Label;
			
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
			numV.x = 128;
			numV.y = 235;
			addChild(numV);
			
			var tlabel:Label = getUIbyID("attLbl4") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("defLbl5") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("lifeLbl1") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("critLbl8") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("hitLbl10") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("slayLbl12") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("tenacityLbl9") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("dodgeLbl11") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("guardLbl13") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);
			
			tlabel = getUIbyID("att6803Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onPetTipsOver);
			
			tlabel = getUIbyID("hp6804Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onPetTipsOver);
			
			tlabel = getUIbyID("smart6805Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onPetTipsOver);
			
			tlabel = getUIbyID("attSpeed6806Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onPetTipsOver);
			
			tlabel = getUIbyID("revive6807Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onPetTipsOver);
			
			tlabel = getUIbyID("crit6808Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onPetTipsOver);
			
			tlabel = getUIbyID("hit6809Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onPetTipsOver);
			
			tlabel = getUIbyID("catt6810Lbl") as Label;
			tlabel.mouseEnabled = true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onPetTipsOver);
		}
		
		protected function onPetTipsOver(event:MouseEvent):void{
			var codeStr:String = event.target.name;
			codeStr = codeStr.match(/\d+/)[0];
			var str:String = TableManager.getInstance().getSystemNotice(int(codeStr)).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, str, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onTipsOver(event:MouseEvent):void{
			var codeStr:String = event.target.name;
			codeStr = codeStr.match(/\d+/)[0];
			var str:String = TableManager.getInstance().getSystemNotice(9500 + int(codeStr)).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, str, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			if(null != switchMethod){
				switchMethod.call(this, event);
			}
		}
		
		public function updateInfo(petTId:int):void{
//			if(cpetId == petTId){
//				return;
//			}
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
			
			attLbl.text = int(petStarLvInfo.fixedAtt + petLvInfo.fixedAtt)+"";
			hpLbl.text = int(petStarLvInfo.hp + petLvInfo.hp)+"";
			smartLbl.text = PetAttributeUtil.getSmartLv(petStarLvInfo.skillRate);
			reviveLbl.text = (petStarLvInfo.revive+petLvInfo.revive)+PropUtils.getStringById(2146);
			attSpeedLbl.text = petStarLvInfo.attSpeed/1000+PropUtils.getStringById(2157);
			critLbl.text = int(petStarLvInfo.critRate/100)+"%";
			hitLbl.text = int(petStarLvInfo.hitRate/100)+"%";
			cattLbl.text = int(petStarLvInfo.slayRate/100)+"%";
			
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
			
			desLbl.setText(petInfo.des);
			bgImg.updateBmp("ui/servent/" + petInfo.backBg);
		}
		
		public function regristerSwitch(method:Function):void{
			switchMethod = method;
		}
	}
}