package com.leyou.ui.medic.childs {


	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenMax;
	import com.leyou.data.tips.TipsInfo;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class RoleMedicRender extends AutoSprite {

		private var effectImg:Image;
		private var iconImg:Image;
		private var numLbl:Label;

		public var id:int=0;
		public var num:int=0;

		public var tween:TweenMax;

		private var tips:TipsInfo;

		public function RoleMedicRender() {
			super(LibManager.getInstance().getXML("config/ui/medic/roleMedicRender.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {

			this.effectImg=this.getUIbyID("effectImg") as Image;
			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.numLbl=this.getUIbyID("numLbl") as Label;

			this.tips=new TipsInfo();

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.iconImg, einfo);
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			this.tips.isShowPrice=false;
			ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, this.tips, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		public function updateInfo(a:Array):void {

			var titem:TItemInfo=TableManager.getInstance().getItemInfo(a[0]);
			if (titem == null)
				return;

			this.iconImg.updateBmp("ico/items/" + titem.icon + ".png");
			this.effectImg.visible=false;
			this.numLbl.text="" + a[1] + "/" + titem.Item_degree;

			this.tips.itemid=a[0];
			this.id=a[0];
			this.num=a[1];
		}

		public function set Hight(v:Boolean):void {

			if (tween != null) {
				tween.pause();
				tween.kill();
			}

			this.effectImg.visible=false;

			if (v) {
				this.effectImg.visible=true;
				this.effectImg.alpha=1;
				tween=TweenMax.to(this.effectImg, 1, {alpha: 0.5, overwrite: OverwriteManager.ALL_IMMEDIATE, repeat: -1, yoyo: true});
			}

		}

		override public function get width():Number {
			return 58;
		}

		override public function get height():Number {
			return 60;
		}

	}
}
