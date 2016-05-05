package com.leyou.ui.medic {


	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenMax;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.ui.medic.childs.RoleMedicRender;
	import com.leyou.ui.medic.childs.RoleMedicRender2;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class RoleMedicWnd extends AutoWindow {

		private var curImg:Image;
		private var nameLbl:Label;
		private var ptxtLbl:Label;
		private var pLbl:Label;
		private var addLbl:Label;
		private var effect:SwfLoader;

		private var lBtn:ImgButton;
		private var rBtn:ImgButton;

		private var rateLbl:Label;

		private var renderContiner:RoleMedicRender2;

		private var renderMaxk:Sprite;
		private var rateMask:Sprite;

		private var tips:TipsInfo;

		private var rmr:RoleMedicRender;

		private var selectID:int=-1;

		public function RoleMedicWnd() {
			super(LibManager.getInstance().getXML("config/ui/medic/roleMedicWnd.xml"));
			this.init();
			this.hideBg();
			this.allowDrag=false;
//			this.clsBtn.y+=25;
		}

		private function init():void {

			this.curImg=this.getUIbyID("curImg") as Image;

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.ptxtLbl=this.getUIbyID("ptxtLbl") as Label;
			this.pLbl=this.getUIbyID("pLbl") as Label;
			this.addLbl=this.getUIbyID("addLbl") as Label;
			this.effect=this.getUIbyID("effect") as SwfLoader;

			this.lBtn=this.getUIbyID("lBtn") as ImgButton;
			this.rBtn=this.getUIbyID("rBtn") as ImgButton;

			this.rateLbl=this.getUIbyID("rateLbl") as Label;

			this.renderContiner=new RoleMedicRender2();
			this.addChild(this.renderContiner);

			this.renderContiner.x=35;
			this.renderContiner.y=375;

			this.renderMaxk=new Sprite();
			this.addChild(renderMaxk);

			this.renderMaxk.graphics.beginFill(0x000000);
			this.renderMaxk.graphics.drawRect(0, 0, 232, 150);
			this.renderMaxk.graphics.endFill();

			this.renderMaxk.x=35;
			this.renderMaxk.y=355;

			this.renderMaxk.alpha=0;

			this.renderContiner.mask=this.renderMaxk;

			this.lBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.rBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.addEventListener(MouseEvent.CLICK, onItemClick);

			this.tips=new TipsInfo();

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.curImg, einfo);

			this.rateMask=new Sprite();
			this.addChild(rateMask);

			this.rateMask.graphics.beginFill(0x000000);
			this.rateMask.graphics.drawRect(0, 0, 90, 90);
			this.rateMask.graphics.endFill();

			this.rateMask.x=108;
			this.rateMask.y=214;
			this.rateMask.scaleY=0;

			this.rateMask.alpha=0;

			this.effect.mask=this.rateMask;

			this.lBtn.visible=false;
			this.rBtn.visible=true;
		}

		private function onTipsMouseOver(e:DisplayObject):void {

			this.tips.isShowPrice=false;
			ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, this.tips, new Point(this.stage.mouseX, this.stage.mouseY));

		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "lBtn":
//					if (this.renderContiner.x + 58 > this.renderMaxk.x) {
//						this.renderContiner.x=this.renderMaxk.x;
//					} else
//						TweenMax.to(this.renderContiner, .1, {x: this.renderContiner.x + 58, overwrite: OverwriteManager.ALL_IMMEDIATE});

					TweenMax.to(this.renderContiner, .1, {x: this.renderMaxk.x});
					this.lBtn.visible=false;
					this.rBtn.visible=true;
					break;
				case "rBtn":
//					if (this.renderContiner.x + this.renderContiner.width - 58 < this.renderMaxk.x + this.renderMaxk.width) {
//						this.renderContiner.x=this.renderMaxk.x + this.renderMaxk.width - this.renderContiner.width;
//					} else
//						TweenMax.to(this.renderContiner, .1, {x: this.renderContiner.x - 58, overwrite: OverwriteManager.ALL_IMMEDIATE});

					TweenMax.to(this.renderContiner, .1, {x: this.renderMaxk.x + this.renderMaxk.width - this.renderContiner.width});
					this.lBtn.visible=true;
					this.rBtn.visible=false;
					break;
			}

		}

		private function onItemClick(e:MouseEvent):void {
//			trace(e);

			if (e.target is RoleMedicRender) {

				if (rmr != null)
					rmr.Hight=false;

				rmr=e.target as RoleMedicRender;

				var titem:TItemInfo=TableManager.getInstance().getItemInfo(rmr.id);
				if (titem == null)
					return;

				this.curImg.updateBmp("ico/items/" + titem.icon + ".png");
				this.nameLbl.text="" + titem.name + "(" + rmr.num + "/" + titem.Item_degree + ")";

				this.ptxtLbl.text=PropUtils.prop2Arr[titem.value - 1] + "：";
				this.pLbl.text="+" + titem.useValue;

				this.addLbl.text="+" + (titem.useValue * rmr.num);

				this.rateLbl.text=int(rmr.num / titem.Item_degree * 100) + "%";
				this.rateMask.scaleY=-(rmr.num / titem.Item_degree);

				rmr.Hight=true;

				this.tips.itemid=titem.id;
			}

		}


		public function updateInfo(o:Object):void {

			this.renderContiner.updateInfo(o.dlist as Array);
			if (this.selectID == -1) {
				this.renderContiner.selectDefault();
				this.renderContiner.x=35;
			}

//			UIManager.getInstance().showPanelCallback(WindowEnum.MEDIC);
		}


		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;

			Cmd_Longz.cm_Longz_D();
		}

		override public function hide():void {
			super.hide();

			this.selectID=-1;
			UILayoutManager.getInstance().composingWnd(WindowEnum.ROLE);
		}

		public function setUseSelect(id:int):void {
			this.selectID=id;
			var d:Number=this.renderContiner.setUseSelectEffect(id);
			this.renderContiner.x=35 - d;

			if (this.renderContiner.x + 58 > this.renderMaxk.x || d + 58 < this.renderMaxk.width) {
				this.renderContiner.x=this.renderMaxk.x;

				this.lBtn.visible=false;
				this.rBtn.visible=true;
			} else if (this.renderContiner.x + this.renderContiner.width - 58 < this.renderMaxk.x + this.renderMaxk.width) {
				this.renderContiner.x=this.renderMaxk.x + this.renderMaxk.width - this.renderContiner.width;

				this.lBtn.visible=true;
				this.rBtn.visible=false;
			}
		}

		override public function get height():Number {
			return 524;
		}

		override public function get width():Number {
			return 306;
		}

	}
}
