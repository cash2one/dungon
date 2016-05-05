package com.leyou.ui.guild {

	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Guild;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GuildDonateMessage extends AutoWindow {

		private var changeMoneyLbl:Label;
		private var bg1Lbl:Label;
		private var changeYbLbl:Label;
		private var bg2Lbl:Label;

		private var lastMoneyLbl:Label;
		private var totalYbLbl:Label;

		private var curMoneyLbl:TextInput;
		private var curYbLbl:TextInput;

		private var confirmMoneyBtn:NormalButton;
		private var confirmYbBtn:NormalButton;

		private var money1Btn:ImgButton;
		private var money2Btn:ImgButton;

		private var yb1Btn:ImgButton;
		private var yb2Btn:ImgButton;

		private var mon1Img:Image;
		private var mon2Img:Image;
		private var mon3Img:Image;

		private var yb1Img:Image;
		private var yb2Img:Image;
		private var yb3Img:Image;

		private var bg1Img:Image;
		private var bg2Img:Image;


		public function GuildDonateMessage() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildDonateMessage.xml"));
			this.init();
			this.hideBg();
//			this.clsBtn.y-=10;
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.changeMoneyLbl=this.getUIbyID("changeMoneyLbl") as Label;
			this.bg1Lbl=this.getUIbyID("bg1Lbl") as Label;

			this.changeYbLbl=this.getUIbyID("changeYbLbl") as Label;
			this.bg2Lbl=this.getUIbyID("bg2Lbl") as Label;

			this.lastMoneyLbl=this.getUIbyID("lastMoneyLbl") as Label;
			this.totalYbLbl=this.getUIbyID("totalYbLbl") as Label;

			this.curMoneyLbl=this.getUIbyID("curMoneyLbl") as TextInput;
			this.curYbLbl=this.getUIbyID("curYbLbl") as TextInput;

			this.confirmMoneyBtn=this.getUIbyID("confirmMoneyBtn") as NormalButton;
			this.confirmYbBtn=this.getUIbyID("confirmYbBtn") as NormalButton;

			this.money1Btn=this.getUIbyID("money1Btn") as ImgButton;
			this.money2Btn=this.getUIbyID("money2Btn") as ImgButton;

			this.yb1Btn=this.getUIbyID("yb1Btn") as ImgButton;
			this.yb2Btn=this.getUIbyID("yb2Btn") as ImgButton;

			this.mon1Img=this.getUIbyID("mon1Img") as Image;
			this.mon2Img=this.getUIbyID("mon2Img") as Image;
			this.mon3Img=this.getUIbyID("mon3Img") as Image;

			this.yb1Img=this.getUIbyID("yb1Img") as Image;
			this.yb2Img=this.getUIbyID("yb2Img") as Image;
			this.yb3Img=this.getUIbyID("yb3Img") as Image;

			this.bg1Img=this.getUIbyID("bg1Img") as Image;
			this.bg2Img=this.getUIbyID("bg2Img") as Image;

			this.curMoneyLbl.restrict="0-9";
			this.curYbLbl.restrict="0-9";

			this.confirmMoneyBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.confirmYbBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.money1Btn.addEventListener(MouseEvent.CLICK, onClick);
			this.money2Btn.addEventListener(MouseEvent.CLICK, onClick);
			this.yb1Btn.addEventListener(MouseEvent.CLICK, onClick);
			this.yb2Btn.addEventListener(MouseEvent.CLICK, onClick);

			this.curMoneyLbl.addEventListener(Event.CHANGE, onInputChange);
			this.curYbLbl.addEventListener(Event.CHANGE, onInputChange);
//			this.curMoneyLbl.input.addEventListener(f, onInputChange);
//			this.curYbLbl.input.addEventListener(Event.CHANGE, onInputChange);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.yb1Img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.yb2Img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.yb3Img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.mon1Img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.mon2Img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.mon3Img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.bg1Img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.bg2Img, einfo);


			this.changeMoneyLbl.text=""+ConfigEnum.union39;
			this.bg1Lbl.text="" + ConfigEnum.union40;
			this.changeYbLbl.text="1";
			this.bg2Lbl.text="" + ConfigEnum.union7;


		}

		private function onTipsMouseOver(e:DisplayObject):void {
			if (e == this.bg1Img || e == this.bg2Img)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9557).content, new Point(this.stage.mouseX, this.stage.mouseY));
			else if (e == this.yb1Img || e == this.yb2Img || e == this.yb3Img)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9559).content, new Point(this.stage.mouseX, this.stage.mouseY));
			else if (e == this.mon1Img || e == this.mon2Img || e == this.mon3Img)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));

		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onInputChange(e:Event):void {

			if (e.currentTarget.name == "curMoneyLbl") {
				if (int(this.curMoneyLbl.text) > UIManager.getInstance().backpackWnd.jb)
					this.curMoneyLbl.text="" + UIManager.getInstance().backpackWnd.jb;

				if (int(this.curMoneyLbl.text) > int.MAX_VALUE) {
					this.curMoneyLbl.text="" + int(int.MAX_VALUE);
				}

				var lint:int=ConfigEnum.union38 - UIManager.getInstance().guildWnd.guildDonateMoney;
				var cint:int=int(this.curMoneyLbl.text);
				var crate:int=Math.floor(cint / ConfigEnum.union39);
				crate=(crate < 1 ? 1 : crate);
				crate=(cint > lint ? Math.floor(lint / ConfigEnum.union39) : crate);

				this.curMoneyLbl.text="" + (crate * ConfigEnum.union39);

			} else if (e.currentTarget.name == "curYbLbl") {
//				if (this.curYbLbl.text.length > 8) {
//					this.curYbLbl.text=this.curYbLbl.text.substring(0, 8) + "";
//				}


				if (int(this.curYbLbl.text) > UIManager.getInstance().backpackWnd.yb)
					this.curYbLbl.text="" + UIManager.getInstance().backpackWnd.yb;


				if (int(this.curYbLbl.text) > int.MAX_VALUE) {
					this.curYbLbl.text="" + int(int.MAX_VALUE);
				}

			}


		}

		private function onClick(e:MouseEvent):void {

			var lint:int=ConfigEnum.union38 - UIManager.getInstance().guildWnd.guildDonateMoney;
			var cint:int=int(this.curMoneyLbl.text);
			var crate:int=Math.floor(cint / ConfigEnum.union39);

			if (e.target.name == "money1Btn") {
				crate-=1;
				crate=(crate < 1 ? 1 : crate);
				this.curMoneyLbl.text="" + (crate * ConfigEnum.union39);

			} else if (e.target.name == "money2Btn") {
				crate+=1;

				if (int(crate * ConfigEnum.union39) > int.MAX_VALUE) {
					crate-=1;
				}

				this.curMoneyLbl.text="" + (crate * ConfigEnum.union39);
			}


			crate=int(this.curYbLbl.text);

			if (e.target.name == "yb1Btn") {

				crate-=1;
				crate=(crate < 1 ? 1 : crate);
				this.curYbLbl.text="" + (crate);

			} else if (e.target.name == "yb2Btn") {
				crate+=1;

				if (int(crate) > int.MAX_VALUE) {
					crate-=1;
				}

				this.curYbLbl.text="" + (crate);
			}

			if (e.target.name == "confirmMoneyBtn") {
				if (this.curMoneyLbl.text != "") {
					Cmd_Guild.cm_GuildContribute(int(this.curMoneyLbl.text), 2);
						//				Cmd_Guild.cm_GuildMemInfo(MyInfoManager.getInstance().name);
				}
//				this.hide();
			} else if (e.target.name == "confirmYbBtn") {

				if (this.curYbLbl.text != "") {
					Cmd_Guild.cm_GuildContribute(int(this.curYbLbl.text), 1);
						//				Cmd_Guild.cm_GuildMemInfo(MyInfoManager.getInstance().name);
				}
//				this.hide();
			}

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(true, $layer, toCenter);

			this.lastMoneyLbl.text="" + (ConfigEnum.union38 - UIManager.getInstance().guildWnd.guildDonateMoney);
			this.totalYbLbl.text="" + UIManager.getInstance().backpackWnd.yb;

			this.curYbLbl.text="1";
			this.curMoneyLbl.text="" + ConfigEnum.union39;

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);

		}
		
		public function updateLastMoney():void{
			this.lastMoneyLbl.text="" + (ConfigEnum.union38 - UIManager.getInstance().guildWnd.guildDonateMoney);
			this.totalYbLbl.text="" + UIManager.getInstance().backpackWnd.yb;
		}
		

	}
}
