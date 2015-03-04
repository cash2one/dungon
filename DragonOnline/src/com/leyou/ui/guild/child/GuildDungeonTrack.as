package com.leyou.ui.guild.child {


	import com.ace.enum.EventEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.EventManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.ui.map.MapWnd;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.smallMap.SmallMapWnd;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Guide;
	import com.leyou.net.cmd.Cmd_Ucp;
	import com.leyou.ui.question.childs.QuestionBtn;
	import com.leyou.ui.question.childs.QuestionQBtn;

	import flash.events.MouseEvent;

	public class GuildDungeonTrack extends AutoSprite {

		private var countLbl:Label;
		private var bgLbl:Label;
		private var itemlist:ScrollPane;

		private var itemLblArr:Array=[];

		private var quitBtn:QuestionQBtn;

		public function GuildDungeonTrack() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildDungeonTrack.xml"));
			this.init();
			this.mouseEnabled=true;
			this.mouseChildren=true;
		}

		private function init():void {
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.bgLbl=this.getUIbyID("bgLbl") as Label;
			this.itemlist=this.getUIbyID("itemlist") as ScrollPane;

			EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onQuitClick);
		}

		private function onQuitClick():void {

			if (8 == MapInfoManager.getInstance().type) {
				PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(4610).content, function():void {
					Cmd_Ucp.cm_GuildCpQuit();
				}, null, false, "guildCopyExit");
			}

		}

		private function onClick(e:MouseEvent):void {
			Cmd_Ucp.cm_GuildCpQuit();
		}

		public function updateInfo(o:Object):void {

			UIManager.getInstance().taskTrack.hide()
			UIManager.getInstance().rightTopWnd.hideBar(1);
			UIManager.getInstance().smallMapWnd.switchToType(2);
			MapWnd.getInstance().hideSwitch();

			var render:Label;
			for each (render in this.itemLblArr) {
				this.itemlist.delFromPane(render);
			}

			this.itemLblArr.length=0;

			if (o.hasOwnProperty("mlist")) {

				var str:String;
				var obj:Object;
				var i:int=0;

				var color:String="#ff0000";
				for each (obj in o.mlist) {

					if (obj.cc == obj.mc)
						color="#00ff00";
					else
						color="#ff0000";

					render=new Label();
					render.htmlText="击杀：" + TableManager.getInstance().getLivingInfo(obj.mid).name + "<font color='" + color + "'>(" + obj.cc + "/" + obj.mc + ")</font>";

//					render.x=10;
					render.y=i * render.height;

					this.itemlist.addToPane(render);
					this.itemLblArr.push(render);
					i++;
				}

				this.countLbl.text=o.knum + "";
				this.bgLbl.text=o.bg + "";
			}

		}

		public function reSize():void {
			this.x=UIEnum.WIDTH - 271;
			this.y=(UIEnum.HEIGHT - 254) >> 1;

		}

		override public function show():void {
			super.show();
			this.reSize();
		}

		override public function hide():void {
			super.hide();

		}

	}
}
