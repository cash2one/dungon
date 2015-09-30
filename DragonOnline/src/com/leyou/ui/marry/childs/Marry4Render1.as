package com.leyou.ui.marry.childs {

	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBuffInfo;
	import com.ace.gameData.table.TMarry_lv;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Marry;
	import com.leyou.net.cmd.Cmd_Npc;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class Marry4Render1 extends AutoSprite {

		private var icon1Img:Image;
		private var icon2Img:Image;
		private var icon3Img:Image;

		private var ryImg:Image;
		private var mImg:Image;

		private var upgradeBtn:NormalButton;
		private var transBtn:NormalButton;

		private var desc1Lbl:Label;
		private var blvLbl:Label;
		private var bdescLbl:Label;
		private var ddescLbl:Label;
		private var stLbl:Label;
		private var alvLbl:Label;
		private var desc2Lbl:Label;
		private var cdLbl:Label;
		private var lvLbl:Label;
		private var tlvLbl:Label;
		private var tpropLbl:Label;
		private var tbuffLbl:Label;
		private var propLbl:Label;
		private var buffLbl:Label;
		private var meiLbl:Label;
		private var tmeiLbl:Label;
		private var costLbl:Label;
		private var moneyLbl:Label;

		private var o:Object;

		private var freeTime:int=0;

		public function Marry4Render1() {
			super(LibManager.getInstance().getXML("config/ui/marry/marry4Render1.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {
			this.icon1Img=this.getUIbyID("icon1Img") as Image;
			this.icon2Img=this.getUIbyID("icon2Img") as Image;
			this.icon3Img=this.getUIbyID("icon3Img") as Image;

			this.ryImg=this.getUIbyID("ryImg") as Image;
			this.mImg=this.getUIbyID("mImg") as Image;

			this.upgradeBtn=this.getUIbyID("upgradeBtn") as NormalButton;
			this.transBtn=this.getUIbyID("transBtn") as NormalButton;

			this.desc1Lbl=this.getUIbyID("desc1Lbl") as Label;
			this.blvLbl=this.getUIbyID("blvLbl") as Label;
			this.bdescLbl=this.getUIbyID("bdescLbl") as Label;
			this.ddescLbl=this.getUIbyID("ddescLbl") as Label;
			this.stLbl=this.getUIbyID("stLbl") as Label;
			this.alvLbl=this.getUIbyID("alvLbl") as Label;
			this.desc2Lbl=this.getUIbyID("desc2Lbl") as Label;
			this.cdLbl=this.getUIbyID("cdLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.tlvLbl=this.getUIbyID("tlvLbl") as Label;
			this.tpropLbl=this.getUIbyID("tpropLbl") as Label;
			this.tbuffLbl=this.getUIbyID("tbuffLbl") as Label;
			this.propLbl=this.getUIbyID("propLbl") as Label;
			this.buffLbl=this.getUIbyID("buffLbl") as Label;
			this.meiLbl=this.getUIbyID("meiLbl") as Label;
			this.tmeiLbl=this.getUIbyID("tmeiLbl") as Label;
			this.costLbl=this.getUIbyID("costLbl") as Label;
			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;

			this.upgradeBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.transBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.desc2Lbl.addEventListener(TextEvent.LINK, onLink);
			this.desc2Lbl.mouseEnabled=true;

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

		private function onLink(e:TextEvent):void {
//			Cmd_Go.cmGoCall(o.m_room, o.m_x, o.m_y);
			Core.me.gotoMap(new Point(o.m_x, o.m_y), o.m_room);
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "upgradeBtn":
					Cmd_Marry.cmMarryUpgrade();
					Cmd_Marry.cmMarryInit();
					break;
				case "transBtn":
					Cmd_Marry.cmMarryTransfer();
					break;
			}

		}

		/**
		 *下行:marry|{"mk":P, "mmd_c":num, "mmd_z":num, "m_room":num, "m_x":num, "m_y":num, "m_cd":num , "leave":num ,"buffst":num, "marry_name":str, "mtype":num, "mmd_l":num, "m_ring":num}
	   mmd_c  -- 今日获得美满度
																			 mmd_z  -- 总美满度
		   m_room -- 对象所在房间id
		   m_x -- 坐标x
		   m_y -- 坐标y
		   m_cd -- 传送cd剩余时间
		   leave -- 离开天数
		   buffst -- buff状态是否已激活(1已激活 0未激活)
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			this.o=o;

			var len:int=TableManager.getInstance().getMarryLvLen();
			var lvinfo:TMarry_lv=TableManager.getInstance().getMarryLvBylv(o.mmd_l);
			var maxlv:int=TableManager.getInstance().getMarryLvMaxLv();

			if (o.mmd_l >= maxlv)
				this.upgradeBtn.setActive(false, 0.6, true);
			else
				this.upgradeBtn.setActive(true, 1, true);

			this.lvLbl.text="" + o.mmd_l + PropUtils.getStringById(1812);
			this.propLbl.text="+ " + (lvinfo.ringAddRate / 100) + "%";
			this.buffLbl.text="" + o.mmd_l + PropUtils.getStringById(1812);
			this.meiLbl.text="" + lvinfo.lovePointLimit;

			var lvinfo1:TMarry_lv=TableManager.getInstance().getMarryLvBylv((o.mmd_l >= maxlv ? maxlv : int(o.mmd_l + 1)));

			this.tlvLbl.text="" + lvinfo1.lv + PropUtils.getStringById(1812);
			this.tpropLbl.text="+ " + (lvinfo1.ringAddRate / 100) + "%";
			this.tbuffLbl.text="" + lvinfo1.lv + PropUtils.getStringById(1812);
			this.tmeiLbl.text="" + lvinfo1.lovePointLimit;

			this.costLbl.text="" + lvinfo.useLovePoint;
			this.moneyLbl.text="" + lvinfo.money;

//			this.icon1Img.updateBmp("ico/items/" + TableManager.getInstance().getMarryRingByid(o.mtype));

			/**----------------------------------------------------------------------------*/

			this.desc1Lbl.text="" + PropUtils.getStringById(2228);

			if (o.hasOwnProperty("m_room"))
				this.desc2Lbl.htmlText="<font color='#00ff00'><u><a href='event:#'>" + TableManager.getInstance().getSceneInfo(o.m_room).name + "[" + o.m_x + "," + o.m_y + "]</a></u></font>";
			else
				this.desc2Lbl.text="" + PropUtils.getStringById(2240);

//			this.cdLbl.text="" + int(o.m_cd / 60) + "" + PropUtils.getStringById(1649);
			/**----------------------------------------------------------------------------------------*/

			var binfo:TBuffInfo=TableManager.getInstance().getBuffInfo(lvinfo.buffID);

			this.blvLbl.text=o.mmd_l + PropUtils.getStringById(1812);
			this.bdescLbl.text="" + binfo.des;

			this.stLbl.text="" + (o.buffst == 1 ? "已激活" : "未激活");

			binfo=TableManager.getInstance().getBuffInfo(lvinfo1.buffID);

			this.ddescLbl.text="" + TableManager.getInstance().getSystemNotice(23326).content; 
//			this.alvLbl.text=PropUtils.getStringById(2239) + "" + (o.mmd_l >= maxlv ? maxlv : int(o.mmd_l + 1)) + PropUtils.getStringById(1812);
			this.alvLbl.text=""+ binfo.des;

//			this.icon3Img.updateBmp("ico/skills/" + binfo.icon + ".png");
			this.freeTime=o.m_cd;
			this.cdLbl.text="" + DateUtil.formatTime((this.freeTime) * 1000, 2);

			TimerManager.getInstance().remove(exeFreeTime);
			if (this.freeTime > 0)
				TimerManager.getInstance().add(exeFreeTime);
		}

		private function exeFreeTime(i:int):void {

			if (this.freeTime - i > 0) {

				this.cdLbl.text="" + DateUtil.formatTime((this.freeTime - i) * 1000, 2);
			} else {
				this.freeTime=0;
				TimerManager.getInstance().remove(exeFreeTime);

				this.cdLbl.text="";
				this.cdLbl.visible=false;
			}

		}




	}
}
