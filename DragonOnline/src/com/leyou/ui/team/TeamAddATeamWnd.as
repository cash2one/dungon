package com.leyou.ui.team {

	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.net.cmd.Cmd_Role;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.ui.team.child.TeamAddTeamRender;

	import flash.events.MouseEvent;

	public class TeamAddATeamWnd extends AutoWindow {

		private var inputNameTxt:TextInput;

		private var searchBtn:ImgButton;
		private var viewDataBtn:NormalButton;
		private var inviteBtn:NormalButton;
		private var searchTeamList:ScrollPane

		private var teamItems:Vector.<TeamAddTeamRender>;

		private var info:Array=[];

		private var selectIndex:int=-1;

		public function TeamAddATeamWnd() {
			super(LibManager.getInstance().getXML("config/ui/team/TeamAddATeamWnd.xml"));
			this.init();
			this.clsBtn.y-=10;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.inputNameTxt=this.getUIbyID("inputNameTxt") as TextInput;

			this.searchBtn=this.getUIbyID("searchBtn") as ImgButton;
			this.viewDataBtn=this.getUIbyID("viewDataBtn") as NormalButton;
			this.inviteBtn=this.getUIbyID("inviteBtn") as NormalButton;
			this.searchTeamList=this.getUIbyID("searchTeamList") as ScrollPane;

			this.searchBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.viewDataBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.inviteBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.searchTeamList.addEventListener(MouseEvent.CLICK, onItemClick);
			this.searchTeamList.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.searchTeamList.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.teamItems=new Vector.<TeamAddTeamRender>();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "searchBtn":
					var tmp:Array=this.info.filter(function(item:Object, i:int, arr:Array):Boolean {

						if (item[0].indexOf(inputNameTxt.text) > -1)
							return true;

						return false;
					});

					searchValues(tmp);
					break;
				case "viewDataBtn":
					if (selectIndex != -1)
						UIManager.getInstance().otherPlayerWnd.showPanel(this.teamItems[selectIndex].playeNameValue());
					break;
				case "inviteBtn":
					if (selectIndex != -1)
						Cmd_Tm.cm_teamApply(this.teamItems[selectIndex].playeNameValue());
					break;
			}

		}

		private function onItemClick(e:MouseEvent):void {
			if (selectIndex != -1 && selectIndex < this.teamItems.length)
				this.teamItems[selectIndex].setlight(false);

			if (e.target is TeamAddTeamRender) {
				selectIndex=this.teamItems.indexOf(e.target as TeamAddTeamRender); //TeamAddTeamRender(e.target).playeNameValue();
				this.teamItems[selectIndex].setlight(true);
			} else {
				selectIndex=-1;
			}

		}

		private function onMouseOver(e:MouseEvent):void {
			if (e.target is TeamAddTeamRender) {
				TeamAddTeamRender(e.target).setlight(true);
			}

		}

		private function onMouseOut(e:MouseEvent):void {
			if (e.target is TeamAddTeamRender) {
				if (selectIndex != this.teamItems.indexOf(e.target as TeamAddTeamRender))
					TeamAddTeamRender(e.target).setlight(false);
			}
		}

		public function searchValues(info:Array):void {
			var prender:TeamAddTeamRender;
			for each (prender in this.teamItems) {
				this.searchTeamList.delFromPane(prender);
			}

			this.teamItems.length=0;

			for (var i:int=0; i < info.length; i++) {
				prender=new TeamAddTeamRender();
				prender.y=i * (30);

				prender.updateInfo(info[i]);

				this.teamItems.push(prender);
				this.searchTeamList.addToPane(prender);

				if (i == 0)
					prender.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show();

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);

			Cmd_Tm.cm_teamFind();
		}

		public function updateInfo(o:Object):void {

			this.info=o.tl;
			searchValues(o.tl as Array);
		}

		override public function hide():void {
			super.hide();

		}

	}
}
