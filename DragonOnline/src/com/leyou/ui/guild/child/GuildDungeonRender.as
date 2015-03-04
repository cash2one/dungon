package com.leyou.ui.guild.child {

	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.leyou.utils.FilterUtil;

	/**
	 * 已废 
	 * @author Administrator
	 * 
	 */	
	public class GuildDungeonRender extends AutoSprite {

		private var roleImg:Image;
		private var succImg:Image;
		private var lockImg:Image;

		private var roleAvatar:SwfLoader;

		private var o:Object;

		public function GuildDungeonRender() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildDungeonRender.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {

			this.roleImg=this.getUIbyID("roleImg") as Image;
			this.succImg=this.getUIbyID("succImg") as Image;
			this.lockImg=this.getUIbyID("lockImg") as Image;

			this.roleAvatar=new SwfLoader();
			this.addChild(this.roleAvatar);

			this.addChild(this.succImg);
			this.addChild(this.lockImg);

			this.succImg.visible=false;
			this.lockImg.visible=false;

		}

		public function updateInfo(o:Object):void {

			return ;
//			this.o=o;
//
//			var info:TDungeon_Base=TableManager.getInstance().getGuildCopyInfo(o.cid);
//			var minfo:TLivingInfo=TableManager.getInstance().getLivingInfo(info.DB_Monster);
//
//			this.roleAvatar.update(minfo.pnfId);
//			this.roleAvatar.playAct(PlayerEnum.ACT_STAND, PlayerEnum.DIR_ES);
//
//			this.roleAvatar.x=182 >> 1;
//			this.roleAvatar.y=397 / 2 + 30;
//
//			this.succImg.visible=(o.st == 3);
//			this.lockImg.visible=(o.st == 0);
//
//			if (o.st == 0 || o.st == 4) {
//				this.roleAvatar.filters=[FilterUtil.enablefilter];
//			}

		}

		public function setSelect(v:Boolean):void {

			if (v) {

//				if (this.filters.length == 0) {
//					this.roleAvatar.filters=[];
//				} else {
//					this.roleAvatar.filters=[FilterUtil.enablefilter];
//				}

				this.filters=[FilterUtil.showBorder(0xffff00)];
			} else {

//				if (o.st == 0 || o.st == 4) {
//					this.roleAvatar.filters=[FilterUtil.enablefilter];
//				} else {
//					this.roleAvatar.filters=[];
//				}
				
				this.filters=[];
			}
		}

		public function get data():Object {
			return this.o;
		}

	}
}
