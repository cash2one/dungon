package com.leyou.ui.gem {

	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Gem;
	import com.leyou.ui.gem.child.GemGrid;
	import com.leyou.utils.PropUtils;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	public class GemWnd extends AutoSprite {

		private var gArr:Array=[];
		private var gSprArr:Array=[];
		private var lvArr:Array=[];

		private var g1propArr:Array=[];
		private var g2propArr:Array=[];
		private var g3propArr:Array=[];

		private var numTmpArr:Array=[];

		private var rollPower:RollNumWidget;

		private var ruleTitleLbl:Label;
		private var ruleLbl:Label;
		private var addPropsBtn:NormalButton;
		private var arrowImg:Image;

		private var gemGridVec:Vector.<GemGrid>;
		private var gemRadioGridVec:Array=[];
		private var gemDegressGridVec:Array=[];

		private var sImgArr:Array=[];
		private var curImg:Image;
		private var curPowerImg:Image;
		private var raceImg1:Image;
		private var raceImg:Image;

		private var otherPlayer:Boolean=false;

		private var tips:TipsInfo;

		private var rollSpr:Sprite;

		/**
		 *单前使用的装备索引
		 */
		private var currentEquipIndex:int=-1;

		private var angleRate:int=0;
		private var centerPoint:Point;
		private var centerBgPoint:Point;
		private var centerCurPoint:Point;
		private var centerCurPowerPoint:Point;
		private var r:int;


		public function GemWnd(other:Boolean=false) {
			super(LibManager.getInstance().getXML("config/ui/gem/gemWnd.xml"));
			this.otherPlayer=other;
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {

			this.gArr.push(this.getUIbyID("g1Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g2Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g3Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g4Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g5Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g6Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g7Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g8Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g9Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g10Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g11Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g12Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g13Img") as ImgButton);
			this.gArr.push(this.getUIbyID("g14Img") as ImgButton);

			this.lvArr.push(this.getUIbyID("power1img") as Image);
			this.lvArr.push(this.getUIbyID("power2img") as Image);
			this.lvArr.push(this.getUIbyID("power3img") as Image);
			this.lvArr.push(this.getUIbyID("power4img") as Image);
			this.lvArr.push(this.getUIbyID("power5img") as Image);
			this.lvArr.push(this.getUIbyID("power6img") as Image);
			this.lvArr.push(this.getUIbyID("power7img") as Image);
			this.lvArr.push(this.getUIbyID("power8img") as Image);
			this.lvArr.push(this.getUIbyID("power9img") as Image);
			this.lvArr.push(this.getUIbyID("power10img") as Image);
			this.lvArr.push(this.getUIbyID("power11img") as Image);
			this.lvArr.push(this.getUIbyID("power12img") as Image);
			this.lvArr.push(this.getUIbyID("power13img") as Image);
			this.lvArr.push(this.getUIbyID("power14img") as Image);

			this.curImg=this.getUIbyID("curImg") as Image;
			this.curPowerImg=this.getUIbyID("curPowerImg") as Image;
			this.raceImg1=this.getUIbyID("raceImg1") as Image;
			this.raceImg=this.getUIbyID("raceImg") as Image;

			this.sImgArr.push(this.getUIbyID("s1Img") as Image);
			this.sImgArr.push(this.getUIbyID("s2Img") as Image);
			this.sImgArr.push(this.getUIbyID("s3Img") as Image);

			this.g1propArr.push(this.getUIbyID("g1prop1Lbl") as Label);
			this.g1propArr.push(this.getUIbyID("g1prop2Lbl") as Label);
			this.g1propArr.push(this.getUIbyID("g1prop3Lbl") as Label);

			this.g2propArr.push(this.getUIbyID("g2prop1Lbl") as Label);
			this.g2propArr.push(this.getUIbyID("g2prop2Lbl") as Label);
			this.g2propArr.push(this.getUIbyID("g2prop3Lbl") as Label);

			this.g3propArr.push(this.getUIbyID("g3prop1Lbl") as Label);
			this.g3propArr.push(this.getUIbyID("g3prop2Lbl") as Label);
			this.g3propArr.push(this.getUIbyID("g3prop3Lbl") as Label);

			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;
			this.ruleTitleLbl=this.getUIbyID("ruleTitleLbl") as Label;

			this.ruleTitleLbl.mouseEnabled=true;
			this.ruleTitleLbl.addEventListener(MouseEvent.MOUSE_OVER, onRuleOver);
			this.ruleTitleLbl.addEventListener(MouseEvent.MOUSE_OUT, onRuleOut);

			this.rollPower=new RollNumWidget();
			this.rollPower.loadSource("ui/num/{num}_zdl.png");
			this.addChild(this.rollPower);
			this.rollPower.x=133
			this.rollPower.y=411;

			this.addPropsBtn=this.getUIbyID("addPropsBtn") as NormalButton;
			this.arrowImg=this.getUIbyID("arrowImg") as Image;

			this.rollSpr=new Sprite();
			this.addChild(this.rollSpr);

			this.rollSpr.x=124;
			this.rollSpr.y=52;

			this.rollSpr.addChild(this.sImgArr[0])
			this.rollSpr.addChild(this.sImgArr[1])
			this.rollSpr.addChild(this.sImgArr[2])

			this.sImgArr[0].x=this.sImgArr[0].x - this.rollSpr.x;
			this.sImgArr[0].y=this.sImgArr[0].y - this.rollSpr.y;

			this.sImgArr[1].x=this.sImgArr[1].x - this.rollSpr.x;
			this.sImgArr[1].y=this.sImgArr[1].y - this.rollSpr.y;

			this.sImgArr[2].x=this.sImgArr[2].x - this.rollSpr.x;
			this.sImgArr[2].y=this.sImgArr[2].y - this.rollSpr.y;

			this.gemGridVec=new Vector.<GemGrid>();

			var grid:GemGrid=new GemGrid();
			this.rollSpr.addChild(grid);
			grid.x=202 - this.rollSpr.x;
			grid.y=52 - this.rollSpr.y;

			grid.dataId=0;
			grid.effectGlow=this.effectGlow;

			this.gemGridVec.push(grid);

			grid=new GemGrid();
			this.rollSpr.addChild(grid);
			grid.x=124 - this.rollSpr.x;
			grid.y=190 - this.rollSpr.y;

			grid.dataId=1;
			grid.effectGlow=this.effectGlow;

			this.gemGridVec.push(grid);

			grid=new GemGrid();
			this.rollSpr.addChild(grid);
			grid.x=281 - this.rollSpr.x;
			grid.y=188 - this.rollSpr.y;

			grid.dataId=2;
			grid.effectGlow=this.effectGlow;

			this.gemGridVec.push(grid);

			this.gemGridVec[0].gemGridList=this.gemGridVec;
			this.gemGridVec[1].gemGridList=this.gemGridVec;
			this.gemGridVec[2].gemGridList=this.gemGridVec;

//			this.rollSpr.addChild(this.curImg);
//			this.rollSpr.addChild(this.curPowerImg);
//
//			this.curImg.x=this.curImg.x - this.rollSpr.x;
//			this.curImg.y=this.curImg.y - this.rollSpr.y;
//
//			this.curPowerImg.x=this.curPowerImg.x - this.rollSpr.x;
//			this.curPowerImg.y=this.curPowerImg.y - this.rollSpr.y;

			this.addPropsBtn.addEventListener(MouseEvent.CLICK, onClick);

			var spr:Sprite;
			var einfo1:MouseEventInfo
			for (var i:int=0; i < this.gArr.length; i++) {

//				einfo1=new MouseEventInfo();
//
//				if (!this.otherPlayer)
//					einfo1.onLeftClick=onMouseClick;
//
//				einfo1.onMouseMove=onMouseOver;
//				einfo1.onMouseOut=onMouseOut;
//
//				MouseManagerII.getInstance().addEvents(this.gArr[i], einfo1);

				spr=new Sprite();
				spr.graphics.beginFill(0x0000000);
				spr.graphics.drawRect(0, 0, 42, 42);
				spr.graphics.endFill();

				spr.x=this.gArr[i].x;
				spr.y=this.gArr[i].y;

				this.addChild(spr);

				spr.addEventListener(MouseEvent.CLICK, onMouseClick);

				spr.name="" + i;
				spr.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				spr.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

				spr.alpha=0;
			}

			spr=new Sprite();
			spr.graphics.beginFill(0x0000000);
			spr.graphics.drawRect(0, 0, 42, 42);
			spr.graphics.endFill();

			spr.x=this.curImg.x;
			spr.y=this.curImg.y;

			this.addChild(spr);

//			if (!this.otherPlayer)
//				spr.addEventListener(MouseEvent.CLICK, onMouseItemClick);

			spr.name="curimg";
			spr.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			spr.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			spr.alpha=0;

			this.raceImg1.alpha=0;

//			this.addChild(this.curImg);
//			this.addChild(this.curPowerImg);

//			this.ruleLbl.htmlText=TableManager.getInstance().getSystemNotice(6400).content;

			var img:Image;
			for (i=0; i < 10; i++) {
				img=new Image("ui/num/" + i + "_zdl.png", onTmpComplete);
			}

			this.tips=new TipsInfo();

			if (this.otherPlayer) {
				this.addPropsBtn.visible=false;
				this.arrowImg.visible=false;

				this.gemGridVec[0].doubleClickEnabled=false;
				this.gemGridVec[0].canMove=false;

				this.gemGridVec[1].doubleClickEnabled=false;
				this.gemGridVec[1].canMove=false;

				this.gemGridVec[2].doubleClickEnabled=false;
				this.gemGridVec[2].canMove=false;

			} else {
				this.addPropsBtn.visible=true;
				this.arrowImg.visible=true;
			}

			var a:int=Math.sqrt(Math.pow(this.gemGridVec[0].x - this.gemGridVec[1].x, 2) + Math.pow(this.gemGridVec[1].y - this.gemGridVec[0].y, 2));
			var b:int=Math.sqrt(Math.pow(this.gemGridVec[2].x - this.gemGridVec[0].x, 2) + Math.pow(this.gemGridVec[2].y - this.gemGridVec[0].y, 2));

			r=Math.sqrt(Math.pow(a / 2, 2) + Math.pow(b / 2, 2));
//			this.centerPoint=new Point(this.gemGridVec[0].x + 20, this.gemGridVec[0].y + r);
			this.centerPoint=new Point(this.rollSpr.width / 2 - 6, this.rollSpr.height / 2 + 20 - 5);
			this.centerBgPoint=new Point(this.raceImg.width / 2, this.raceImg.height / 2);
			this.centerCurPoint=new Point(this.curImg.width / 2, this.curImg.height / 2);
			this.centerCurPowerPoint=new Point(this.curPowerImg.width / 2, this.curPowerImg.height / 2);

			for (i=0; i < 3; i++) {
				this.gemRadioGridVec.push(Math.atan2(this.centerPoint.y - this.gemGridVec[i].y, this.centerPoint.x - this.gemGridVec[i].x) - Math.PI / 3);
				this.gemDegressGridVec.push(Math.atan2(this.centerPoint.y - this.gemGridVec[i].y, this.centerPoint.x - this.gemGridVec[i].x) * 180 / Math.PI);
			}


//			this.rollSpr.z=1;
//			this.rollSpr.opaqueBackground=0xffffff;

			var m3:Matrix3D;
			if (this.rollSpr.transform.matrix3D == null) {
				m3=new Matrix3D();
			} else
				m3=this.rollSpr.transform.matrix3D;

			m3.prependTranslation(this.rollSpr.x, this.rollSpr.y, 0);
			m3.prependRotation(0, Vector3D.Z_AXIS, new Vector3D(this.rollSpr.width / 2, this.rollSpr.height / 2));

			this.rollSpr.transform.matrix3D=m3;

//			if (this.raceImg.transform.matrix3D == null) {
//				m3=new Matrix3D();
//			} else
//				m3=this.raceImg.transform.matrix3D;
//
//			m3.prependTranslation(this.raceImg.x, this.raceImg.y, 0);
//			m3.prependRotation(0, Vector3D.Z_AXIS, new Vector3D(this.raceImg.width / 2, this.raceImg.height / 2));
//
//			this.raceImg.transform.matrix3D=m3;

//			spr=new Sprite();
//			spr.graphics.beginFill(0x0000000);
//			spr.graphics.lineStyle(1, 0xff0000);
//			spr.graphics.drawCircle(0, 0, this.r);
//			spr.graphics.endFill();
//
//			spr.x=this.rollSpr.x + this.centerPoint.x;
//			spr.y=this.rollSpr.y + this.centerPoint.y;
//
//			this.addChild(spr);


//			if (this.curImg.transform.matrix3D == null) {
//				m3=new Matrix3D();
//			} else
//				m3=this.curImg.transform.matrix3D;
//
//			m3.prependTranslation(this.curImg.x, this.curImg.y, 0);
//			m3.prependRotation(0, Vector3D.Z_AXIS, new Vector3D(20, 20));
//
//			this.curImg.transform.matrix3D=m3;


//			this.curImg.opaqueBackground=0xffffff;
//			this.curImg.isCenter=true;

			this.curImg.fillEmptyBmd();
			this.curPowerImg.fillEmptyBmd();

			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			this.x=-12;
			this.y=3;
		}

		private function onMouseUp(e:MouseEvent):void {

//			trace(e)
			if (e.target is GemWnd) {

				if (this.otherPlayer || DragManager.getInstance().grid == null || DragManager.getInstance().grid.isEmpty || this.currentEquipIndex == -1)
					return;

				var d:Baginfo=DragManager.getInstance().grid.data;

				if (d == null)
					return;

				var tequip:TEquipInfo;
				for (var i:int=0; i < this.gemGridVec.length; i++) {

					tequip=TableManager.getInstance().getEquipInfo(this.gemGridVec[i].getItemID());
					if (tequip != null && tequip.classid == 10 && tequip.classid == d.info.classid && tequip.subclassid == d.info.subclassid)
						break;

					if (this.gemGridVec[i].isEmpty)
						break;
				}

				Cmd_Gem.cmGemInlay(d.pos, this.currentEquipIndex, i);

				this.effectGlow();
			}
		}

		public function setCurrentSlotItem(pos:int):void {

			var d:Baginfo=MyInfoManager.getInstance().bagItems[pos];
			var tequip:TEquipInfo;

			for (var i:int=0; i < this.gemGridVec.length; i++) {

				tequip=TableManager.getInstance().getEquipInfo(this.gemGridVec[i].getItemID());
				if (tequip != null && tequip.classid == 10 && tequip.classid == d.info.classid && tequip.subclassid == d.info.subclassid)
					break;

				if (this.gemGridVec[i].isEmpty)
					break;
			}

			var ci:int=(this.currentEquipIndex == -1 ? 0 : this.currentEquipIndex);

			Cmd_Gem.cmGemInlay(d.pos, ci, i);

			this.effectGlow();

		}

		public function effectGlow():void {
			raceImg1.alpha=1;
			TweenLite.to(this.raceImg1, 2, {alpha: 0, overwrite: OverwriteManager.ALL_IMMEDIATE, onComplete: completeAlpha});

			function completeAlpha():void {
				raceImg1.alpha=0;
			}

		}

		private function onTmpComplete(e:Image):void {
			this.numTmpArr.push(e);
		}

		private function onMouseOver(e:MouseEvent):void {

			var index:int=int(e.target.name)

			if (e.target.name == "curimg")
				index=this.currentEquipIndex;

//			var equip:EquipInfo=MyInfoManager.getInstance().equips[index];
//			if (equip == null)
//				return;

//			this.tips.itemid=equip.id;
			this.tips.playPosition=index;
			this.tips.otherPlayer=this.otherPlayer;
			tips.isdiff=false;
			ToolTipManager.getInstance().show(TipEnum.TYPE_GEM, tips, new Point(this.stage.mouseX + this.width, this.stage.mouseY + this.height));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function onRuleOver(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(6400).content, new Point(this.stage.mouseX + this.width, this.stage.mouseY + this.height));
		}

		private function onRuleOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		/**
		 * 显示指定部位的宝石
		 * @param e
		 *
		 */
		private function onMouseClick(e:MouseEvent):void {

			if (this.currentEquipIndex == int(e.target.name) || this.angleRate != 0)
				return;

			if (this.currentEquipIndex != -1)
				this.gArr[this.currentEquipIndex].turnOff();

			this.currentEquipIndex=int(e.target.name);
//			this.gArr[this.currentEquipIndex].turnOn();
//
//			var img:Image=new Image();
//			img.bitmapData=this.gArr[this.currentEquipIndex].bitmapData;
//			img.updateBmp(this.gArr[this.currentEquipIndex].res.replace(".png", "_up.png"));
//			this.addChild(img);
//			img.x=e.target.x;
//			img.y=e.target.y;
//
//			TweenLite.to(img, .5, {x: this.curImg.x, y: this.curImg.y, onComplete: complete, onCompleteParams: [img]});


			this.updateCurrentList();

			if (UIManager.getInstance().selectWnd.visible) {
				UIManager.getInstance().selectWnd.GemSelectIndex=this.currentEquipIndex;
			}

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e:Event):void {

//			m3=this.curImg.transform.matrix3D;
// 
//			m3.appendTranslation(this.curImg.x, this.curImg.y, 0);
//			m3.appendRotation(5, Vector3D.Z_AXIS, new Vector3D(20, 20));
//			m3.appendTranslation(-this.curImg.x, -this.curImg.y, 0);
//			this.curImg.transform.matrix3D=m3;
//			
//			return;

			var addangle:int=20;

			if (this.angleRate >= 360) {
				this.angleRate=0;
				addangle=0;
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}

			var m3:Matrix3D;
			var m:Matrix;

//			var i:int=2;
//			for (var i:int=0; i < 3; i++) {
//
//				if (this.gemGridVec[i].isEmpty)
//					continue;
//
//				this.gemGridVec[i].x=this.centerPoint.x - 20 + (this.r - 20) * Math.cos((this.angleRate * Math.PI / 180) + Number(this.gemRadioGridVec[i]));
//				this.gemGridVec[i].y=this.centerPoint.y - 20 + (this.r -20) * Math.sin((this.angleRate * Math.PI / 180) + Number(this.gemRadioGridVec[i]));

//				if (this.gemGridVec[i].transform.matrix3D == null)
//					m3=new Matrix3D();
//				else
//					m3=this.gemGridVec[i].transform.matrix3D;
//
//				m3.appendRotation(angleRate + gemDegressGridVec[i], Vector3D.Z_AXIS, new Vector3D(this.centerPoint.x, this.centerPoint.y));
////				m3.appendRotation(angleRate + gemDegressGridVec[i], Vector3D.Z_AXIS, new Vector3D(this.gemGridVec[i].x + this.r, this.gemGridVec[i].y + this.r));
//				this.gemGridVec[i].transform.matrix3D=m3;
//			}

			m3=this.rollSpr.transform.matrix3D;
			m3.prependRotation(addangle, Vector3D.Z_AXIS, new Vector3D(this.centerPoint.x, this.centerPoint.y));
			this.rollSpr.transform.matrix3D=m3;

//			m3=this.raceImg.transform.matrix3D;
//			m3.prependRotation(addangle, Vector3D.Z_AXIS, new Vector3D(this.centerBgPoint.x, this.centerBgPoint.y));
//			this.raceImg.transform.matrix3D=m3;

//			m3=this.curImg.transform.matrix3D;
//			m3.prependTranslation(this.curImg.x, this.curImg.y, 0);
//			m3.prependRotation(addangle, Vector3D.Z_AXIS, new Vector3D(0, 0));
//			this.curImg.transform.matrix3D=m3;
//
//			m3=this.curPowerImg.transform.matrix3D;
//			m3.prependRotation(addangle, Vector3D.Z_AXIS, new Vector3D(this.centerCurPowerPoint.x, this.centerCurPowerPoint.y));
//			this.curPowerImg.transform.matrix3D=m3;

			this.angleRate+=addangle;

		}


		private function complete(img:Image):void {
			this.removeChild(img);
			this.updateCurrentList();

			if (UIManager.getInstance().selectWnd.visible) {
				UIManager.getInstance().selectWnd.GemSelectIndex=this.currentEquipIndex;
			}

		}

		private function updateCurrentList():void {

			if (this.currentEquipIndex == -1)
				return;

//			curImg.bitmapData=this.gArr[this.currentEquipIndex].bitmapData;
			curImg.updateBmp(this.gArr[this.currentEquipIndex].res.replace(".png", "_up.png"));

			this.gArr[this.currentEquipIndex].turnOn();

			var tequip:TEquipInfo;
			var arr:Array=MyInfoManager.getInstance().gemArr[this.currentEquipIndex];
			var p:int=0;
			var k:int=0;
			var lv:int=0;

			if (!this.otherPlayer)
				arr=MyInfoManager.getInstance().gemArr[this.currentEquipIndex];
			else
				arr=MyInfoManager.getInstance().othergemArr[this.currentEquipIndex];

			var str:String="";

			for (var i:int=0; i < this.gemGridVec.length; i++) {

				this.gemGridVec[i].selectIndex=this.currentEquipIndex;

				if (int(arr[i]) == 0) {

					this["g" + (i + 1) + "propArr"][0].text="";
					this["g" + (i + 1) + "propArr"][1].text="";
					this["g" + (i + 1) + "propArr"][2].text="";

					str+="<font color='#cccccc'>" + PropUtils.getStringById(1720) + "</font>\n";

					this.gemGridVec[i].reseGrid();
					this.gemGridVec[i].canMove=false;

				} else {

					tequip=TableManager.getInstance().getEquipInfo(arr[i]);
					if (tequip == null)
						return;

					lv+=tequip.level;

					this.gemGridVec[i].updataInfo(tequip);
					this.gemGridVec[i].canMove=true;

					str+="<font color='#00ff00'>" + tequip.name + "：";

//					this["g" + (i + 1) + "propArr"][0].text="" + tequip.name;
//					this["g" + (i + 1) + "propArr"][0].textColor=ItemUtil.getColorByQuality(tequip.quality);

					k=1;

					for (p=0; p < PropUtils.GemEquipTableColumn.length; p++) {
						if (int(tequip[PropUtils.GemEquipTableColumn[p]]) != 0) {
//							this["g" + (i + 1) + "propArr"][k].text=PropUtils.propArr[PropUtils.GemEquipTableColumnIndex[p]] + ":" + tequip[PropUtils.GemEquipTableColumn[p]];
//							this["g" + (i + 1) + "propArr"][k].textColor=ItemUtil.getColorByQuality(tequip.quality);

							str+=PropUtils.propArr[PropUtils.GemEquipTableColumnIndex[p]] + " +" + tequip[PropUtils.GemEquipTableColumn[p]] + "，";
							k++;
						}
					}

					if (str.charAt(str.length - 1) == "，")
						str=str.substr(0, str.length - 1);

					str+="</font>\n";
				}

			}

			this.ruleLbl.multiline=true;
			this.ruleLbl.htmlText=str;

			var lvstr:String=lv.toString();
			this.curPowerImg.bitmapData=new BitmapData(15 * lvstr.length, 21)
			var tmp:Image;
			var j:int=0;

			for (j=0; j < lvstr.length; j++) {
				tmp=this.numTmpArr[int(lvstr.charAt(j))] as Image;
				this.curPowerImg.bitmapData.copyPixels(tmp.bitmapData, new Rectangle(0, 0, tmp.width, tmp.height), new Point(j * tmp.width, 0));
			}

//			this.curPowerImg.x=203 + (42 - this.curPowerImg.width >> 1);
			this.curPowerImg.x=this.curImg.x + (42 - this.curPowerImg.width >> 1);
//			this.curPowerImg.y=this.curPowerImg.y;
//			this.curPowerImg.y=146;
		}

		private function onMouseItemClick(e:MouseEvent):void {
//			trace(e);

			this.clearGrid();

		}

		public function clearGrid():void {

			if (this.currentEquipIndex != -1)
				this.gArr[this.currentEquipIndex].turnOff();

			this.currentEquipIndex=-1;

			for (var i:int=0; i < this.gemGridVec.length; i++) {

				this.gemGridVec[i].selectIndex=-1
				this.gemGridVec[i].reseGrid();

				this["g" + (i + 1) + "propArr"][0].text="";
				this["g" + (i + 1) + "propArr"][1].text="";
				this["g" + (i + 1) + "propArr"][2].text="";
			}

			this.curImg.fillEmptyBmd();
			this.curPowerImg.fillEmptyBmd();

			this.ruleLbl.text="";
		}

		public function get selectIndex():int {
			return this.currentEquipIndex;
		}

		private function onClick(e:MouseEvent):void {
			UILayoutManager.getInstance().open(WindowEnum.ROLE, WindowEnum.GEM_LV, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);
		}

		public function updateInfo(o:Object):void {

			if (this.rollPower.number != o.zdl) {
				this.rollPower.alignCenter();

				if (otherPlayer) {
					this.rollPower.setNum(o.zdl);
				} else {
					this.rollPower.rollToNum(o.zdl);
				}

				this.rollPower.x=270 - o.zdl.toString().length * 15 >> 1;
			}

			if (!this.otherPlayer) {
				MyInfoManager.getInstance().gemArr=o.glist;

				if (UIManager.getInstance().isCreate(WindowEnum.GEM_LV))
					UIManager.getInstance().gemLvWnd.updateList();

			} else
				MyInfoManager.getInstance().othergemArr=o.glist;

			var glist:Array=o.glist;

			var j:int=0;
			var i:int=0;
			var tEquip:TEquipInfo;
			var lv:int=0;
			var slist:Array=[];
			var tmp:Image;

			for (i=0; i < glist.length; i++) {
				slist=glist[i];
				lv=0;
				for (j=0; j < slist.length; j++) {
					tEquip=TableManager.getInstance().getEquipInfo(slist[j]);
					if (tEquip == null)
						continue;

					lv+=tEquip.level;
				}

				var lvstr:String=lv.toString();
				Image(this.lvArr[i]).bitmapData=new BitmapData(15 * lvstr.length, 21)

				for (j=0; j < lvstr.length; j++) {
					tmp=this.numTmpArr[int(lvstr.charAt(j))] as Image;

					Image(this.lvArr[i]).bitmapData.copyPixels(tmp.bitmapData, new Rectangle(0, 0, tmp.width, tmp.height), new Point(j * tmp.width, 0));
				}

				Image(this.lvArr[i]).x=ImgButton(this.gArr[i]).x + (ImgButton(this.gArr[i]).width - Image(this.lvArr[i]).width >> 1);
				Image(this.lvArr[i]).y=ImgButton(this.gArr[i]).y + 5;

			}


//			if (UIManager.getInstance().roleWnd.getTabIndex() != 2)
//				return;

			if (this.currentEquipIndex == -1) {
				this.currentEquipIndex=0;
				this.updateCurrentList();

				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			} else
				this.updateCurrentList();

		}



	}
}
