package com.leyou.ui.marry {
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMarry_ring;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Marry;
	import com.leyou.utils.PlayerUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MarryWnd2 extends AutoWindow {

		private var confirmBtn:ImgButton;
		private var concelBtn:ImgButton;

		private var guildNameLbl:Label;
		private var lvLbl:Label;
		private var nameLbl:Label;
		private var desc2Lbl:Label;
		private var descLbl:Label;
		private var ruleLbl:Label;

		private var roleImg:Image;
		private var equipImg:Image;
		private var equipImgSwf:SwfLoader;

		private var tipinfo:TipsInfo;

		private var cdLbl:Label;
		private var freeTime:int=0;

		public function MarryWnd2() {
			super(LibManager.getInstance().getXML("config/ui/marry/marryWnd2.xml"));
			this.init();
			this.hideBg();
		}

		private function init():void {

			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;
			this.concelBtn=this.getUIbyID("concelBtn") as ImgButton;

			this.guildNameLbl=this.getUIbyID("guildNameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			this.desc2Lbl=this.getUIbyID("desc2Lbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;
			
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;
			
			this.roleImg=this.getUIbyID("roleImg") as Image;

			this.cdLbl=new Label();
			this.addChild(this.cdLbl);

			this.cdLbl.x=this.concelBtn.x + 30;
			this.cdLbl.y=this.concelBtn.y + 10;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.concelBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(23303).content);
			
			this.descLbl.width=301;
			this.descLbl.wordWrap=true;

			this.equipImg=new Image();
			this.addChild(this.equipImg);

			this.equipImg.x=218;
			this.equipImg.y=269;

			this.equipImgSwf=new SwfLoader();
			this.addChild(this.equipImgSwf);

			this.equipImgSwf.x=218;
			this.equipImgSwf.y=269;

			var clickSpr:Sprite;
			
			clickSpr=new Sprite();
			clickSpr.graphics.beginFill(0x000000);
			clickSpr.graphics.drawRect(0, 0, 60, 60);
			clickSpr.graphics.endFill();
			
			clickSpr.alpha=0;
			this.addChild(clickSpr);
			
			clickSpr.x=equipImg.x;
			clickSpr.y=equipImg.y;
			
			clickSpr.addEventListener(MouseEvent.MOUSE_OVER, onTipsMouseOver);
			clickSpr.addEventListener(MouseEvent.MOUSE_OUT, onTipsMouseOut);

			this.tipinfo=new TipsInfo();
		}

		private function onTipsMouseOver(e:MouseEvent):void {
			this.tipinfo.zf=1;
			this.tipinfo.qh=0;

			ToolTipManager.getInstance().show(TipEnum.TYPE_MARRY, this.tipinfo, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "confirmBtn":
					Cmd_Marry.cmMarryAccept(1);
					break;
				case "concelBtn":
					Cmd_Marry.cmMarryAccept(2);
					break;
			}

			this.hide();
		}

		/**
		 *下行:marry|{"mk":R, "marry_name":str, "mtype":num, "gb":str, "marry_union":str, "marry_level":num}
	  marry_name -- 结婚对象名字
									mtype -- 结婚类型（1黄金 2白金 3钻石）
		  gb -- 告白内容
		  marry_union -- 结婚对象行会
		  marry_level -- 结婚对象等
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			UIManager.getInstance().hideWindow(WindowEnum.MARRY1);
			UIManager.getInstance().hideWindow(WindowEnum.MARRY3);

			this.tipinfo.itemid=o.mtype;

			this.guildNameLbl.text="" + o.marry_union;
			this.lvLbl.text="" + o.marry_level;
			this.nameLbl.text="" + o.marry_name;
			this.descLbl.htmlText="" + o.gb;

			this.roleImg.updateBmp(PlayerUtil.getPlayerFullHeadImg(o.marry_vocation, o.marry_gender));

			var tinfo:TMarry_ring=TableManager.getInstance().getMarryRingByid(o.mtype);
			this.equipImg.updateBmp("ico/items/" + tinfo.Ring_Pic);
			this.equipImgSwf.update(tinfo.Ring_Eff2);

			this.desc2Lbl.htmlText="" + StringUtil.substitute(TableManager.getInstance().getSystemNotice(23300).content, [o.marry_name, tinfo.Ring_Name]);

			TweenLite.delayedCall(30, hide);
			 
			
//			this.freeTime=30;
//			this.cdLbl.text="" + DateUtil.formatTime((this.freeTime) * 1000, 2);
//
//			TimerManager.getInstance().remove(exeFreeTime);
//			if (this.freeTime > 0)
//				TimerManager.getInstance().add(exeFreeTime);
		}

//		private function exeFreeTime(i:int):void {
//
//			if (this.freeTime - i > 0) {
//
//				this.cdLbl.text="" + DateUtil.formatTime((this.freeTime - i) * 1000, 2);
//			} else {
//				this.freeTime=0;
//				TimerManager.getInstance().remove(exeFreeTime);
//
//				this.cdLbl.text="";
//				this.cdLbl.visible=false;
//			}
//
//		}


	}
}
