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
	import com.leyou.ui.team.child.TeamAddPlayerRender;

	import flash.events.MouseEvent;

	public class TeamAddPlayerWnd extends AutoWindow {

		private var inputNameTxt:TextInput;

		private var searchBtn:ImgButton;
		private var viewDataBtn:NormalButton;
		private var inviteBtn:NormalButton;
		private var searchPlayList:ScrollPane;

		private var teamPlayItems:Vector.<TeamAddPlayerRender>;

		private var info:Array=[];

		private var selectIndex:int=-1;

		public function TeamAddPlayerWnd() {
			super(LibManager.getInstance().getXML("config/ui/team/TeamAddPlayerWnd.xml"));
			this.init();
//			this.clsBtn.y-=10;
		}

		private function init():void {
			this.inputNameTxt=this.getUIbyID("inputNameTxt") as TextInput;

			this.searchBtn=this.getUIbyID("searchBtn") as ImgButton;
			this.viewDataBtn=this.getUIbyID("viewDataBtn") as NormalButton;
			this.inviteBtn=this.getUIbyID("inviteBtn") as NormalButton;
			this.searchPlayList=this.getUIbyID("searchPlayList") as ScrollPane;

			this.searchBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.viewDataBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.inviteBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.searchPlayList.addEventListener(MouseEvent.CLICK, onItemClick);
			this.searchPlayList.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.searchPlayList.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.teamPlayItems=new Vector.<TeamAddPlayerRender>();
		}

		public function searchValues(info:Array):void {
			var prender:TeamAddPlayerRender;
			for each (prender in this.teamPlayItems) {
				this.searchPlayList.delFromPane(prender);
			}

			this.teamPlayItems.length=0;

			for (var i:int=0; i < info.length; i++) {
				prender=new TeamAddPlayerRender();
				prender.updateInfo(info[i]);

				prender.y=i * (30);

				this.teamPlayItems.push(prender);
				this.searchPlayList.addToPane(prender);

				if (i == 0)
					prender.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}

		}

		private function onMouseOver(e:MouseEvent):void {
			if (e.target is TeamAddPlayerRender) {
				TeamAddPlayerRender(e.target).setlight(true);
			}

		}

		private function onMouseOut(e:MouseEvent):void {
			if (e.target is TeamAddPlayerRender) {
				if (selectIndex != this.teamPlayItems.indexOf(e.target as TeamAddPlayerRender))
					TeamAddPlayerRender(e.target).setlight(false);
			}
		}

		private function onItemClick(e:MouseEvent):void {
			if (selectIndex != -1 && selectIndex < this.teamPlayItems.length)
				this.teamPlayItems[selectIndex].setlight(false);

			if (e.target is TeamAddPlayerRender) {
				selectIndex=this.teamPlayItems.indexOf(e.target as TeamAddPlayerRender);
				TeamAddPlayerRender(e.target).setlight(true);
			} else {
				selectIndex=-1;
			}
		}

		public function updateInfo(o:Object):void {
			this.info=o.ul;
			searchValues(o.ul);
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
						UIManager.getInstance().otherPlayerWnd.showPanel(this.teamPlayItems[selectIndex].playeName());
					break;
				case "inviteBtn":
					if (selectIndex != -1)
						Cmd_Tm.cm_teamInvite(this.teamPlayItems[selectIndex].playeName());
					selectIndex=-1;
					break;
			}

		}

		//问题标注
		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);

			Cmd_Tm.cm_teamSearch();
		}

		override public function hide():void {
			super.hide();
		}


	}
}
