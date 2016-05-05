package com.leyou.ui.guild.child {

	import com.ace.delayCall.DelayCallManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.enum.GuildEnum;
	import com.leyou.net.cmd.Cmd_Guild;

	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	public class GuildList extends AutoSprite {

		private var numSortBtn:ImgLabelButton;
		private var lvSortBtn:ImgLabelButton;
		private var sumfightBtn:ImgLabelButton;

		private var itemlist:ScrollPane;
		private var applyBtn:ImgButton;
		private var onBossCb:CheckBox;

		private var autoInviteCb:CheckBox;
		private var autoAccCb:CheckBox;
		private var descLbl:TextArea;
		private var createBtn:ImgButton;

		private var arrawlv:Image;
		private var arrawNum:Image;
		private var arrawfight:Image;

		private var addGuildImg:Image;
		private var createGuildImg:Image;

		private var listBarVec:Vector.<GuildListBar>;
		private var data:Array=[];

		private var sortState:Array=["", "", false, false, "", false];
		private var sortIndex:int=0;

		private var selectIndex:int=-1;

		private var begIndex:int=0;

		private var useArr:Array=[];

		public function GuildList() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildList.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.numSortBtn=this.getUIbyID("numSortBtn") as ImgLabelButton;
			this.lvSortBtn=this.getUIbyID("lvSortBtn") as ImgLabelButton;
			this.sumfightBtn=this.getUIbyID("sumfightBtn") as ImgLabelButton;

			this.itemlist=this.getUIbyID("itemlist") as ScrollPane;
			this.applyBtn=this.getUIbyID("applyBtn") as ImgButton;

			this.createBtn=this.getUIbyID("createBtn") as ImgButton;

			this.onBossCb=this.getUIbyID("onBossCb") as CheckBox;
			this.autoAccCb=this.getUIbyID("autoAccCb") as CheckBox;
			this.autoInviteCb=this.getUIbyID("autoInviteCb") as CheckBox;

			this.descLbl=this.getUIbyID("descLbl") as TextArea;
			this.descLbl.visibleOfBg=false;
			this.descLbl.tf.defaultTextFormat=new TextFormat("微软雅黑", 18);

			this.arrawlv=this.getUIbyID("arrawlv") as Image;
			this.arrawNum=this.getUIbyID("arrawNum") as Image;
			this.arrawfight=this.getUIbyID("arrawfight") as Image;

			this.addGuildImg=this.getUIbyID("addGuildImg") as Image;
			this.createGuildImg=this.getUIbyID("createGuildImg") as Image;

//			this.numSortBtn.addEventListener(MouseEvent.CLICK, onClick);
//			this.lvSortBtn.addEventListener(MouseEvent.CLICK, onClick);
//			this.sumfightBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.applyBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.onBossCb.addEventListener(MouseEvent.CLICK, onClick);
			this.autoAccCb.addEventListener(MouseEvent.CLICK, onClick);

			this.createBtn.addEventListener(MouseEvent.CLICK, onCreateClick);
			this.itemlist.addEventListener(MouseEvent.CLICK, onItemClick);
			this.itemlist.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.autoInviteCb.addEventListener(MouseEvent.CLICK, onAutoClick);
			this.listBarVec=new Vector.<GuildListBar>();

			this.y+=5;
			this.x=-13;
		}

		private function onAutoClick(e:MouseEvent):void {
//			if (UIManager.getInstance().guildWnd.memberJob == GuildEnum.ADMINI_1)
//				Cmd_Guild.cm_GuildApplySet(this.autoAccCb.isOn ? 1 : 0);
//			else
			Cmd_Guild.cm_GuildInviteSet(this.autoInviteCb.isOn ? 1 : 0);
		}

		public function setBtnVisible(v:Boolean):void {
			this.applyBtn.visible=v;
			this.createBtn.visible=v;

			this.addGuildImg.visible=v;
			this.createGuildImg.visible=v;
		}

		public function getAutoAccCb():CheckBox {
			return this.autoInviteCb;
		}

		private function onClick(e:MouseEvent):void {

			if (e.target.name != "applyBtn" && !(e.target is CheckBox)) {
//				this.numSortBtn.turnOff();
//				this.lvSortBtn.turnOff();
//				this.sumfightBtn.turnOff();

				ImgLabelButton(e.target).turnOn(false);
			}

			switch (e.target.name) {
				case "numSortBtn":
					sortIndex=3;
					sortState[sortIndex]=!sortState[sortIndex];
					this.updateInfo(this.data.sortOn("" + sortIndex, (sortState[sortIndex] ? Array.DESCENDING | Array.NUMERIC : Array.NUMERIC)));

					if (sortState[sortIndex])
						this.arrawNum.updateBmp("ui/guild/icon_arrows_d.png");
					else
						this.arrawNum.updateBmp("ui/guild/icon_arrows_u.png");
					break;
				case "lvSortBtn":
					sortIndex=2;
					sortState[sortIndex]=!sortState[sortIndex];
					this.updateInfo(this.data.sortOn("" + sortIndex, (sortState[sortIndex] ? Array.DESCENDING | Array.NUMERIC : Array.NUMERIC)));

					if (sortState[sortIndex])
						this.arrawlv.updateBmp("ui/guild/icon_arrows_d.png");
					else
						this.arrawlv.updateBmp("ui/guild/icon_arrows_u.png");

					break;
				case "sumfightBtn":
					sortIndex=5;
					sortState[sortIndex]=!sortState[sortIndex];
					this.updateInfo(this.data.sortOn("" + sortIndex, (sortState[sortIndex] ? Array.DESCENDING | Array.NUMERIC : Array.NUMERIC)));

					if (sortState[sortIndex])
						this.arrawfight.updateBmp("ui/guild/icon_arrows_d.png");
					else
						this.arrawfight.updateBmp("ui/guild/icon_arrows_u.png");

					break;
				case "applyBtn":
					if (this.selectIndex != -1 && this.listBarVec.length > this.selectIndex) {

						Cmd_Guild.cm_GuildApply(this.useArr[this.selectIndex][0]);
						this.listBarVec[this.selectIndex].sethight();
					}
					break;
				case "onBossCb":
					this.onLineGuild();
					break;
				case "autoAccCb":
					this.onLineGuild();
					break;
			}

			this.selectIndex=-1;
		}

		private function onWheel(e:MouseEvent):void {

			if (e.delta > 0) {

//				this.begIndex-=12;
//
//				if (this.begIndex < 0)
//					this.begIndex=0;
//
//				Cmd_Guild.cm_GuildList(this.begIndex + 1, this.begIndex + 12);
			} else {

				if (this.data.length == 12)
					this.begIndex+=12;

//				Cmd_Guild.cm_GuildList(this.begIndex + 1, this.begIndex + 12);
			}

		}

		private function onLineGuild():void {
			var tmp:Array;

			if (this.onBossCb.isOn || this.autoAccCb.isOn) {
				if (this.onBossCb.isOn && this.autoAccCb.isOn) {
					tmp=this.data.filter(function(item:Object, i:int, arr:Array):Boolean {
						if (item[7] && item[6])
							return true;
						return false;
					});
				} else if (this.onBossCb.isOn) {
					tmp=this.data.filter(function(item:Object, i:int, arr:Array):Boolean {
						if (item[7])
							return true;
						return false;
					});
				} else if (this.autoAccCb.isOn) {
					tmp=this.data.filter(function(item:Object, i:int, arr:Array):Boolean {
						if (item[6])
							return true;
						return false;
					});
				}
				this.updateInfo(tmp.sortOn("" + (sortIndex), (sortState[sortIndex] ? Array.DESCENDING | Array.NUMERIC : Array.NUMERIC)));
			} else
				this.updateInfo(this.data.sortOn("" + (sortIndex), (sortState[sortIndex] ? Array.DESCENDING | Array.NUMERIC : Array.NUMERIC)));
		}


		public function descTxt(s:String):void {
			this.descLbl.editable=true;
			this.descLbl.setText(s);
			this.descLbl.editable=false;
		}

		public function updateData(info:Array):void {

			var _i:int=-1;

			for (var i:int=0; i < info.length; i++) {

				_i=this.getDataByName(info[i]);
				if (_i > -1)
					this.data[_i]=info[i];
				else if (_i == -1)
					this.data.push(info[i]);

			}

			if (sortIndex == 0) {
				sortIndex=2;
				sortState[sortIndex]=true;
			}

			this.onLineGuild();
			this.itemlist.scrollTo(this.itemlist.scrollBar_Y.progress);
		}

		private function getDataByName(n:Array):int {

			for (var i:int=0; i < this.data.length; i++) {
				if (this.data[i][0] == n[0]) {
					return i;

//					for (var j:int=0; j < this.data[i].length; j++)
//						if (this.data[i][j] != n[j])
//							return -1;
//						else
//							return i;
				}
			}

			return -1;
		}


		private function updateInfo(info:Array):void {

			this.useArr=info;
			this.selectIndex=-1;

			var listbar:GuildListBar;
			for each (listbar in this.listBarVec) {
				this.itemlist.delFromPane(listbar);
			}

			this.listBarVec.length=0;

			for (var i:int=0; i < info.length; i++) {

				listbar=new GuildListBar();

				listbar.updateInfo(info[i]);
				listbar.y=this.listBarVec.length * 30;

				if (this.listBarVec.length % 2) {
					listbar.sethight(1);
				} else {
					listbar.sethight(0);
				}

				this.listBarVec.push(listbar);
				this.itemlist.addToPane(listbar);
			}

			var p:Number=this.itemlist.scrollBar_Y.progress;

			this.itemlist.scrollTo(0);
			this.itemlist.updateUI();
//			DelayCallManager.getInstance().add(this, this.itemlist.updateUI, "updateUI", 4);
			DelayCallManager.getInstance().add(this, this.itemlist.scrollTo, "updateUI", 4, p);
//			this.itemlist.scrollTo(p);
		}

		private function onMouseOver(e:MouseEvent):void {

			if (e.target is GuildListBar) {
				GuildListBar(e.target).sethight(2);
			}

		}

		private function onMouseOut(e:MouseEvent):void {

			if (e.target is GuildListBar) {
				if (selectIndex != this.listBarVec.indexOf(e.target as GuildListBar))
					GuildListBar(e.target).sethight();
			}

		}


		private function onItemClick(e:MouseEvent):void {

			if (e.target is GuildListBar) {
				if (this.selectIndex != -1 && this.listBarVec.length > this.selectIndex)
					this.listBarVec[this.selectIndex].sethight();

				selectIndex=this.listBarVec.indexOf(e.target as GuildListBar);
				GuildListBar(e.target).sethight(2);

				Cmd_Guild.cm_GuildNotice(this.data[this.selectIndex][0], 2);
//				this.applyBtn.visible=(this.listBarVec[this.selectIndex].getName() != UIManager.getInstance().guildWnd.guildName);
			}

		}


		private function onCreateClick(e:MouseEvent):void {

			UIManager.getInstance().guildWnd.showCreate();

		}

		public function clearData():void {

			this.data.length=0;
		}


	}
}
