package com.leyou.ui.monsterInvade.child {

	import com.ace.enum.EventEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.window.children.SimpleWindow;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Wbs;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MonsterInvadeRender2 extends AutoSprite {

		private var expLbl:Label;
		private var damLbl:Label;
		private var topLbl:Label;
		private var zdlLbl:Label;
		private var exitBtn:ImgButton;
		private var upgradeBtn:ImgButton;
		private var goldLbl:Label;

		private var grid:MonsterInvadeGrid;

		private var wnd:SimpleWindow;

		public function MonsterInvadeRender2() {
			super(LibManager.getInstance().getXML("config/ui/monsterInvade/monsterInvadeRender2.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.expLbl=this.getUIbyID("expLbl") as Label;
			this.damLbl=this.getUIbyID("damLbl") as Label;
			this.topLbl=this.getUIbyID("topLbl") as Label;
			this.zdlLbl=this.getUIbyID("zdlLbl") as Label;
			this.exitBtn=this.getUIbyID("exitBtn") as ImgButton;
			this.upgradeBtn=this.getUIbyID("upgradeBtn") as ImgButton;
			this.goldLbl=this.getUIbyID("goldLbl") as Label;

//			this.exitBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.upgradeBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.upgradeBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.upgradeBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.grid=new MonsterInvadeGrid();
			this.addChild(this.grid);

			this.grid.x=13;
			this.grid.y=53;

			this.grid.updataInfo(TableManager.getInstance().getBuffInfo(ConfigEnum.DemonInvasion4));
			this.goldLbl.text="" + ConfigEnum.DemonInvasion6;


			EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onQuitClick);
		}

		private function onQuitClick():void {
			
			
			if (SceneEnum.SCENE_TYPE_RQCJ == MapInfoManager.getInstance().type) {
				wnd=PopupManager.showConfirm(PropUtils.getStringById(1801), function():void {
					Cmd_Wbs.cmQuitActive();
					NoticeManager.getInstance().stopCount();
				}, null, false, "monsterExit");
			}
			
			
		}

		private function onMouseOver(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, PropUtils.getStringById(1802), new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "exitBtn":
					wnd=PopupManager.showConfirm(PropUtils.getStringById(1801), function():void {
						Cmd_Wbs.cmQuitActive();
					}, null, false, "monsterExit");
					break;
				case "upgradeBtn":
					Cmd_Wbs.cmBuyBuff();
					break;
			}

		}

		/**
		 *
		 */
		public function updateInfo(o:Object):void {
//			this.expLbl.text="" + o.myexp;
			this.damLbl.text="" + o.mydamage;
			this.topLbl.text="" + o.myrank;
			this.zdlLbl.text="" + o.aprop;
		}


	}
}
