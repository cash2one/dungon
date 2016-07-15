package com.leyou.ui.v3exp {

	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Vip;
	import com.leyou.net.cmd.Cmd_ddsc;
	import com.leyou.ui.task.child.MissionGrid;
	import com.leyou.utils.PayUtil;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SellExpWnd extends AutoSprite {

		private var get1Img:Image;
		private var get2Img:Image;

		private var getBtn:NormalButton;

		private var swfeff:SwfLoader;

		private var item1Arr:Array=[];
		private var item2Arr:Array=[];

		private var flyIds:Array=[];
		private var starts:Array=[];

		private var flyIds1:Array=[];
		private var starts1:Array=[];

		private var st:int=0;

		public function SellExpWnd() {
			super(LibManager.getInstance().getXML("config/ui/v3exp/sellExpWnd.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=false;
		}

		private function init():void {

			this.get1Img=this.getUIbyID("get1Img") as Image;
			this.get2Img=this.getUIbyID("get2Img") as Image;
			this.swfeff=this.getUIbyID("swfeff") as SwfLoader;

			this.getBtn=this.getUIbyID("getBtn") as NormalButton;
			this.getBtn.addEventListener(MouseEvent.CLICK, onClick);


		}

		public function updateInfo(o:Array):void {

			this.item1Arr.length=0;
			this.item2Arr.length=0;

			var g:MissionGrid;

			for (var i:int=0; i < o.length; i++) {
				g=new MissionGrid();
				this.addChild(g);

				g.updataInfo(TableManager.getInstance().getItemInfo(o[i][0]));
				if (o[i][1] > 1)
					g.setNum(o[i][1]);

				g.x=20 + i * 52;
				g.y=360;

				this.item1Arr.push(g);
			}

			var vipInfo:TVIPDetailInfo=TableManager.getInstance().getVipDetailInfo(1);

			for (i=0; i < 5; i++) {

				if (vipInfo["item" + (i + 1)] == "")
					continue;

				g=new MissionGrid();
				this.addChild(g);

				g.updataInfo(TableManager.getInstance().getItemInfo(vipInfo["item" + (i + 1)]));

				if (vipInfo["num" + (i + 1)] > 1)
					g.setNum(vipInfo["num" + (i + 1)]);

				g.x=20 + i * 52;
				g.y=432;

				this.item2Arr.push(g);

			}

			this.addChild(this.get1Img);
			this.addChild(this.get2Img);

			if (PlayerEnum.PRO_MASTER == Core.me.info.profession) {
				swfeff.update(99956);
			} else if (PlayerEnum.PRO_RANGER == Core.me.info.profession) {
				swfeff.update(99958);
			} else if (PlayerEnum.PRO_SOLDIER == Core.me.info.profession) {
				swfeff.update(99955);
			} else if (PlayerEnum.PRO_WARLOCK == Core.me.info.profession) {
				swfeff.update(99957);
			}

			this.swfeff.scaleX=this.swfeff.scaleY=0.7;
			this.swfeff.mouseChildren=this.swfeff.mouseEnabled=false;
//			this.swfeff.opaqueBackground=0xff0000;
		}

		private function onClick(e:MouseEvent):void {

			this.flyIds=[];
			this.starts=[];
			this.flyIds1=[];
			this.starts1=[];

			var g:MissionGrid;

			for (var i:int=0; i < this.item1Arr.length; i++) {
				g=this.item1Arr[i]
				flyIds.push(g.dataId);
				starts.push(this.localToGlobal(new Point(g.x, g.y)));
			}

			for (i=0; i < this.item2Arr.length; i++) {
				g=this.item2Arr[i]
				flyIds1.push(g.dataId);
				starts1.push(this.localToGlobal(new Point(g.x, g.y)));
			}

//			FlyManager.getInstance().flyBags(flyIds, starts);
//			FlyManager.getInstance().flyBags(flyIds1, starts1);
//			return;
			if (!this.get1Img.visible || !this.get2Img.visible) {

				if (this.st == 1 && flyIds.length > 0) {
					Cmd_ddsc.cm_DdscConfirm();

					FlyManager.getInstance().flyBags(flyIds, starts);
					flyIds.length=0;
					starts.length=0;
				}

				if (flyIds1.length > 0) {

					if (Core.me.info.vipLv == 0) {
						PayUtil.openPayUrl()
					} else {
						Cmd_Vip.cm_VIP_J(1);

						FlyManager.getInstance().flyBags(flyIds1, starts1);
						flyIds1.length=0;
						starts1.length=0;
					}
				}
			} else
				UILayoutManager.getInstance().open(WindowEnum.FIRST_PAY);
		}

		public function setGet1State(st:int):void {
			this.get1Img.visible=(st == 2);
			this.st=st;
		}

		public function setGet2State(v:Boolean):void {
			this.get2Img.visible=v;
		}


	}
}
