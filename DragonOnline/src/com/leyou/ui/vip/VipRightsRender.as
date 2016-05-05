package com.leyou.ui.vip {
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenLite;
	import com.leyou.data.vip.VipData;
	import com.leyou.net.cmd.Cmd_Vip;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.StringUtil_II;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;

	public class VipRightsRender extends AutoSprite {
		private var promotion1Img:Image;

		private var promotion2Img:Image;

		private var promotion3Img:Image;

		private var grids:Vector.<MaillGrid>;

		private var receiveBtn:ImgButton;

		private var previousBtn:ImgButton;

		private var nextBtn:ImgButton;

		private var reveiceImg:Image;

		private var lvImg:Image;

		private var flyIds:Array;

		private var starts:Array;

		private var vipLv:int;

		private var pSpt1:Sprite;

		private var pSpt2:Sprite;

		private var pSpt3:Sprite;

		private var lastSpt:Sprite;

		public function VipRightsRender() {
			super(LibManager.getInstance().getXML("config/ui/vip/vipRightRender.xml"));
			init();
		}

		private function init():void {
			flyIds=[];
			starts=[];
			mouseChildren=true;
			grids=new Vector.<MaillGrid>(5);
			lvImg=getUIbyID("lvImg") as Image;
			promotion1Img=getUIbyID("promotion1Img") as Image;
			promotion2Img=getUIbyID("promotion2Img") as Image;
			promotion3Img=getUIbyID("promotion3Img") as Image;
			reveiceImg=getUIbyID("receivedImg") as Image;
			nextBtn=getUIbyID("nextBtn") as ImgButton;
			previousBtn=getUIbyID("previousBtn") as ImgButton;
			receiveBtn=getUIbyID("receiveBtn") as ImgButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			nextBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			previousBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			pSpt1=new Sprite();
			pSpt2=new Sprite();
			pSpt3=new Sprite();
			pSpt1.addChild(promotion1Img);
			pSpt2.addChild(promotion2Img);
			pSpt3.addChild(promotion3Img);
			addChild(pSpt1);
			addChild(pSpt3);
			addChild(pSpt2);
			var unitW:int=int(712 / 6);
			pSpt1.x=297 / 2;
			pSpt2.x=712 / 2;
			pSpt3.x=712 - 297 * 0.5;

			pSpt1.y=275 / 2;
			pSpt2.y=275 / 2;
			pSpt3.y=275 / 2;

			promotion1Img.x=-297 / 2;
			promotion1Img.y=-167 / 2;
			promotion2Img.x=-297 / 2;
			promotion2Img.y=-167 / 2;
			promotion3Img.x=-297 / 2;
			promotion3Img.y=-167 / 2;

			pSpt1.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			pSpt2.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			pSpt3.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			pSpt1.scaleX=0.8;
			pSpt1.scaleY=0.8;
			pSpt3.scaleX=0.8;
			pSpt3.scaleY=0.8;
			pSpt1.alpha=0.6;
			pSpt3.alpha=0.6;
			lastSpt=pSpt2;
		}


		protected function onMouseOver(event:MouseEvent):void {
			var spt:Sprite=event.target as Sprite;
			if (lastSpt == spt)
				return;
			swapChildren(lastSpt, spt);
			TweenLite.to(spt, 0.5, {alpha: 1, scaleX: 1, scaleY: 1});
			TweenLite.to(lastSpt, 0.5, {alpha: 0.6, scaleX: 0.8, scaleY: 0.8});
			lastSpt=spt;

			var vipDetail:TVIPDetailInfo=TableManager.getInstance().getVipDetailInfo(vipLv);
			var content:String;
			if (pSpt1 == spt) {
				content=vipDetail.pic1Des;
			} else if (pSpt2 == spt) {
				content=vipDetail.pic2Des;
			} else if (pSpt3 == spt) {
				content=vipDetail.pic3Des;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "receiveBtn":
					Cmd_Vip.cm_VIP_J(vipLv);
					setFlyItem();
					break;
				case "nextBtn":
					if (vipLv < 10) {
						updateVipLv(++vipLv);
					}
					break;
				case "previousBtn":
					if (vipLv > 1) {
						updateVipLv(--vipLv);
					}
					break;
			}
		}

		private function getProItem(value:String):int {
			var arr:Array=value.split("|");
			if (arr.length > 1) {
				var idx:int=getIndexByPro(Core.me.info.profession);
				return arr[idx];
			}
			return arr[0];
		}

		private function getIndexByPro(pro:int):int {
			switch (pro) {
				case PlayerEnum.PRO_SOLDIER:
					return 0;
				case PlayerEnum.PRO_MASTER:
					return 1;
				case PlayerEnum.PRO_WARLOCK:
					return 2;
				case PlayerEnum.PRO_RANGER:
					return 3;
			}
			return 0;
		}

		public function updateVipLv(lv:int):void {
			if (lv <= 0 || lv > 10)
				return;
			lvImg.updateBmp("ui/vip/font_" + StringUtil_II.lpad("" + lv, 2, "0") + ".png");
			for each (var g:MaillGrid in grids) {
				if (null != g) {
					g.clear();
				}
			}
//			trace("------------------------------trace vip gride count label width begin")
			var vipDetail:TVIPDetailInfo=TableManager.getInstance().getVipDetailInfo(lv);
			var index:int=0;
			var tid:int;
			var grid:MaillGrid;
			if ((null != vipDetail.item1) && ("" != vipDetail.item1)) {
				tid=getProItem(vipDetail.item1);
				grid=getGrid(index);
				grid.updataInfo({itemId: tid, count: vipDetail.num1});
				index++;
			}
			if ((null != vipDetail.item2) && ("" != vipDetail.item2)) {
				tid=getProItem(vipDetail.item2);
				grid=getGrid(index);
				grid.updataInfo({itemId: tid, count: vipDetail.num2});
				index++;
			}
			if ((null != vipDetail.item3) && ("" != vipDetail.item3)) {
				tid=getProItem(vipDetail.item3);
				grid=getGrid(index);
				grid.updataInfo({itemId: tid, count: vipDetail.num3});
				index++;
			}
			if ((null != vipDetail.item4) && ("" != vipDetail.item3)) {
				tid=getProItem(vipDetail.item4);
				grid=getGrid(index);
				grid.updataInfo({itemId: tid, count: vipDetail.num4});
				index++;
			}
			if ((null != vipDetail.item5) && ("" != vipDetail.item5)) {
				tid=getProItem(vipDetail.item5);
				grid=getGrid(index);
				grid.updataInfo({itemId: tid, count: vipDetail.num5});
				index++;
			}

			var s1Url:String="ui/vip/" + vipDetail.show1PicUrl;
			var s2Url:String="ui/vip/" + vipDetail.show2PicUrl;
			var s3Url:String="ui/vip/" + vipDetail.show3PicUrl;
			promotion1Img.updateBmp(s1Url);
			promotion2Img.updateBmp(s2Url);
			promotion3Img.updateBmp(s3Url);
			updateStatus();
//			trace("------------------------------trace vip gride count label width end")
		}

		public function getGrid(index:int):MaillGrid {
			var grid:MaillGrid=grids[index];
			if (null == grid) {
				grid=new MaillGrid();
				grid.isShowPrice=false;
				grid.x=233 + 51 * index;
				grid.y=220
				grids[index]=grid;
				addChild(grid);
				swapChildren(grid, reveiceImg);
			}
			return grid;
		}

		private function setFlyItem():void {
			flyIds.length=0;
			starts.length=0;
			for each (var grid:MaillGrid in grids) {
				if (0 != grid.dataId) {
					flyIds.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
		}

		public function flyItem():void {
			if (0 != flyIds.length) {
				FlyManager.getInstance().flyBags(flyIds, starts);
			}
		}

		public function updateStatus():void {
			var data:VipData=DataManager.getInstance().vipData;
			if ((null == data.status) || (0 == data.status.length)) {
				return;
			}
			var statusList:Array=data.status;
			reveiceImg.visible=(1 == statusList[vipLv - 1]);
			if (reveiceImg.visible || (Core.me.info.vipLv < vipLv)) {
				receiveBtn.setActive(false, 1, true);
			} else {
				receiveBtn.setActive(true, 1, true);
			}
			for each (var g:MaillGrid in grids) {
				if (null != g) {
					g.filters=reveiceImg.visible ? [FilterEnum.enable] : null;
				}
			}
		}

		public function switchToObtainable():void {
			var statusList:Array=DataManager.getInstance().vipData.status;
			var l:int=statusList.length;
			for (var n:int=0; n < l; n++) {
				if (0 == statusList[n]) {
					vipLv=n + 1;
					break;
				}
			}
			if (0 == vipLv) {
				vipLv=10;
			}
			updateVipLv(vipLv);
		}
	}
}
