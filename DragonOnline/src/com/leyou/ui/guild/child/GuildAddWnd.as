package com.leyou.ui.guild.child {

	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.net.cmd.Cmd_Guild;

	import flash.events.MouseEvent;

	public class GuildAddWnd extends AutoWindow {

		private var inviteBtn:NormalButton;
		private var viewDataBtn:NormalButton;

		private var searchBtn:ImgButton;
		private var searchTeamList:ScrollPane;
		private var inputNameTxt:TextInput;

		private var items:Array=[];

		private var selectIndex:int=-1;

		public function GuildAddWnd() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildAddWnd.xml"));
			this.init();
			this.clsBtn.y-=10;
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.inviteBtn=this.getUIbyID("inviteBtn") as NormalButton;
			this.viewDataBtn=this.getUIbyID("viewDataBtn") as NormalButton;
			this.searchBtn=this.getUIbyID("searchBtn") as ImgButton;
			this.searchTeamList=this.getUIbyID("searchTeamList") as ScrollPane;
			this.inputNameTxt=this.getUIbyID("inputNameTxt") as TextInput;

			this.searchBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.viewDataBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.inviteBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.searchTeamList.addEventListener(MouseEvent.CLICK, onItemClick);
			this.searchTeamList.addEventListener(MouseEvent.MOUSE_OVER, onItemMouseOver);
			this.searchTeamList.addEventListener(MouseEvent.MOUSE_OUT, onItemMouseOut);
		}

		private function onItemMouseOver(e:MouseEvent):void {
			if (!(e.target is GuildAddRender))
				return;

			(e.target as GuildAddRender).setHight(3);
		}

		private function onItemMouseOut(e:MouseEvent):void {
			if (!(e.target is GuildAddRender))
				return;

			if (this.selectIndex != this.items.indexOf(e.target as GuildAddRender))
				(e.target as GuildAddRender).setHight();
		}

		private function onItemClick(e:MouseEvent):void {

			if (this.selectIndex != -1 && this.selectIndex < this.items.length)
				this.items[this.selectIndex].setHight();

			if (!(e.target is GuildAddRender))
				return;

			(e.target as GuildAddRender).setHight(3);
			this.selectIndex=this.items.indexOf(e.target as GuildAddRender);
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "searchBtn":
//					if (this.inputNameTxt.text != null && this.inputNameTxt.text != "")
					Cmd_Guild.cm_GuildSearch(this.inputNameTxt.text);
					break;
				case "viewDataBtn":
					if (this.selectIndex != -1)
						UIManager.getInstance().otherPlayerWnd.showPanel(this.items[this.selectIndex].playName);
					break;
				case "inviteBtn":
					if (this.selectIndex != -1)
						Cmd_Guild.cm_GuildInvite(this.items[this.selectIndex].playName);
					break;
			}

		}

		private function updateInfo(o:Object):void {

			var render:GuildAddRender;
			for each (render in this.items) {
				this.searchTeamList.delFromPane(render);
			}

			this.items.length=0;

			for (var i:int=0; i < o.length; i++) {
				render=new GuildAddRender();

				render.y=i * (render.height + 3);

				this.searchTeamList.addToPane(render);
				this.items.push(render);

				render.updateInfo(o[i]);

				if (i == 0)
					render.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}


		}

		public function showPanel(o:Object):void {
			this.show();

			this.updateInfo(o);

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);
		}

	}
}
