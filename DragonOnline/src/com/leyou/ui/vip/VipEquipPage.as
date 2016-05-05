package com.leyou.ui.vip
{
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipBlessInfo;
	import com.ace.gameData.table.TPassivitySkillInfo;
	import com.ace.gameData.table.TVIPAttribute;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.vip.TipVipBlessInfo;
	import com.leyou.data.vip.TipVipEquipInfo;
	import com.leyou.net.cmd.Cmd_Vip;
	import com.leyou.ui.vip.child.VipSkillGrid;
	import com.leyou.util.ZDLUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class VipEquipPage extends AutoSprite
	{
		private var equipUpBtn:NormalButton;
		
		private var equipNameImg:Image;
		
		private var jieImg:Image;
		
//		private var fightLbl:Label;
		
		private var wingBlessImg:Image;
		
		private var rideBlessImg:Image;
		
		private var showBtn:ImgLabelButton;
		
		private var rightBtn:ImgButton;
		
		private var leftBtn:ImgButton;
		
		private var phAttLbl:Label;
		
		private var phAttAddLbl:Label;
		
//		private var magicAttAddLbl:Label;
//		
//		private var magicDefAddLbl:Label;
		
		private var phDefAddLbl:Label;
		
		private var hpAddLbl:Label;
		
		private var critLvAddLbl:Label;
		
		private var toughLvAddLb:Label;
		
		private var hitLvAddLbl:Label;
		
		private var dodgeLvAddLbl:Label;
		
		private var killLvAddLbl:Label;
		
		private var guaidLvAddLbl:Label;
		
//		private var magicAttLbl:Label;
		
		private var phDefLbl:Label;
		
//		private var magicDefLbl:Label;
		
		private var hpLbl:Label;
		
		private var critLvLbl:Label;
		
		private var toughLvLbl:Label;
		
		private var hitLvLbl:Label;
		
		private var dodgeLvLbl:Label;
		
		private var killLvLbl:Label;
		
		private var guardLvLbl:Label;
		
//		private var evtInfo:MouseEventInfo;
		
		private var grids:Vector.<VipSkillGrid>;
		
		private var tipInfo:TipVipBlessInfo;
		
		private var movie:SwfLoader;
		
		private var num:RollNumWidget;
		
		private var currentLv:int;
		
		private var vipPayPanel:VipEquipPayPanel;
		
		private var vipLvLbl:Label;
		
		public function VipEquipPage(){
			super(LibManager.getInstance().getXML("config/ui/vip/vipEquipWnd.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			num = new RollNumWidget();
			num.loadSource("ui/num/{num}_zdl.png");
			addChild(num);
			num.alignRound();
			num.x = 140;
			num.y = 410;
			movie = new SwfLoader();
			movie.mouseEnabled = true;
			movie.addEventListener(MouseEvent.MOUSE_OVER, onMovieOver);
			addChild(movie);
			movie.x = 140;
			movie.y = 270;
			tipInfo = new TipVipBlessInfo();
			equipUpBtn = getUIbyID("equipUpBtn") as NormalButton;
			equipNameImg = getUIbyID("equipNameImg") as Image;
			jieImg = getUIbyID("jieImg") as Image;
			wingBlessImg = getUIbyID("wingBlessImg") as Image;
			rideBlessImg = getUIbyID("rideBlessImage") as Image;
			showBtn = getUIbyID("showBtn") as ImgLabelButton;
			rightBtn = getUIbyID("rightBtn") as ImgButton;
			leftBtn = getUIbyID("leftBtn") as ImgButton;
			phAttLbl = getUIbyID("phAttLbl") as Label;
			phAttAddLbl = getUIbyID("phAttAddLbl") as Label;
//			magicAttAddLbl = getUIbyID("magicAttAddLbl") as Label;
//			magicDefAddLbl = getUIbyID("magicDefAddLbl") as Label;
			phDefAddLbl = getUIbyID("phDefAddLbl") as Label;
			hpAddLbl = getUIbyID("hpAddLbl") as Label;
			critLvAddLbl = getUIbyID("critLvAddLbl") as Label;
			toughLvAddLb = getUIbyID("toughLvAddLbl") as Label;
			hitLvAddLbl = getUIbyID("hitLvAddLbl") as Label;
			dodgeLvAddLbl = getUIbyID("dodgeLvAddLbl") as Label;
			killLvAddLbl = getUIbyID("killLvAddLbl") as Label;
			guaidLvAddLbl = getUIbyID("guaidLvAddLbl") as Label;
//			magicAttLbl = getUIbyID("magicAttLbl") as Label;
			phDefLbl = getUIbyID("phDefLbl") as Label;
//			magicDefLbl = getUIbyID("magicDefLbl") as Label;
			hpLbl = getUIbyID("hpLbl") as Label;
			critLvLbl = getUIbyID("critLvLbl") as Label;
			toughLvLbl = getUIbyID("toughLvLbl") as Label;
			hitLvLbl = getUIbyID("hitLvLbl") as Label;
			dodgeLvLbl = getUIbyID("dodgeLvLbl") as Label;
			killLvLbl = getUIbyID("killLvLbl") as Label;
			guardLvLbl = getUIbyID("guaidLvLbl") as Label;
			vipLvLbl = getUIbyID("vipLvLbl") as Label;
			showBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			equipUpBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rightBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			leftBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			equipUpBtn.addEventListener(MouseEvent.MOUSE_OVER, onBtnOver);
			equipUpBtn.addEventListener(MouseEvent.MOUSE_OUT, onBtnOut);
//			evtInfo = new MouseEventInfo();
//			evtInfo.onMouseMove = onMouseMove;
//			MouseManagerII.getInstance().addEvents(wingBlessImg, evtInfo);
//			MouseManagerII.getInstance().addEvents(rideBlessImg, evtInfo);
			var spw:Sprite = new Sprite();
			spw.name = wingBlessImg.name;
			spw.addChild(wingBlessImg);
			addChild(spw);
			var spr:Sprite = new Sprite();
			spr.name = rideBlessImg.name;
			spr.addChild(rideBlessImg);
			addChild(spr);
			spw.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			spr.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			grids = new Vector.<VipSkillGrid>();
			for(var n:int = 0; n < 5; n++){
				var grid:VipSkillGrid = new VipSkillGrid();
				grid.x = 12 + 52 * n;
				grid.y = 336;
				addChild(grid);
				grids[n] = grid;
			}
			x = -12;
			y = 1;
		}
		
		public function playCD(skillId:int):void{
			var grid:VipSkillGrid = getSkillGrid(skillId);
			if(null == grid){
				return;
			}
			var tskill:TPassivitySkillInfo = TableManager.getInstance().getPassiveSkill(skillId);
			grid.playCD(tskill.cd);
		}
		
		private function getSkillGrid(skillId:int):VipSkillGrid{
			for each(var grid:VipSkillGrid in grids){
				if(grid.dataId == skillId){
					return grid;
				}
			}
			return null;
		}
		
		private var tipsInfo:TipVipEquipInfo;
		protected function onMovieOver(event:MouseEvent):void{
			if(null == tipsInfo){
				tipsInfo = new TipVipEquipInfo();
			}
//			tipsInfo.lv = Core.me.info.level;
//			tipsInfo.vipLv = Core.me.info.vipLv;
			ToolTipManager.getInstance().show(TipEnum.TYPE_VIP_QUEIP, tipsInfo, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onBtnOut(event:MouseEvent):void{
			setBless(false);
		}
		
		protected function onBtnOver(event:MouseEvent):void{
			if(Core.me.info.vipLv >= 10 || Core.me.info.vipLv < 1){
				return;
			}
			setBless(true);
			var vipAttribute:TVIPAttribute = TableManager.getInstance().getVipAttribute(Core.me.info.level);
			var vipDetail:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(Core.me.info.vipLv);
			var nvipDetail:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(Core.me.info.vipLv+1);
			var rate:Number = (nvipDetail.rate-vipDetail.rate)*0.01;
			phAttAddLbl.text = "+"+int(vipAttribute.phyAtt*rate);
			hpAddLbl.text = "+"+int(vipAttribute.hp*rate);
//			magicAttAddLbl.text = "+"+int(vipAttribute.maigcAtt*rate);
//			magicDefAddLbl.text = "+"+int(vipAttribute.magicDef*rate);
			phDefAddLbl.text = "+"+int(vipAttribute.phyDef*rate);
			critLvAddLbl.text = "+"+int(vipAttribute.crit*rate);
			toughLvAddLb.text = "+"+int(vipAttribute.tenacity*rate);
			hitLvAddLbl.text = "+"+int(vipAttribute.hit*rate);
			dodgeLvAddLbl.text = "+"+int(vipAttribute.dodge*rate);
			killLvAddLbl.text = "+"+int(vipAttribute.slay*rate);
			guaidLvAddLbl.text = "+"+int(vipAttribute.guard*rate);
		}
		
		public function updateInfo():void{
			vipLvLbl.text = Core.me.info.level+"";
			currentLv = Core.me.info.vipLv;
			var vipLV:int = Core.me.info.vipLv;
			equipUpBtn.setActive(vipLV<10, 1, true );
			if(vipLV < 1){
				if(null == vipPayPanel){
					vipPayPanel = new VipEquipPayPanel();
				}
				addChild(vipPayPanel);
				return;
			}else{
				if(null != vipPayPanel){
					if(null != vipPayPanel && contains(vipPayPanel)){
						removeChild(vipPayPanel);
						vipPayPanel.die();
					}
					vipPayPanel = null;
				}
			}
			var vipInfo:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(vipLV);
			jieImg.updateBmp("ui/horse/horse_lv"+vipLV+".png");
			showLv(vipLV);
//			movie.update(vipInfo.modelBigId);
//			movie.playAct("stand", 4);
			var lVipInfo:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(10);
			var index:int;
			if(lVipInfo.skill1 > 0){
				grids[index].updataInfo({id:lVipInfo.skill1});
				index++;
			}
			if(lVipInfo.skill2 > 0){
				grids[index].updataInfo({id:lVipInfo.skill2});
				index++;
			}
			if(lVipInfo.skill3 > 0){
				grids[index].updataInfo({id:lVipInfo.skill3});
				index++;
			}
			if(lVipInfo.skill4 > 0){
				grids[index].updataInfo({id:lVipInfo.skill4});
				index++;
			}
			if(lVipInfo.skill5 > 0){
				grids[index].updataInfo({id:lVipInfo.skill5});
				index++;
			}
			for each(var grid:VipSkillGrid in grids){
				if(null != grid){
					grid.updateValid();
				}
			}
			var wingLv:int = UIManager.getInstance().roleWnd.wingLv();
			var rideLv:int = UIManager.getInstance().roleWnd.mountLv();
			var wingBless:TEquipBlessInfo;
			var rideBless:TEquipBlessInfo;
			if(wingLv >= 4){
				wingBlessImg.filters = null;
				wingBless = TableManager.getInstance().getVipBlessInfo(2, wingLv);
			}else{
				wingBlessImg.filters = [FilterEnum.enable];
			}
			if(rideLv >= 4){
				rideBless = TableManager.getInstance().getVipBlessInfo(1, rideLv);
				rideBlessImg.filters = null;
			}else{
				rideBlessImg.filters = [FilterEnum.enable];
			}
			var vipAttribute:TVIPAttribute = TableManager.getInstance().getVipAttribute(Core.me.info.level);
			var phyAtt:int = vipAttribute.phyAtt*vipInfo.rate*0.01;
			var magicAtt:int = vipAttribute.maigcAtt*vipInfo.rate*0.01;
			var phDef:int = vipAttribute.phyDef*vipInfo.rate*0.01;
			var magicDef:int = vipAttribute.magicDef*vipInfo.rate*0.01;
			var hp:int = vipAttribute.hp*vipInfo.rate*0.01;
			var crit:int = vipAttribute.crit*vipInfo.rate*0.01;
			var tough:int = vipAttribute.tenacity*vipInfo.rate*0.01;
			var hit:int = vipAttribute.hit*vipInfo.rate*0.01;
			var dodge:int = vipAttribute.dodge*vipInfo.rate*0.01;
			var slay:int = vipAttribute.slay*vipInfo.rate*0.01;
			var guard:int = vipAttribute.guard*vipInfo.rate*0.01;
			if(null != wingBless){
				phyAtt += wingBless.attack;
			}
			if(null != rideBless){
				phyAtt += rideBless.attack;
			}
			if(null != wingBless){
				magicAtt += wingBless.magicAtt;
			}
			if(null != rideBless){
				magicAtt += rideBless.magicAtt;
			}
			if(null != wingBless){
				phDef += wingBless.phyDef;
			}
			if(null != rideBless){
				phDef += rideBless.phyDef;
			}
			if(null != wingBless){
				magicDef += wingBless.magicDef;
			}
			if(null != rideBless){
				magicDef += rideBless.magicDef;
			}
			if(null != wingBless){
				hp += wingBless.hp;
			}
			if(null != rideBless){
				hp += rideBless.hp;
			}
			if(null != wingBless){
				crit += wingBless.crit;
			}
			if(null != rideBless){
				crit += rideBless.crit;
			}
			if(null != wingBless){
				tough += wingBless.tenacity;
			}
			if(null != rideBless){
				tough += rideBless.tenacity;
			}
			if(null != wingBless){
				hit += wingBless.hit;
			}
			if(null != rideBless){
				hit += rideBless.hit;
			}
			if(null != wingBless){
				dodge += wingBless.dodge;
			}
			if(null != rideBless){
				dodge += rideBless.dodge;
			}
			if(null != wingBless){
				slay += wingBless.slay;
			}
			if(null != rideBless){
				slay += rideBless.slay;
			}
			if(null != wingBless){
				guard += wingBless.guard;
			}
			if(null != rideBless){
				guard += rideBless.guard;
			}
			phAttLbl.text = phyAtt+"";
//			magicAttLbl.text = magicAtt+"";
			phDefLbl.text = phDef+"";
//			magicDefLbl.text = magicDef+"";
			hpLbl.text = hp+"";
			critLvLbl.text = crit+"";
			toughLvLbl.text = tough+"";
			hitLvLbl.text = hit+"";
			dodgeLvLbl.text = dodge+"";
			killLvLbl.text = slay+"";
			guardLvLbl.text = guard+"";
			var zdl:int = ZDLUtil.computation(hp, 0, phyAtt, phDef, magicAtt, magicDef, crit, tough, hit, dodge, slay, guard, 0, 0);
			num.setNum(zdl);
			setBless(false);
			setBtnText();
		}
		
		public function showLv(lv:int):void{
			var vipInfo:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(currentLv);
			movie.update(vipInfo.modelBigId);
			movie.playAct("stand", 4);
			jieImg.updateBmp("ui/horse/horse_lv"+currentLv+".png");
			var snUrl:String = "ui/vip/"+vipInfo.equipSourceurl;
			equipNameImg.updateBmp(snUrl);
			if(currentLv >= Core.me.info.vipLv){
				rightBtn.visible = false;
			}else{
				rightBtn.visible = true;
			}
			if(currentLv <= 1){
				leftBtn.visible = false;
			}else{
				leftBtn.visible = true;
			}
		}
		
		public function setBtnText():void{
			var btnText:String = (currentLv==Core.me.info.vipEquipId) ? PropUtils.getStringById(1975) : PropUtils.getStringById(1976);
			showBtn.text = btnText;
		}
		
		private function onMouseOver(event:Event):void{
			switch(event.target.name){
				case "wingBlessImg":
					tipInfo.level = UIManager.getInstance().roleWnd.wingLv();
					tipInfo.type = 2;
					break;
				case "rideBlessImage":
					tipInfo.type = 1;
					tipInfo.level = UIManager.getInstance().roleWnd.mountLv();
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_VIP_BLESS, tipInfo, new Point(stage.mouseX, stage.mouseY));
		}
		
		private function setBless(value:Boolean):void{
			phAttAddLbl.visible = value;
			hpAddLbl.visible = value;
//			magicAttAddLbl.visible = value;
//			magicDefAddLbl.visible = value;
			phDefAddLbl.visible = value;
			critLvAddLbl.visible = value;
			toughLvAddLb.visible = value;
			hitLvAddLbl.visible = value;
			dodgeLvAddLbl.visible = value;
			killLvAddLbl.visible = value;
			guaidLvAddLbl.visible = value;
		}
		
		public function udpateStatus():void{
			setBtnText();
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "equipUpBtn":
					UILayoutManager.getInstance().open(WindowEnum.VIP);
					break;
				case "showBtn":
					var show:int = (currentLv==Core.me.info.vipEquipId) ? 0 : 1;
					Cmd_Vip.cm_VIP_S(show, currentLv);
					break;
				case "rightBtn":
					if(currentLv < Core.me.info.vipLv){
						currentLv++;
						showLv(currentLv);
						setBtnText();
					}
					break;
				case "leftBtn":
					if(currentLv > 1){
						currentLv--;
						showLv(currentLv);
						setBtnText();
					}
					break;
			}
		}
	}
}