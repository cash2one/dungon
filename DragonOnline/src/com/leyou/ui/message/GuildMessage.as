package com.leyou.ui.message {

	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSeGuild;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.GuideDirectManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenMax;
	import com.leyou.data.tips.TipsInfo;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GuildMessage extends AutoWindow {

		private var nowBtn:NormalButton;
		private var iconImg:Image;
		private var nameLbl:Label;

		private var tips:TipsInfo;
		private var info:TSeGuild;

		private var showEff:TweenMax;

		public function GuildMessage() {
			super(LibManager.getInstance().getXML("config/ui/message/guildMessage.xml"));
			init();
		}

		private function init():void {

			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.nowBtn=this.getUIbyID("nowBtn") as NormalButton;
			this.nowBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.tips=new TipsInfo();

//			var einfo:MouseEventInfo=new MouseEventInfo();
//			einfo.onMouseMove=onTipsMouseOver;
//			einfo.onMouseOut=onTipsMouseOut;
//
//			MouseManagerII.getInstance().addEvents(this.iconImg, einfo);
		}

		private function onTipsMouseOver(e:Object):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, this.tips, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:Object):void {
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {

			var uid1:int;
			var uid2:int;

			var arrid:int;
			var showArrow:Boolean=true;

			var daley:Number=0.3;

			if (info.uiId.indexOf(",") > -1) {

				uid1=info.uiId.split(",")[0];
				uid2=info.uiId.split(",")[1];

				switch (uid1) {
					case WindowEnum.ELEMENT:
						UIOpenBufferManager.getInstance().open(WindowEnum.ELEMENT);
						break;
					default:  {
						if (!UIManager.getInstance().getWindow(uid1).visible)
							UILayoutManager.getInstance().show_II(uid1);
					}
				}

				TweenMax.delayedCall(0.4, function():void {

					/**
					 *tab页
					 */
					if (info.tagId != "") {

						switch (uid1) {
							case WindowEnum.ROLE:
								UIManager.getInstance().roleWnd.setTabIndex(int(info.tagId));
								break;
						}
					}

					/**
					 * 二级页
					 */
					switch (uid1) {
						case WindowEnum.ELEMENT:
							showArrow=(DataManager.getInstance().elementData.ctype != 0);
							if (DataManager.getInstance().elementData.ctype != 0) {
								UILayoutManager.getInstance().open(WindowEnum.ELEMENT, WindowEnum.ELEMENT_UPGRADE);
							}
							break
						default:
							UILayoutManager.getInstance().show_II(uid1, uid2);
					}
				});

				arrid=uid2;
				daley=0.7;

			} else {


				if (int(info.uiId) == WindowEnum.GEM_LV) {
					UILayoutManager.getInstance().show(int(info.uiId));

					TweenMax.delayedCall(.3, function():void {
						UIManager.getInstance().gemLvWnd.setSelectById(int(info.typeId));
					});

				} else if (int(info.uiId) == WindowEnum.BADAGE) {
					UILayoutManager.getInstance().show_II(int(info.uiId));
				} else if (int(info.uiId) == WindowEnum.WELFARE) {

					UIManager.getInstance().creatWindow(int(info.uiId));
					if (!UIManager.getInstance().getWindow(int(info.uiId)).visible)
						UIOpenBufferManager.getInstance().open(WindowEnum.WELFARE);
				} else if (int(info.uiId) == WindowEnum.LUCKDRAW) {

					UIManager.getInstance().creatWindow(int(info.uiId));
					if (!UIManager.getInstance().getWindow(int(info.uiId)).visible)
						UIOpenBufferManager.getInstance().open(WindowEnum.LUCKDRAW);
				} else {
					UILayoutManager.getInstance().show_II(int(info.uiId));
				}

				if (info.tagId != "") {
					TweenMax.delayedCall(0.6, function():void {
						switch (int(info.uiId)) {
							case WindowEnum.ROLE:
								UIManager.getInstance().roleWnd.setTabIndex(int(info.tagId));
								break;
							case WindowEnum.SKILL:
								UIManager.getInstance().skillWnd.setTabIndex(int(info.tagId));
								break;
							case WindowEnum.WELFARE:
								UIManager.getInstance().welfareWnd.changeTable(int(info.tagId));
								break;
							case WindowEnum.LUCKDRAW:
								UIManager.getInstance().luckDrawWnd.setTabIndex(int(info.tagId));
								break;
						}
					});
				}

				arrid=int(info.uiId);
				daley=0.6
			}


			TweenMax.delayedCall(daley, function():void {
				if (showArrow)
					GuideArrowDirectManager.getInstance().addArrow(info, UIManager.getInstance().getWindow(arrid) as AutoWindow);
			});

			GuideDirectManager.getInstance().delPanel(this.info.id);
			this.hide();
		}

		public function updateInfo(tinfo:TSeGuild):void {
			this.info=tinfo;

			if (tinfo.typeId.indexOf(",") > -1) {
				this.tips.itemid=tinfo.typeId.split(",")[0];
			} else {
				this.tips.itemid=int(tinfo.typeId);
			}

			this.iconImg.updateBmp("ico/items/" + tinfo.icon);
			this.nameLbl.text="" + tinfo.des;
			this.nowBtn.text="" + tinfo.btnDes;

			this.showEff=TweenMax.to(this.nowBtn, 1, {glowFilter: {color: 0xfa9611, alpha: 1, blurX: 20, blurY: 20, strength: 2}, yoyo: true, repeat: -1});


		}

		public function showPanel(o:TSeGuild):void {

			this.updateInfo(o);
			var arrid:int;
			if (info.uiId.indexOf(",") > -1) {
				arrid=info.uiId.split(",")[1];
			} else {
				arrid=int(info.uiId);
			}

			if (!UIManager.getInstance().isCreate(arrid) || !UIManager.getInstance().getWindow(arrid).visible)
				this.show();
		}

		override public function hide():void {
			super.hide();

			GuideDirectManager.getInstance().delPanel(this.info.id);
//			this.info=null;
			if (this.showEff != null) {
				this.showEff.pause();
				this.showEff.kill();
				this.showEff=null;
			}

			this.nowBtn.filters=[];
			LayerManager.getInstance().windowLayer.removeChild(this);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			this.reSize();
		}

		public function reSize():void {
			this.x=(UIEnum.WIDTH - 308);
			this.y=(UIEnum.HEIGHT - 249);
		}

		override public function get width():Number {
			return 308;
		}

		override public function get height():Number {
			return 249;
		}

	}
}
