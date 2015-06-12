package com.leyou.ui.badge.child {

	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBloodBase;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.SwitchButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.ClassUtil;
	import com.ace.utils.PnfUtil;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	import com.leyou.data.effect.MovieClipLoader;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.net.cmd.Cmd_Bld;
	import com.leyou.ui.tips.TipsBadge;
	import com.leyou.ui.tips.TipsBadgeWnd1;
	import com.leyou.ui.tips.TipsBadgeWnd2;
	import com.leyou.ui.tips.TipsBadgeWnd3;
	import com.leyou.utils.FilterUtil;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class BadgeBg01 extends AutoSprite {

		private var wgLbl:Label;
		private var wfLbl:Label;
		private var bjLbl:Label;
		private var sxLbl:Label;
		private var fgLbl:Label;
		private var mzLbl:Label;
		private var spLbl:Label;
		private var ffLbl:Label;
		private var bsLbl:Label;
		private var shLbl:Label;
		private var smLbl:Label;
		private var flLbl:Label;

		private var imgBg:Image;

		private var pointBtnArr:Vector.<MovieClip>;

		private var pointXML:XML;

		private var index:int=0;

		public var tipsb:TipsBadge;

		private var lvinfoXml:XML;

		private var drawLine:Sprite;

		/**
		 *完成
		 */
		private var effectSucc:SwfLoader;

		public function BadgeBg01() {
			super(LibManager.getInstance().getXML("config/ui/badge/badgeBg01.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.wgLbl=this.getUIbyID("wgLbl") as Label;
			this.wfLbl=this.getUIbyID("wfLbl") as Label;
			this.bjLbl=this.getUIbyID("bjLbl") as Label;
			this.sxLbl=this.getUIbyID("sxLbl") as Label;
//			this.fgLbl=this.getUIbyID("fgLbl") as Label;
			this.mzLbl=this.getUIbyID("mzLbl") as Label;
			this.spLbl=this.getUIbyID("spLbl") as Label;
//			this.ffLbl=this.getUIbyID("ffLbl") as Label;
			this.bsLbl=this.getUIbyID("bsLbl") as Label;
			this.shLbl=this.getUIbyID("shLbl") as Label;
			this.smLbl=this.getUIbyID("smLbl") as Label;
//			this.flLbl=this.getUIbyID("flLbl") as Label;

			this.imgBg=this.getUIbyID("imgBg") as Image;

			this.pointBtnArr=new Vector.<MovieClip>();

			this.drawLine=new Sprite();
			this.addChild(this.drawLine);

			var ibtn:MovieClip;
			for (var i:int=0; i < 10; i++) {

				ibtn=ClassUtil.getCls("ui.effect.btn_badge") as MovieClip;
				ibtn.gotoAndStop(4);
				ibtn.mouseChildren=false;

				this.pointBtnArr.push(ibtn);
				this.addChild(ibtn);

				ibtn.addEventListener(MouseEvent.CLICK, onBtnClick);
				ibtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				ibtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
//				ibtn.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//				ibtn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}

			pointXML=LibManager.getInstance().getXML("config/table/bloodPoint.xml");

			this.tipsb=new TipsBadge();
			lvinfoXml=<data/>;

			this.effectSucc=new SwfLoader(99966,null, false);
			this.addChild(this.effectSucc);

			this.effectSucc.visible=false;
		}

		/**
		 * @param o
		 */
		public function updateData(index:int):void {

			//10个点
			if (this.index != index) {
				this.index=index;

//				for (var k:int=0; k < 10; k++)
//					TweenMax.killChildTweensOf(this.pointBtnArr[k]);

				this.updatePoint(index);
			}

			lvinfoXml=<data/>;

			var lvBase:XML=LibManager.getInstance().getXML("config/table/bloodBase.xml");
			var i:int=UIManager.getInstance().badgeWnd.currentOpenPoint;

			var lv:int=i / 100;
			var p:int=i % 100;

			var op:int=p;
			var oc:int=lv

			p=(p <= 0 ? 0 : p - 1);

			if (index != lv) {
				if (index < lv)
					p=9;
				else
					p=0;
				lv=index;
			}

			var temp:XML;
			for each (temp in lvBase.bloodBase) {
				if (temp.@bloodId == lv)
					lvinfoXml.appendChild(temp);
			}

			var info:TBloodBase=new TBloodBase();

			var tempxml:XML;
			for (var _i:int=0; _i <= p; _i++) {

				tempxml=lvinfoXml.bloodBase[_i];

				info.p_attack=int(info.p_attack) + int(tempxml.@p_attack) + "";
				info.p_defense=int(info.p_defense) + int(tempxml.@p_defense) + "";
				info.crit=int(info.crit) + int(tempxml.@crit) + "";
				info.critReduce=int(info.critReduce) + int(tempxml.@critReduce) + "";
				info.m_attack=int(info.m_attack) + int(tempxml.@m_attack) + "";
				info.hit=int(info.hit) + int(tempxml.@hit) + "";
				info.dodge=int(info.dodge) + int(tempxml.@dodge) + "";
				info.m_defense=int(info.m_defense) + int(tempxml.@m_defense) + "";
				info.critDam=int(info.critDam) + int(tempxml.@critDam) + "";
				info.critDamReduce=int(info.critDamReduce) + int(tempxml.@critDamReduce) + "";
				info.extraHP=int(info.extraHP) + int(tempxml.@extraHP) + "";
				info.extraMP=int(info.extraMP) + int(tempxml.@extraMP) + "";

			}

			if (op != 0 || this.index != oc) {

				this.wgLbl.text=int(info.p_attack) + "";
				this.wfLbl.text=int(info.p_defense) + "";
				this.bjLbl.text=int(info.crit) + "";
				this.sxLbl.text=int(info.critReduce) + "";
//				this.fgLbl.text=int(info.m_attack) + "";
				this.mzLbl.text=int(info.hit) + "";
				this.spLbl.text=int(info.dodge) + "";
//				this.ffLbl.text=int(info.m_defense) + "";
				this.bsLbl.text=int(info.critDam) + "";
				this.shLbl.text=int(info.critDamReduce) + "";
				this.smLbl.text=int(info.extraHP) + "";
//				this.flLbl.text=int(info.extraMP) + "";

			} else {

				this.wgLbl.text="0";
				this.wfLbl.text="0";
				this.bjLbl.text="0";
				this.sxLbl.text="0";
//				this.fgLbl.text="0";
				this.mzLbl.text="0";
				this.spLbl.text="0";
//				this.ffLbl.text="0";
				this.bsLbl.text="0";
				this.shLbl.text="0";
				this.smLbl.text="0";
//				this.flLbl.text="0";

			}

			if (index < 10) {
				this.imgBg.updateBmp("ui/badge/badge_bg_0" + index + ".jpg");
			} else
				this.imgBg.updateBmp("ui/badge/badge_bg_" + index + ".jpg");


		}

		private function updatePoint(index:int, effect:Boolean=false):void {
			var xml:XML=pointXML.bloodPoint[index - 1];

			this.drawLine.graphics.clear();
			this.drawLine.graphics.lineStyle(1, 0xf6d654);

			var lv:int=UIManager.getInstance().badgeWnd.currentOpenPoint;
			if (!effect) {
//				TweenMax.killAll(true, true);
			}

			for (var i:int=0; i < 10; i++) {

				if (!effect) {
					var rx:Number=Number(xml.attribute("x" + (i + 1)));
					var ry:Number=Number(xml.attribute("y" + (i + 1)));

					TweenMax.to(this.pointBtnArr[i], 2, {overwrite: OverwriteManager.PREEXISTING, x: rx, y: ry, onUpdate: updatePoint, onUpdateParams: [this.index, true]});
				}

				if (i == 0)
					this.drawLine.graphics.moveTo(this.pointBtnArr[i].x, this.pointBtnArr[i].y);

				if (i > 0)
					this.drawLine.graphics.lineTo(this.pointBtnArr[i].x, this.pointBtnArr[i].y);

				if (this.index == int(lv / 100) && i > lv % 100 - 1) {

					if (index * 100 + i == lv)
						this.pointBtnArr[i].gotoAndStop(1);
					else
						this.pointBtnArr[i].gotoAndStop(4);

					this.drawLine.graphics.lineStyle(1, 0xcccccc);
				} else {
					this.pointBtnArr[i].gotoAndStop(3);
				}

			}

			this.drawLine.graphics.endFill();
		}

		public function openNodeEffect():void {

			this.effectSucc.visible=true;
			
//			if (this.effectSucc.isLoaded)
				this.effectSucc.playAct(PlayerEnum.ACT_STAND, -1, false, onPlayerComplete);

			this.effectSucc.x=this.mouseX;
			this.effectSucc.y=this.mouseY;

			function onPlayerComplete():void {
				effectSucc.visible=false;
			}

		}

		private function onMouseDown(e:MouseEvent):void {
			MovieClip(e.target).gotoAndStop(3);
		}

		private function onMouseUp(e:MouseEvent):void {
			MovieClip(e.target).gotoAndStop(1);
		}

		private function onMouseOver(e:MouseEvent):void {

			var p:int=this.pointBtnArr.indexOf(e.target as MovieClip) + 1;

			if (index <= (UIManager.getInstance().badgeWnd.currentOpenPoint / 100) && index * 100 + p <= UIManager.getInstance().badgeWnd.currentOpenPoint + 1) {

				this.drawLine.graphics.clear();
				this.drawLine.graphics.lineStyle(1, 0xf6d654);

//				TweenMax.killAll(true);

				var xml:XML=pointXML.bloodPoint[index - 1];
				var dx:int=3;

				for (var i:int=0; i < 10; i++) {

					if (index * 100 + i <= UIManager.getInstance().badgeWnd.currentOpenPoint) {

						if (i == p - 1)
							dx=8;
						else
							dx=0;

						var rx:Number=int(xml.attribute("x" + (i + 1))) + Math.random() * 5 + Math.random() * -5 + dx;
						var ry:Number=int(xml.attribute("y" + (i + 1))) + Math.random() * 5 + Math.random() * -5 + dx;

//						TweenMax.killChildTweensOf(this.pointBtnArr[i]);
						TweenMax.to(this.pointBtnArr[i], 2, {overwrite: OverwriteManager.PREEXISTING, x: rx, y: ry, ease: Elastic.easeOut, onUpdate: updatePoint, onUpdateParams: [this.index, true]});
					}
				}
			}

			var state:int=0;

			if (index * 100 + p == UIManager.getInstance().badgeWnd.currentOpenPoint + 1) {
				state=1;

				MovieClip(e.target).gotoAndStop(1);

			} else if (index * 100 + p <= UIManager.getInstance().badgeWnd.currentOpenPoint) {
				state=2;
			}

			this.tipsb.updateData(new TBloodBase(lvinfoXml.bloodBase[p - 1]), state);
			this.tipsb.updatePs(e.stageX, e.stageY);
			this.tipsb.visible=true;
		}

		private function onMouseOut(e:MouseEvent):void {
			this.tipsb.visible=false;

			var p:int=this.pointBtnArr.indexOf(e.target as MovieClip) + 1;

			if (index * 100 + p > UIManager.getInstance().badgeWnd.currentOpenPoint) {

				if (index * 100 + p == UIManager.getInstance().badgeWnd.currentOpenPoint + 1)
					MovieClip(e.target).gotoAndStop(1);
				else
					MovieClip(e.target).gotoAndStop(4);
			} else
				MovieClip(e.target).gotoAndStop(3);

		}

		private function onBtnClick(e:MouseEvent):void {

			var p:int=this.pointBtnArr.indexOf(e.target as MovieClip) + 1;
			var targetP:int=index * 100 + p;

			if (targetP == UIManager.getInstance().badgeWnd.currentOpenPoint + 1) {
				Cmd_Bld.cm_bldOpenToPoint(UIManager.getInstance().badgeWnd.currentOpenPoint + 1);
				GuideManager.getInstance().removeGuide(14);
			} else if (targetP > UIManager.getInstance().badgeWnd.currentOpenPoint + 1) {
				//notice
				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1510));
			} else if (targetP < UIManager.getInstance().badgeWnd.currentOpenPoint + 1) {
				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1509));
			}
		}


	}
}
