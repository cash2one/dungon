package com.leyou.ui.client {
	import com.ace.config.Core;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_WeiDuan;
	import com.leyou.ui.day7.child.Day7Grid;

	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class ClientWnd extends AutoWindow {
		private var dAndLBtn:ImgButton;
		private var ylqImg:Image;
		private var statusImg:Image;

		public function ClientWnd() {
			super(LibManager.getInstance().getXML("config/ui/client/clientWnd.xml"));
			init();
		}

		private var items:Vector.<GridBase>=new Vector.<GridBase>;

		private function init():void {
			this.hideBg();
			this.clsBtn.x-=42;
			this.clsBtn.y+=18;
			dAndLBtn=getUIbyID("dAndLBtn") as ImgButton;
			ylqImg=getUIbyID("ylqImg") as Image;
			statusImg=getUIbyID("statusImg") as Image;

			var arr:Array=ConfigEnum.weiDuanJL;
			var g:Day7Grid;
			var itemInfo:TItemInfo;
			for (var i:int=0; i < arr.length; i++) {
				g=new Day7Grid();
				this.items.push(g);
				itemInfo=TableManager.getInstance().getItemInfo(String(arr[i]).split(",")[0]);
				g.updataInfo(itemInfo);
				g.setNum(String(arr[i]).split(",")[1]);
				g.setSize(60, 60);
				g.x=92 + 80 * i;
				g.y=187;
				this.addToPane(g);
			}

			this.addChild(this.ylqImg);

			dAndLBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		protected function onMouseClick(event:MouseEvent):void {
			var tar:*=event.target;
			if (tar.name == "dAndLBtn") {
				if (Core.isWeiduan) {
					!isGot && Cmd_WeiDuan.cm_dljl_J();
				} else {
					navigateToURL(new URLRequest(Core.URL_WEIDUAN));
				}
			}
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			!this.isGot && Cmd_WeiDuan.cm_dljl_I(Core.isWeiduan);
		}

		private var isGot:Boolean;

		public function sm_xxx($isGot:Boolean, isFirst:Boolean):void {
			this.isGot=$isGot;
			this.ylqImg.visible=isGot;
			this.statusImg.updateBmp(Core.isWeiduan ? "ui/client/font_lqjl.png" : "ui/client/font_xzwd.png");

			//已领取
			if (isGot) {
				Core.isWeiduan && this.dAndLBtn.setActive(false, 1, true);
				isFirst && FlyManager.getInstance().flyBagsII(this.items);
			} else {
				this.dAndLBtn.setActive(true, 1, true);
			}
		}
	}
}
