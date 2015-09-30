package com.leyou.ui.marry.childs {


	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMarry_ring;
	import com.ace.gameData.table.TRing_intensify;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Marry;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Marry4Render2 extends AutoSprite {

		private var upgradeBtn:NormalButton;

		private var nameLbl:Label;
		private var name1Lbl:Label;

		private var zfLbl:Label;
		private var moneyLbl:Label;

		private var ryImg:Image;
		private var mImg:Image;

		private var img1:Image;
		private var img2:Image;

		private var img1Swf:SwfLoader;
		private var img2Swf:SwfLoader;

		private var img1SSwf:Sprite;
		private var img2SSwf:Sprite;

		private var propList1:Marry4WndLable;
		private var propList2:Marry4WndLable;

		private var ringLv:int=0;

		private var tipinfo:TipsInfo;

		public function Marry4Render2() {
			super(LibManager.getInstance().getXML("config/ui/marry/marry4Render2.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {
			this.upgradeBtn=this.getUIbyID("upgradeBtn") as NormalButton;

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.name1Lbl=this.getUIbyID("name1Lbl") as Label;

			this.zfLbl=this.getUIbyID("zfLbl") as Label;
			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;

			this.mImg=this.getUIbyID("mImg") as Image;
			this.ryImg=this.getUIbyID("ryImg") as Image;

			this.upgradeBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.img1=new Image();
			this.addChild(this.img1);

			this.img1.x=32;
			this.img1.y=15;

			this.img2=new Image();
			this.addChild(this.img2);

			this.img2.x=237;
			this.img2.y=15;

//			var einfo:MouseEventInfo=new MouseEventInfo();
//			einfo.onMouseMove=onTipslMouseOver;
//			einfo.onMouseOut=onTipsMouseOut;
//
//			MouseManagerII.getInstance().addEvents(this.img1, einfo);
//
//			einfo=new MouseEventInfo();
//			einfo.onMouseMove=onTipslMouseOver;
//			einfo.onMouseOut=onTipsMouseOut;
//
//			MouseManagerII.getInstance().addEvents(this.img2, einfo);

			this.img1Swf=new SwfLoader();
			this.addChild(this.img1Swf);

			this.img1Swf.x=this.img1.x;
			this.img1Swf.y=this.img1.y;

			this.img2Swf=new SwfLoader();
			this.addChild(this.img2Swf);

			this.img2Swf.x=this.img2.x;
			this.img2Swf.y=this.img2.y;

			this.img1SSwf=new Sprite();
			this.img1SSwf.graphics.beginFill(0x000000);
			this.img1SSwf.graphics.drawRect(0, 0, 60, 60);
			this.img1SSwf.graphics.endFill();

			this.addChild(this.img1SSwf);

			this.img1SSwf.x=this.img1.x;
			this.img1SSwf.y=this.img1.y;

			this.img2SSwf=new Sprite();
			this.img2SSwf.graphics.beginFill(0x000000);
			this.img2SSwf.graphics.drawRect(0, 0, 60, 60);
			this.img2SSwf.graphics.endFill();

			this.addChild(this.img2SSwf);

			this.img2SSwf.x=this.img2.x;
			this.img2SSwf.y=this.img2.y;

			this.img1SSwf.addEventListener(MouseEvent.MOUSE_OVER, onTipslMouseOver);
			this.img1SSwf.addEventListener(MouseEvent.MOUSE_OUT, onTipslMouseOut);

			this.img2SSwf.addEventListener(MouseEvent.MOUSE_OVER, onTipslMouseOver);
			this.img2SSwf.addEventListener(MouseEvent.MOUSE_OUT, onTipslMouseOut);

			this.img1SSwf.alpha=0;
			this.img2SSwf.alpha=0;

			this.propList1=new Marry4WndLable();
			this.addChild(this.propList1);

			this.propList1.x=10;
			this.propList1.y=112;

			this.propList2=new Marry4WndLable();
			this.addChild(this.propList2);

			this.propList2.x=216;
			this.propList2.y=112;

			this.tipinfo=new TipsInfo();

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(ryImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(mImg, einfo);

		}

		private function onTipsMouseOver(e:Image):void {
			if (this.ryImg == e)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9561).content, new Point(this.stage.mouseX, this.stage.mouseY));
			else if (this.mImg == e)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));

		}

		private function onTipsMouseOut(e:Image):void {
			ToolTipManager.getInstance().hide();
		}

		private function onTipslMouseOver(e:MouseEvent):void {

			if (e.target == this.img2SSwf) {
				if (this.ringLv + 1 > 16)
					this.tipinfo.qh=16;
				else
					this.tipinfo.qh=this.ringLv + 1;
			} else {
				this.tipinfo.qh=this.ringLv;
			}

			ToolTipManager.getInstance().show(TipEnum.TYPE_MARRY, this.tipinfo, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipslMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {
			Cmd_Marry.cmMarryEquip();
			Cmd_Marry.cmMarryInit();
		}

		public function updateInfo(o:Object):void {

			var info:TMarry_ring=TableManager.getInstance().getMarryRingByid(o.mtype);
			var rinfo:TRing_intensify=TableManager.getInstance().getRing_intensifyByLv(o.m_ring);
			var mlv:int=TableManager.getInstance().getRing_intensifyMaxLv();
//			var mmlv:int=TableManager.getInstance().getMarryLvMaxLv();

			if (o.m_ring > 0)
				this.nameLbl.text="" + info.Ring_Name + "+" + o.m_ring;
			else
				this.nameLbl.text="" + info.Ring_Name;

			this.name1Lbl.text="" + info.Ring_Name + "+" + (o.m_ring + 1 >= mlv ? mlv : o.m_ring + 1);

			this.zfLbl.text=rinfo.RI_Happy + "";
			this.moneyLbl.text=rinfo.RI_money + "";

			this.propList1.updateInfo(o.mmd_l, o.mtype, o.m_ring);
			this.propList2.updateInfo(o.mmd_l, o.mtype, (o.m_ring >= mlv ? mlv : o.m_ring + 1));

			this.img1.updateBmp("ico/items/" + info.Ring_Pic);
			this.img2.updateBmp("ico/items/" + info.Ring_Pic);

			this.img1Swf.update(info.Ring_Eff2);
			this.img2Swf.update(info.Ring_Eff2);

//			this.img1Swf.mouseChildren=this.img1Swf.mouseChildren=false;
//			this.img2Swf.mouseChildren=this.img2Swf.mouseChildren=false;

			if(o.m_ring >= mlv)
				this.upgradeBtn.setActive(false, 0.6, true);
			else
				this.upgradeBtn.setActive(true, 1, true);
			
			this.tipinfo.itemid=o.mtype;
			this.tipinfo.zf=o.mmd_l;
			this.tipinfo.qh=o.m_ring;
			this.ringLv=o.m_ring;

		}




	}
}
