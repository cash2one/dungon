package com.leyou.ui.tips {

	import com.ace.ICommon.ITip;
	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.THallows;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.leyou.ui.tips.childs.TipsGrid;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	public class TipsMissionWnd extends AutoSprite implements ITip {

		private var nameImg:Image;
		private var iconImg:Image;
		private var effSwf:SwfLoader;

		private var descLbl:Label;
		private var getFunLbl:Label;
		private var getLbl:Label;
		private var progressLbl:Label;

		private var propNameArr:Array=[];
		private var propKeyArr:Array=[];

		private var taskInfo:TMissionDate;

		public function TipsMissionWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsMissionWnd.xml"));
			this.init();
		}

		private function init():void {

			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.getFunLbl=this.getUIbyID("getFunLbl") as Label;
			this.getLbl=this.getUIbyID("getLbl") as Label;
			this.progressLbl=this.getUIbyID("progressLbl") as Label;

			this.nameImg=this.getUIbyID("nameImg") as Image;
			this.iconImg=this.getUIbyID("iconImg") as Image;

			this.effSwf=new SwfLoader(99972);
			this.addChild(this.effSwf);

			this.effSwf.x=this.iconImg.x - 2;
			this.effSwf.y=this.iconImg.y - 2;

			this.addChild(this.iconImg);

			var _x:int=20;
			var _y:int=110;
			var lb:Label;
			for (var i:int=0; i < 4; i++) {
				lb=new Label();

				lb.x=_x;
				lb.y=_y + i * 20;

				this.addChild(lb);
				this.propNameArr.push(lb);

				lb=new Label();

				lb.x=81;
				lb.y=_y + i * 20;

				this.addChild(lb);
				this.propKeyArr.push(lb);
			}


		}

		public function updateInfo(info:Object):void {

			var _i:int=info[0];
			var _p:String=info[1];
			var _id:int=info[2];

//			taskInfo=TableManager.getInstance().getMissionDataByID(_i);
			var hallows:THallows=TableManager.getInstance().getHallowslistByProfressAndTeamId(Core.me.info.profession, _i);

			if (hallows == null)
				return;

			for (var i:int=1; i <= 4; i++) {
				this.propNameArr[i - 1].text="" + PropUtils.propArr[hallows["H_property_" + i] - 1] + ":";
				this.propKeyArr[i - 1].text="" + hallows["Property_Amount_" + i];
			}

			this.descLbl.htmlText="" + StringUtil_II.getBreakLineStringByCharIndex(TableManager.getInstance().getSystemNotice(2212 + _i).content);
//			this.getFunLbl.htmlText="" + TableManager.getInstance().getSystemNotice(2222).content;
			this.getFunLbl.text="";

			this.iconImg.updateBmp("ui/mission/mission_icon" + _i + "_big.png");
			this.nameImg.updateBmp("ui/mission/n_mission_" + _i + ".png");

			this.progressLbl.text=PropUtils.getStringById(1943) + _p;

			if (_id > int(hallows.Mission_ID) || _p == "100%") {
				this.getLbl.text=PropUtils.getStringById(1944);
				this.getLbl.setTextFormat(FontEnum.getTextFormat("Green12"));
			} else {
				this.getLbl.text=PropUtils.getStringById(1945);
				this.getLbl.setTextFormat(FontEnum.getTextFormat("Red12"));
			}
		}

		public function get isFirst():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}

	}
}
