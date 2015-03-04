package com.leyou.ui.tips {

	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.tips.childs.TipsGrid;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.StringUtil_II;
	import com.leyou.utils.TimeUtil;
	
	import flash.geom.Point;

	public class TipsItemWnd extends AutoWindow {

		private var nameLbl:Label;
		private var bindLbl:Label;

		private var desc1Lbl:Label;

		private var typeLbl:Label;
		private var lvLbl:Label;
		private var stackNumLbl:Label;

		private var dateLbl:Label;
		private var getFunLbl:Label;
		private var priceNumLbl:Label;
		private var priceLbl:Label;

		private var tdataLbl:Label;
		private var bindImg:Image;
		private var moneyIco:Image;
		private var bgArea:ScaleBitmap;

		private var moneyNameLbl:Label;

		private var grid:TipsGrid;

		public function TipsItemWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsItemWnd.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.visible=false;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.bindLbl=this.getUIbyID("bindLbl") as Label;

			this.desc1Lbl=this.getUIbyID("desc1Lbl") as Label;
			//this.desc2Lbl=this.getUIbyID("desc2Lbl") as Label;

			this.typeLbl=this.getUIbyID("typeLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.stackNumLbl=this.getUIbyID("stackNumLbl") as Label;

			this.dateLbl=this.getUIbyID("dateLbl") as Label;
			this.getFunLbl=this.getUIbyID("getFunLbl") as Label;

			this.priceLbl=this.getUIbyID("priceLbl") as Label;
			this.tdataLbl=this.getUIbyID("tdataLbl") as Label;

			this.bgArea=this.getUIbyID("bgArea") as ScaleBitmap;
			this.bindImg=this.getUIbyID("bindImg") as Image;

			this.moneyIco=this.getUIbyID("moneyIco") as Image;
			this.moneyNameLbl=this.getUIbyID("moneyNameLbl") as Label;

			this.grid=new TipsGrid();
			this.addToPane(grid);

			this.grid.x=15;
			this.grid.y=42;

			this.addToPane(this.bindImg);
		}

		public function showPanel(tips:TipsInfo):void {
			super.show();
			this.updateInfo(tips);
		}

		public function updatePs(p:Point):void {
			this.x=p.x;
			this.y=p.y;
		}

		public function updateInfo(tips:TipsInfo):void {
			if (tips.itemid <= 0)
				return;

			var info:TItemInfo=TableManager.getInstance().getItemInfo(tips.itemid);

			this.grid.updataInfo(info);

			if (tips.bd == 1) {
				this.bindImg.visible=true;
			} else {
				this.bindImg.visible=false;
			}
			

			this.nameLbl.text=info.name + "";
			this.typeLbl.text=PlayerUtil.getPlayerRaceByIdx(int(info.limit)) + "";

			this.lvLbl.text=info.level + "";
			this.stackNumLbl.text=info.maxgroup + "";

			if (tips.t != 0) {

				var d:Date=new Date();
				d.time=tips.t;

				var dt:String=TimeUtil.getDateToString(d);
				this.dateLbl.text=dt.split(" ")[0];

				this.dateLbl.visible=true;
				this.tdataLbl.visible=true;
				
//				this.desc1Lbl.y=161;
//				this.priceLbl.y=223.5;
//				this.moneyNameLbl.y=223.5;
//
//				this.moneyIco.y=221.5;
//				this.bgArea.height=257;
				
			} else {

				this.dateLbl.visible=false;
				this.tdataLbl.visible=false;
//
//				var diff:Number=this.desc1Lbl.y - this.dateLbl.y;
//
//				this.desc1Lbl.y-=diff;
//				this.priceLbl.y-=diff;
//				this.moneyNameLbl.y-=diff;
//				this.moneyIco.y-=diff;
//				
//				this.bgArea.height-=diff;
			}

			
			
			
			this.desc1Lbl.text="" + StringUtil_II.getBreakLineStringByCharIndex(info.des,19);;
			this.getFunLbl.text=""+StringUtil_II.getBreakLineStringByCharIndex(info.desSource);
			this.priceLbl.text="" + info.price;
		}



	}
}
