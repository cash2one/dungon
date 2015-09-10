package com.leyou.ui.pkCopy {

	import com.ace.enum.EventEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.ui.map.MapWnd;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Wbox;
	import com.leyou.ui.pkCopy.child.DungeonTzGrid;
	import com.leyou.utils.TimeUtil;

	public class DungeondTBTrack extends AutoSprite {

		private var countLbl:Label;
		private var hunLbl:Label;
		private var equipLbl:Label;
		private var eleLbl:Label;
		private var wingLbl:Label;
		private var timeLbl:Label;
		private var ruleLbl:Label;
		private var lvupLbl:Label;
		private var descLbl:Label;

		private var keyLblArr:Array=[];
		private var valueLblArr:Array=[];
		private var gridArr:Array=[];

		private var time:int=0;

		public function DungeondTBTrack() {
			super(LibManager.getInstance().getXML("config/ui/pkCopy/dungeondTBTrack.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.hunLbl=this.getUIbyID("hunLbl") as Label;
			this.equipLbl=this.getUIbyID("equipLbl") as Label;
			this.eleLbl=this.getUIbyID("eleLbl") as Label;
			this.wingLbl=this.getUIbyID("wingLbl") as Label;

			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;
			this.lvupLbl=this.getUIbyID("lvupLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;

			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(5506).content);
			this.descLbl.htmlText="" + StringUtil.substitute(TableManager.getInstance().getSystemNotice(5507).content, [ConfigEnum.dungeonTB15]);

			EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onClick);
		}

		private function onClick():void {

			if (SceneEnum.SCENE_TYPE_LXTB == MapInfoManager.getInstance().type) {
//				PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(9935).content, function():void {
				Cmd_Wbox.cmWboxExit();
				NoticeManager.getInstance().stopCount();
//				}, null, false, "pkcopyLXTBExit");
			}

		}

		/**
		 * open   -- 开始个数
		   energy -- 已获得魂力
		   qhs    -- 强化石
		   ele    -- 元素之心
		   wing   -- 奥杜之羽
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			this.countLbl.text=o.open + "/" + ConfigEnum.dungeonTB11;
			this.hunLbl.text="" + o.energy;
//			this.equipLbl.text="" + o.qhs;
			this.equipLbl.text="" + o.exp;
//			this.eleLbl.text="" + o.ele;
//			this.wingLbl.text="" + o.wing;
//			this.lvupLbl.text="" + o.jsdw;
//			this.wingLbl.text=""
//			this.lvupLbl.text=""

			var render:DungeonTzGrid;
			for each (render in this.gridArr) {
				this.removeChild(render);
			}

			this.gridArr.length=0;

			var item:Object;
			var str:Array;
			var i:int=0;
			for each (str in o.items) {
				render=new DungeonTzGrid();

				this.addChild(render);
				this.gridArr.push(render);

				if (String(str[0]).length == 4)
					item=TableManager.getInstance().getEquipInfo(str[0]);
				else
					item=TableManager.getInstance().getItemInfo(str[0]);

				render.updataInfo(item);
				render.setNum(str[1]);

				render.x=10 + (i % 6) * 42;
				render.y=88 + Math.floor(i / 6) * 42;

				i++;
			}


			this.timeLbl.text="" + TimeUtil.getIntToTime(o.stime);

			this.time=o.stime;

			TimerManager.getInstance().remove(exeTime);
			if (this.time > 0)
				TimerManager.getInstance().add(exeTime);
		}

		private function exeTime(i:int):void {

			if (this.time - i > 0) {
				this.timeLbl.text="" + TimeUtil.getIntToTime(this.time - i);
			} else {
				this.time=0;
				this.timeLbl.text="00:00";
				TimerManager.getInstance().remove(exeTime);
			}

		}

		public function showPanel(o:Object):void {
			this.show();

			this.reSize();
			this.updateInfo(o);

			UIManager.getInstance().smallMapWnd.switchToType(2);
			UIManager.getInstance().rightTopWnd.hideBar(1);
			MapWnd.getInstance().hideSwitch();

			UIManager.getInstance().taskTrack.hide();
			UIManager.getInstance().hideWindow(WindowEnum.PKCOPY);
			UIManager.getInstance().hideWindow(WindowEnum.PKCOPYPANEL);
		}

		public function reSize():void {
			this.x=UIEnum.WIDTH - 270;
			this.y=UIEnum.HEIGHT - 267 >> 1;
		}

	}
}
