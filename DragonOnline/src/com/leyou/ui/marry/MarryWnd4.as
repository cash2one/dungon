package com.leyou.ui.marry {

	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMarry_lv;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.manager.PopupManager;
	import com.leyou.ui.marry.childs.Marry4Render1;
	import com.leyou.ui.marry.childs.Marry4Render2;
	import com.leyou.ui.marry.childs.Marry4Render3;
	
	import flash.events.Event;
	import flash.geom.Point;

	public class MarryWnd4 extends AutoWindow {

		private var icon1Img:Image;
		private var icon2Img:Image;

		private var todayLbl:Label;
		private var curLbl:Label;

		private var marryTabber:TabBar;

		private var render1:Marry4Render1;
		private var render2:Marry4Render2;
		private var render3:Marry4Render3;

		public function MarryWnd4() {
			super(LibManager.getInstance().getXML("config/ui/marry/marryWnd4.xml"));
			this.init();
			this.hideBg();
			this.allowDrag=false;
		}

		private function init():void {

			this.icon1Img=this.getUIbyID("icon1Img") as Image;
			this.icon2Img=this.getUIbyID("icon2Img") as Image;

			this.todayLbl=this.getUIbyID("todayLbl") as Label;
			this.curLbl=this.getUIbyID("curLbl") as Label;

			this.marryTabber=this.getUIbyID("marryTabber") as TabBar;

			this.marryTabber.addEventListener(TabbarModel.changeTurnOnIndex, onChange);

			this.render1=new Marry4Render1();
			this.marryTabber.addToTab(this.render1, 0);

			this.render2=new Marry4Render2();
			this.marryTabber.addToTab(this.render2, 1);

			this.render3=new Marry4Render3();
			this.marryTabber.addToTab(this.render3, 2);

			this.render1.x=4;
			this.render2.x=4;
			this.render3.x=4;

//			this.clsBtn.y+=15;
			
			
			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;
			
			MouseManagerII.getInstance().addEvents(icon1Img, einfo);
			
			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;
			
			MouseManagerII.getInstance().addEvents(icon2Img, einfo);
			
		}
		
		private function onTipsMouseOver(e:Image):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9561).content, new Point(this.stage.mouseX, this.stage.mouseY));

		}
		
		private function onTipsMouseOut(e:Image):void {
			ToolTipManager.getInstance().hide();
		}
		

		private function onChange(e:Event):void {


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

			var info:TMarry_lv=TableManager.getInstance().getMarryLvBylv(o.mmd_l);
			
			this.todayLbl.text="" + o.mmd_c+"/"+info.lovePointLimit;
			this.curLbl.text="" + o.mmd_z;
			
			this.render1.updateInfo(o);
			this.render2.updateInfo(o);
			this.render3.updateInfo(o);
		}

		override public function hide():void{
			super.hide();
			PopupManager.closeConfirm("marry_exit");
		}

		
		override public function get height():Number{
			return 544;
		}
		
		override public function get width():Number{
			return 355;
		}
		
		
	}
}
