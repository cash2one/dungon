package com.leyou.ui.guild.child {

	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TUnion_Bless;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_unb;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;

	public class GuildSciBuyRender extends AutoSprite {

		private var buildBtn:ImgButton;
		private var nameLbl:Label;
		private var bgImg:Image;

		private var selectIndex:int;
		private var selectType:int;

		private var tinfo:TUnion_Bless;

		public function GuildSciBuyRender() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildSciBuyRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.buildBtn=this.getUIbyID("buildBtn") as ImgButton;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.bgImg=this.getUIbyID("bgImg") as Image;

			this.buildBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {

			PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(23211).content, [tinfo.build_Name, tinfo.Upgrade_at]), function():void {
				Cmd_unb.cmGuildBlessBuild(selectIndex, selectType);
				GuildSciArc(parent.parent.parent.parent).hide();
			}, null, false, "guildSciBuild");
		}

		public function updateInfo(info:TUnion_Bless, pos:int):void {

			this.selectIndex=pos;
			this.selectType=info.build_Obj;

			this.nameLbl.text="" + info.build_Name
			this.bgImg.updateBmp("ui/guild/" + info.build_Pic);

			this.tinfo=info;
		}


	}
}
