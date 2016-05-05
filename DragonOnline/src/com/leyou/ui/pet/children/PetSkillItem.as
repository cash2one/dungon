package com.leyou.ui.pet.children {
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.gameData.table.TPetSkillInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.setting.child.AssistSkillGrid;
	import com.ace.utils.StringUtil;
	import com.leyou.data.playerSkill.TipSkillInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Pet;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.ui.tips.childs.TipsSkillGrid;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class PetSkillItem extends AutoSprite {
		private var closeBtn:NormalButton;

		private var upCostLbl:Label;

		private var lvUpBtn:NormalButton;

		private var learnLbl:Label;

		private var proLbl:Label;

		private var costLbl:Label;

		private var iconBgImg:Image;

		private var iconImg:Image;

		private var clsBtn:ImgButton;

		private var status:int;

		public var index:int;

		private var _petId:int;
		private var _petId2:int;

		private var grid:TipsSkillGrid;

		private var tipInfo:TipSkillInfo;

		private var gpid:int;

		private var level:int;

		public function PetSkillItem() {
			super(LibManager.getInstance().getXML("config/ui/pet/serventJNRender.xml"));
			init();
		}

		public function set petId(value:int):void {
			_petId=value;
		}

		private function init():void {
			mouseChildren=true;
			closeBtn=getUIbyID("clsBtn") as NormalButton;
			upCostLbl=getUIbyID("upCostLbl") as Label;
			lvUpBtn=getUIbyID("lvUpBtn") as NormalButton;
			learnLbl=getUIbyID("learnLbl") as Label;
			proLbl=getUIbyID("proLbl") as Label;
			costLbl=getUIbyID("costLbl") as Label;
			clsBtn=getUIbyID("clsBtn") as ImgButton;

			iconImg=getUIbyID("iconImg") as Image;
			iconBgImg=getUIbyID("iconBgImg") as Image;

			lvUpBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			proLbl.mouseEnabled=true;
			proLbl.addEventListener(MouseEvent.CLICK, onProClick);

			var spt:Sprite=new Sprite();
			spt.addChild(iconBgImg);
			spt.name=iconBgImg.name;
			addChild(spt);
			spt.addEventListener(MouseEvent.CLICK, onBgClick);
			addChild(clsBtn);
			clsBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			grid=new TipsSkillGrid();
			grid.x=iconBgImg.x;
			grid.y=iconBgImg.y;
			addChild(grid);
			tipInfo=new TipSkillInfo();
			grid.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			swapChildren(clsBtn, grid);
		}

		protected function onBtnClick(event:MouseEvent):void {
			Cmd_Pet.cm_PET_S(_petId, gpid, index + 1);
		}

		protected function onMouseOver(event:MouseEvent):void {
			tipInfo.skillInfo=TableManager.getInstance().getSkillById(grid.dataId);
			tipInfo.isPetSkill=true;
			ToolTipManager.getInstance().show(TipEnum.TYPE_SKILL, tipInfo, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
		}

		protected function onBgClick(event:MouseEvent):void {
			switch (status) {
				case 0:
					break;
				case 1:
					UILayoutManager.getInstance().show(WindowEnum.PET_SKILL_SELECT);
					UIManager.getInstance().petSkillSelectWnd.updateInfo(_petId, index + 1, callBack);
					break;
				case 2:
					var skillInfo:TSkillInfo=TableManager.getInstance().getSkillById(grid.dataId);
					var content:String=TableManager.getInstance().getSystemNotice(10074).content;
					content=StringUtil.substitute(content, skillInfo.name);
					PopupManager.showConfirm(content, onConfirm, null, false, "petskill.remove");
					break;
			}
		}

		private function onConfirm():void {
			Cmd_Pet.cm_PET_F(_petId, index + 1);
		}

		private function onProClick(e:MouseEvent):void {

			var petSkilInfo:TPetSkillInfo=TableManager.getInstance().getPetSkill(gpid);
			var tinfo:TItemInfo=TableManager.getInstance().getItemInfo(petSkilInfo.item);

			var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
			swnd.pushItem(tinfo.id, tinfo.id + 1);

			if (ConfigEnum.MarketOpenLevel <= Core.me.info.level)
				UILayoutManager.getInstance().show(WindowEnum.PET, WindowEnum.QUICK_BUY);

		}

		private function callBack(target:AssistSkillGrid):void {
			gpid=target.gid;
			updateSkill(target.dataId);
			var petSkilInfo:TPetSkillInfo=TableManager.getInstance().getPetSkill(gpid);
			var tinfo:TItemInfo=TableManager.getInstance().getItemInfo(petSkilInfo.item);
			proLbl.htmlText="<font color='#" + ItemUtil.getColorByQuality2(tinfo.quality) + "'><u><a href='event:item--" + tinfo.id + "'>" + tinfo.name + "</a></u></font>x" + petSkilInfo.itemNum1;
			costLbl.text=petSkilInfo.money1 + "";
			setStatus(3);
		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "clsBtn":
					if (3 == status) {
						UILayoutManager.getInstance().show(WindowEnum.PET_SKILL_SELECT);
						UIManager.getInstance().petSkillSelectWnd.updateInfo(_petId, index + 1, callBack);
					} else if (2 == status) {
						var skillInfo:TSkillInfo=TableManager.getInstance().getSkillById(grid.dataId);
						var content:String=TableManager.getInstance().getSystemNotice(10074).content;
						content=StringUtil.substitute(content, skillInfo.name);
						PopupManager.showConfirm(content, onConfirm, null, false, "petskill.remove");
					}
					break;
			}
		}

		public function openLv():int {
			switch (index) {
				case 0:
					return ConfigEnum.servent3;
				case 1:
					return ConfigEnum.servent4;
				case 2:
					return ConfigEnum.servent5;
				case 3:
					return ConfigEnum.servent6;
			}
			return 0;
		}

		public function updateSkill(skillId:int):void {
			grid.visible=true;
			var skillInfo:TSkillInfo=TableManager.getInstance().getSkillById(skillId);
			grid.updataInfo(skillInfo);
		}

		public function setStatus($status:int):void {
			grid.visible=(2 == $status || 3 == $status);
			status=$status;
			switch (status) {
				case 0:
					// 锁定状态
					learnLbl.text=StringUtil.substitute(PropUtils.getStringById(2155), openLv());
					iconBgImg.updateBmp("ui/servent/jineng_bg2.jpg");
					clsBtn.visible=false;
					proLbl.visible=false;
					lvUpBtn.visible=false;
					iconImg.visible=false;
					costLbl.visible=false;
					upCostLbl.visible=false;
					learnLbl.visible=true;
					break;
				case 1:
					// 解锁-未学习
					learnLbl.text=PropUtils.getStringById(2156);
					iconBgImg.updateBmp("ui/servent/jineng_bg1.jpg");
					clsBtn.visible=false;
					proLbl.visible=false;
					lvUpBtn.visible=false;
					iconImg.visible=false;
					costLbl.visible=false;
					upCostLbl.visible=false;
					learnLbl.visible=true;
					break;
				case 2:
					// 解锁-已学习
					iconBgImg.updateBmp("ui/servent/jineng_bg3.jpg");
					clsBtn.visible=true;
					proLbl.visible=true;
					lvUpBtn.visible=true;
					iconImg.visible=true;
					costLbl.visible=true;
					upCostLbl.visible=true;
					learnLbl.visible=false;
					clsBtn.updataBmd("ui/other/btn_close.png");
					clsBtn.x=grid.x + grid.width - 28 * 0.5;
					clsBtn.y=grid.y - 28 * 0.5;
					upCostLbl.text=PropUtils.getStringById(2172);
					lvUpBtn.text=PropUtils.getStringById(2174);
					break;
				case 3:
					// 解锁-放入技能状态,尚未学习
					clsBtn.visible=true;
					proLbl.visible=true;
					lvUpBtn.visible=true;
					iconImg.visible=true;
					costLbl.visible=true;
					upCostLbl.visible=true;
					learnLbl.visible=false;
					clsBtn.updataBmd("ui/other/close_btn_add.png");
					clsBtn.x=grid.x + grid.width - 18;
					clsBtn.y=grid.y;
					upCostLbl.text=PropUtils.getStringById(2173);
					lvUpBtn.text=PropUtils.getStringById(2175);
					break;
			}
		}

		public function updateInfo(skill:Array):void {
			if (null == skill)
				return;

			if (skill.length <= 0)
				return;

			setStatus(2);
			gpid=skill[0];

			if (this._petId2 == this._petId && level != skill[1]) {
				var pinfo:TPetInfo=TableManager.getInstance().getPetInfo(_petId);
				SoundManager.getInstance().play(pinfo.sound3);
			}

			this._petId2=this._petId;

			var lv:int=level=skill[1];
			var petSkill:TPetSkillInfo=TableManager.getInstance().getPetSkill(gpid);
			if (null != petSkill) {
				var skillId:int=petSkill["skillId" + lv];
			}

			updateSkill(skillId);

			if (lv >= ConfigEnum.servent8) {
				clsBtn.visible=true;
				proLbl.visible=false;
				lvUpBtn.visible=false;
				iconImg.visible=false;
				costLbl.visible=false;
				upCostLbl.visible=false;
				learnLbl.visible=false;
				return;
			}

			proLbl.text=TableManager.getInstance().getItemInfo(petSkill.item).name + "x" + petSkill["itemNum" + (lv + 1)];
			costLbl.text=petSkill["money" + (lv + 1)];
		}
	}
}
