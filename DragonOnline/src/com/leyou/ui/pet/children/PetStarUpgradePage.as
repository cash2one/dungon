package com.leyou.ui.pet.children {
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetAttackInfo;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Pet;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.ui.pet.PetAttributeUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class PetStarUpgradePage extends AutoSprite {
		private var cAttLbl:Label;

		private var nAttLbl:Label;

		private var cHpLbl:Label;

		private var nHpLbl:Label;

		private var cSpeedLbl:Label;

		private var nSpeedLbl:Label;

		private var cSmartLbl:Label;

		private var nSmartLbl:Label;

		private var cReviveLbl:Label;

		private var nReviveLbl:Label;

		private var costLbl:Label;

		private var cstars:Vector.<Image>;

		private var nstars:Vector.<Image>;

		private var grid:MarketGrid;

		private var costMoneyLbl:Label;

		private var lvUpBtn:NormalButton;

		private var petTId:int;
		private var petTId2:int;

		private var ccritLbl:Label;

		private var ncritLbl:Label;

		private var chitLbl:Label;

		private var nhitLbl:Label;

		private var ccattLbl:Label;

		private var ncattLbl:Label;

		private var nAttributeLbl:Label;

		private var cpetStarInfo:TPetStarInfo;

		private var starLevel:int;

		public function PetStarUpgradePage() {
			super(LibManager.getInstance().getXML("config/ui/pet/serventSX.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			cAttLbl=getUIbyID("cAttLbl") as Label;
			nAttLbl=getUIbyID("nAttLbl") as Label;
			cHpLbl=getUIbyID("cHpLbl") as Label;
			nHpLbl=getUIbyID("nHpLbl") as Label;
			nAttributeLbl=getUIbyID("nAttributeLbl") as Label;
			cSpeedLbl=getUIbyID("cSpeedLbl") as Label;
			nSpeedLbl=getUIbyID("nSpeedLbl") as Label;
			cSmartLbl=getUIbyID("cSmartLbl") as Label;
			nSmartLbl=getUIbyID("nSmartLbl") as Label;
			cReviveLbl=getUIbyID("cReviveLbl") as Label;
			nReviveLbl=getUIbyID("nReviveLbl") as Label;
			lvUpBtn=getUIbyID("lvUpBtn") as NormalButton;
			costLbl=getUIbyID("costLbl") as Label;
			costMoneyLbl=getUIbyID("costMoneyLbl") as Label;
			ccritLbl=getUIbyID("ccritLbl") as Label;
			ncritLbl=getUIbyID("ncritLbl") as Label;
			chitLbl=getUIbyID("chitLbl") as Label;
			nhitLbl=getUIbyID("nhitLbl") as Label;
			ccattLbl=getUIbyID("ccattLbl") as Label;
			ncattLbl=getUIbyID("ncattLbl") as Label;
			var maxStar:int=ConfigEnum.servent9;
			cstars=new Vector.<Image>(maxStar);
			nstars=new Vector.<Image>(maxStar);
			for (var n:int=0; n < maxStar; n++) {
				var star:Image=getUIbyID("cstar" + (n + 1) + "Img") as Image;
				cstars[n]=star;
				star=getUIbyID("nstar" + (n + 1) + "Img") as Image;
				nstars[n]=star;
			}

			grid=new MarketGrid();
			grid.isShowPrice=false;
			grid.x=129 + 11;
			grid.y=244 + 11;
			addChild(grid);
			addChild(costLbl);
			lvUpBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			var tlabel:Label=getUIbyID("star6800Lbl") as Label;
			tlabel.mouseEnabled=true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);

			tlabel=getUIbyID("att6803Lbl") as Label;
			tlabel.mouseEnabled=true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);

			tlabel=getUIbyID("hp6804Lbl") as Label;
			tlabel.mouseEnabled=true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);

			tlabel=getUIbyID("speed6806Lbl") as Label;
			tlabel.mouseEnabled=true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);

			tlabel=getUIbyID("smart6805Lbl") as Label;
			tlabel.mouseEnabled=true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);

			tlabel=getUIbyID("call6807Lbl") as Label;
			tlabel.mouseEnabled=true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);

			tlabel=getUIbyID("crit6808Lbl") as Label;
			tlabel.mouseEnabled=true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);

			tlabel=getUIbyID("hit6809Lbl") as Label;
			tlabel.mouseEnabled=true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);

			tlabel=getUIbyID("cat6810Lbl") as Label;
			tlabel.mouseEnabled=true;
			tlabel.addEventListener(MouseEvent.MOUSE_OVER, onTipsOver);

			EventManager.getInstance().addEvent("petStarLvUp", onStarLevelUp);
		}

		private function onStarLevelUp(pid:int):void {
			UIManager.getInstance().petWnd.playLvUpEffect(1);
		}

		protected function onTipsOver(event:MouseEvent):void {
			var codeStr:String=event.target.name;
			codeStr=codeStr.match(/\d+/)[0];
			var str:String=TableManager.getInstance().getSystemNotice(int(codeStr)).content;
			str=StringUtil.substitute(str, ConfigEnum.servent2);
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, str, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onMouseClick(event:MouseEvent):void {
			Cmd_Pet.cm_PET_U(3, petTId);
			var rnum:int=MyInfoManager.getInstance().getBagItemNumById(cpetStarInfo.item);
			if (rnum < cpetStarInfo.itemNum) {
				UILayoutManager.getInstance().open(WindowEnum.QUICK_BUY);
				UIManager.getInstance().quickBuyWnd.pushItem(cpetStarInfo.item, cpetStarInfo.item);
			}
		}

		private function setCStarLv(lv:int):void {
			var maxStar:int=ConfigEnum.servent9;
			for (var n:int=0; n < maxStar; n++) {
				var star:Image=cstars[n];
				if (lv >= (n + 1)) {
					star.filters=null;
				} else {
					star.filters=[FilterEnum.enable];
				}
			}
		}

		private function setNStarLv(lv:int):void {
			var maxStar:int=ConfigEnum.servent9;
			for (var n:int=0; n < maxStar; n++) {
				var star:Image=nstars[n];
				if (lv >= (n + 1)) {
					star.filters=null;
				} else {
					star.filters=[FilterEnum.enable];
				}
			}
		}

		public function updateInfo($petTId:int):void {

			petTId=$petTId;
			var petEntry:PetEntryData=DataManager.getInstance().petData.getPetById(petTId);
			var level:int=1;
			var starLv:int=1;
			if (null != petEntry) {
				level=petEntry.level;
				
				if (petTId2 != 0 && petTId2 == petTId && starLevel != 0 && starLevel != petEntry.starLv) {
					var pinfo:TPetInfo=TableManager.getInstance().getPetInfo(petTId);
					SoundManager.getInstance().play(pinfo.sound3);
				}
				
				this.starLevel=starLv=petEntry.starLv;
			}
			
			this.petTId2=$petTId;
			
			setCStarLv(starLv);
			setNStarLv(starLv + 1);
			cpetStarInfo=TableManager.getInstance().getPetStarLvInfo(petTId, starLv);
			var npetStarInfo:TPetStarInfo=TableManager.getInstance().getPetStarLvInfo(petTId, starLv + 1);

			var cpetLvInfo:TPetAttackInfo=TableManager.getInstance().getPetLvInfo(starLv, level);
			var npetLvInfo:TPetAttackInfo=TableManager.getInstance().getPetLvInfo(starLv + 1, level);

			costMoneyLbl.text=cpetStarInfo.money + "";
			cHpLbl.text=int(cpetStarInfo.hp + cpetLvInfo.hp) + "";
			cAttLbl.text=int(cpetStarInfo.fixedAtt + cpetLvInfo.fixedAtt) + "";
			cSpeedLbl.text=cpetStarInfo.attSpeed / 1000 + PropUtils.getStringById(2157);
			cSmartLbl.text=PetAttributeUtil.getSmartLv(cpetStarInfo.skillRate);
			cReviveLbl.text=(cpetStarInfo.revive + cpetLvInfo.revive) + PropUtils.getStringById(2146);
			ccritLbl.text=int(cpetStarInfo.critRate / 100) + "%";
			chitLbl.text=int(cpetStarInfo.hitRate / 100) + "%";
			ccattLbl.text=int(cpetStarInfo.slayRate / 100) + "%";

			if (starLv < ConfigEnum.servent9) {
				nAttributeLbl.visible=true;
				nAttLbl.visible=true;
				nHpLbl.visible=true;
				nSpeedLbl.visible=true;
				nSmartLbl.visible=true;
				nReviveLbl.visible=true;
				ncritLbl.visible=true;
				nhitLbl.visible=true;
				ncattLbl.visible=true;
				for each (var simg:Image in nstars) {
					simg.visible=true;
				}

				nHpLbl.text=int(npetStarInfo.hp + npetLvInfo.hp) + "";
				nAttLbl.text=int(npetStarInfo.fixedAtt + npetLvInfo.fixedAtt) + "";
				nSpeedLbl.text=npetStarInfo.attSpeed / 1000 + PropUtils.getStringById(2157);
				nSmartLbl.text=PetAttributeUtil.getSmartLv(npetStarInfo.skillRate);
				nReviveLbl.text=(npetStarInfo.revive + npetLvInfo.revive) + PropUtils.getStringById(2146);
				ncritLbl.text=int(npetStarInfo.critRate / 100) + "%";
				nhitLbl.text=int(npetStarInfo.hitRate / 100) + "%";
				ncattLbl.text=int(npetStarInfo.slayRate / 100) + "%";
			} else {
				nAttributeLbl.visible=false;
				nAttLbl.visible=false;
				nHpLbl.visible=false;
				nSpeedLbl.visible=false;
				nSmartLbl.visible=false;
				nReviveLbl.visible=false;
				ncritLbl.visible=false;
				nhitLbl.visible=false;
				ncattLbl.visible=false;
				for each (var img:Image in nstars) {
					img.visible=false;
				}
			}

			var rnum:int=MyInfoManager.getInstance().getBagItemNumById(cpetStarInfo.item);
			grid.updataById(cpetStarInfo.item);
			costLbl.text=rnum + "/" + cpetStarInfo.itemNum;
		}
	}
}
