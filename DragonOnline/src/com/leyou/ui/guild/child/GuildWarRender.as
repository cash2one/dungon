package com.leyou.ui.guild.child {


	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Unw;
	import com.leyou.utils.FilterUtil;

	import flash.events.MouseEvent;

	public class GuildWarRender extends AutoSprite {

		private var nameLbl:Label;
		private var lvLbl:Label;
		private var countLbl:Label;
		private var pkingLbl:Label;
		private var powerLbl:Label;
		private var bgimg:Image;
		private var pkBtn:ImgButton;

		private var info:Object;

		public function GuildWarRender() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildWarRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.pkingLbl=this.getUIbyID("pkingLbl") as Label;
			this.powerLbl=this.getUIbyID("powerLbl") as Label;
			this.bgimg=this.getUIbyID("bgimg") as Image;

			this.pkBtn=this.getUIbyID("pkBtn") as ImgButton;

			this.pkBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {

			var lv:int=int(UIManager.getInstance().guildWnd.guildLv);
			
			if (UIManager.getInstance().guildWnd.guildLv < 2)
				Cmd_Unw.cm_GuildPkStart(info[0]);
			else {
				lv=(lv== 2 ? ConfigEnum.union25 : ConfigEnum["union" + (14 + lv)]);

				PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(3072).content, [lv, this.info[1]]), function():void {
					Cmd_Unw.cm_GuildPkStart(info[0]);
				}, null, false, "guildwarpk");
			}

		}

		/**
		 * unionid--行会id
			  uname  --行会名字
			  level  --行会等级
			  zpeople --总行会人数
			  zforce --总战斗力
			  ust    --行会状态（0空闲 1战争中 2等级不足）
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			this.info=o;

			this.nameLbl.text=o[1] + "";
			this.lvLbl.text=o[2] + "";
			this.countLbl.text=o[3] + "";
			this.powerLbl.text=o[4] + "";

			this.pkingLbl.visible=(o[5] == 1);
			this.pkBtn.visible=(o[5] != 1);

			if (o[2] < 2) {
				this.filters=[FilterUtil.enablefilter];
				this.mouseChildren=false;
				this.mouseEnabled=false;
			} else {
				this.filters=[];
				this.mouseChildren=true;
				this.mouseEnabled=true;
			}
		}

		public function setSelectState(i:int=0):void {

			this.bgimg.fillEmptyBmd();

			switch (i) {
				case 0:
					this.bgimg.updateBmp("ui/guild/zhanzhengxyyq.jpg");
					break;
				case 1:
					this.bgimg.updateBmp("ui/guild/zhanzhengxyyq1.jpg");
					break;
				case 2:
					this.bgimg.updateBmp("ui/guild/zhanzhengxyyq2.jpg");
					break;
			}

		}

		override public function get height():Number {
			return 70;
		}

	}
}
