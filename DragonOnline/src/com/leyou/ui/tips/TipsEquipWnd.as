package com.leyou.ui.tips {

	import com.ace.ICommon.ITip;
	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TSuit;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.tips.childs.TipsGrid;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class TipsEquipWnd extends AutoSprite implements ITip {

		private var tipsbg:TextArea;
		private var nameLbl:Label;
		private var currentfightLbl:Label;
		private var fullfightLbl:Label;

		private var desc1Lbl:Label;
		private var desc2Lbl:Label;

		private var priceLbl:Label;

		private var proLbl:Label;
		private var lvType:Label;
		private var lvkeyLbl:Label;
		private var partLbl:Label;
		private var partkeyLbl:Label;
		private var strengLv:Label;

		private var nameLbl1:Label;
		private var nameLbl2:Label;
		private var nameLbl4:Label;
		private var nameLbl0:Label;
		private var nameLbl6:Label;
		private var nameLbl5:Label;
		private var nameLbl3:Label;

		private var nameLbl7:Label;
		private var nameLbl8:Label;
		private var nameLbl9:Label;
		private var nameLbl10:Label;

		private var onUseLbl:Label;

		private var suitpropNameArr:Array=[];
		private var suitpropKeyArr:Array=[];

		private var suitTypeArr:Array=[];
		private var suitEffectArr:Array=[];

		private var moneyNameLbl:Label;
		private var moneyIco:Image;
		private var priceSc:ScaleBitmap;
		private var bgSc:ScaleBitmap;

		private var bindImg:Image;
		private var equipImg:Image;

		private var starImg0:Image;
		private var starImg1:Image;
		private var starImg2:Image;
		private var starImg3:Image;
		private var starImg4:Image;
		private var starImg5:Image;
		private var starImg6:Image;
		private var starImg7:Image;
		private var starImg8:Image;
		private var starImg9:Image;
		private var starImg10:Image;
		private var starImg11:Image;
		private var starImg12:Image;
		private var starImg13:Image;
		private var starImg14:Image;
		private var starImg15:Image;

		private var grid:TipsGrid;

		private var dateLbl:Label;
		private var getFunLbl:Label;

		private var tdataLbl:Label;
		private var qhlvLbl:Label;
		private var dtimeLbl:Label;

		private var titleLineImg:Image;
		private var fightlineImg:Image;
		private var desclineImg:Image;
		private var gemlineImg:Image;
		private var standlineImg:Image;
		private var eleBg:Image;
		private var modeSwf:SwfLoader;

		/**
		 * 基础模型
		 */
		private var tipsInfo:TipsInfo;

		private var propsNameArr:Array=[];
		private var propsValueArr:Array=[];
		private var propsRectArr:Array=[];

		private var propsKeyAddArr:Array=[];
		private var propsValAddArr:Array=[];

		private var propsNameAddArr:Array=[];
		private var propsValueAddArr:Array=[];

		private var pointArr:Array=[];

		private var ArrawDownOrUp:Array=[];

		private var gemStarArr:Array=[];
		private var gemNameArr:Array=[];
		private var gemPropsKeyArr:Array=[];
		private var gemPropsValueArr:Array=[];

		private var isfirst:Boolean=false;

		private var labelHeight:Number=16;
		private var lineHeight:Number=5;

		private var priceY:Number=5;

		public function TipsEquipWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsEquipWnd.xml"));
			this.init();
		}

		private function init():void {

			this.tipsbg=this.getUIbyID("tipsbg") as TextArea;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.currentfightLbl=this.getUIbyID("currentfightLbl") as Label;
			this.fullfightLbl=this.getUIbyID("fullfightLbl") as Label;
			this.strengLv=this.getUIbyID("strengLv") as Label;

			this.desc1Lbl=this.getUIbyID("desc1Lbl") as Label;
			this.priceLbl=this.getUIbyID("priceLbl") as Label;

			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.lvType=this.getUIbyID("lvType") as Label;
			this.lvkeyLbl=this.getUIbyID("lvkeyLbl") as Label;
			this.partLbl=this.getUIbyID("partLbl") as Label;
			this.partkeyLbl=this.getUIbyID("partkeyLbl") as Label;
			this.priceSc=this.getUIbyID("priceSc") as ScaleBitmap;
			this.bgSc=this.getUIbyID("bgSc") as ScaleBitmap;

			this.onUseLbl=this.getUIbyID("onUseLbl") as Label;

			this.nameLbl1=this.getUIbyID("nameLbl1") as Label;
			this.nameLbl2=this.getUIbyID("nameLbl2") as Label;
			this.nameLbl4=this.getUIbyID("nameLbl4") as Label;
			this.nameLbl0=this.getUIbyID("nameLbl0") as Label;
			this.nameLbl3=this.getUIbyID("nameLbl3") as Label;
			this.nameLbl6=this.getUIbyID("nameLbl6") as Label;
			this.nameLbl5=this.getUIbyID("nameLbl5") as Label;

			this.nameLbl7=this.getUIbyID("nameLbl7") as Label;
			this.nameLbl8=this.getUIbyID("nameLbl8") as Label;
			this.nameLbl9=this.getUIbyID("nameLbl9") as Label;
			this.nameLbl10=this.getUIbyID("nameLbl10") as Label;

			this.tdataLbl=this.getUIbyID("tdataLbl") as Label;
			this.dateLbl=this.getUIbyID("dateLbl") as Label;
			this.getFunLbl=this.getUIbyID("getFunLbl") as Label;
			this.qhlvLbl=this.getUIbyID("qhlvLbl") as Label;

			this.moneyNameLbl=this.getUIbyID("moneyNameLbl") as Label;
			this.moneyIco=this.getUIbyID("moneyIco") as Image;

			this.bindImg=this.getUIbyID("bindImg") as Image;
			this.equipImg=this.getUIbyID("equipImg") as Image;

			this.titleLineImg=this.getUIbyID("titleLineImg") as Image;
			this.fightlineImg=this.getUIbyID("fightlineImg") as Image;
			this.desclineImg=this.getUIbyID("desclineImg") as Image;
			this.gemlineImg=this.getUIbyID("gemlineImg") as Image;
			this.standlineImg=this.getUIbyID("standlineImg") as Image;

			this.starImg0=this.getUIbyID("starImg0") as Image;
			this.starImg1=this.getUIbyID("starImg1") as Image;
			this.starImg2=this.getUIbyID("starImg2") as Image;
			this.starImg3=this.getUIbyID("starImg3") as Image;
			this.starImg4=this.getUIbyID("starImg4") as Image;
			this.starImg5=this.getUIbyID("starImg5") as Image;
			this.starImg6=this.getUIbyID("starImg6") as Image;
			this.starImg7=this.getUIbyID("starImg7") as Image;
			this.starImg8=this.getUIbyID("starImg8") as Image;
			this.starImg9=this.getUIbyID("starImg9") as Image;
			this.starImg10=this.getUIbyID("starImg10") as Image;
			this.starImg11=this.getUIbyID("starImg11") as Image;
			this.starImg12=this.getUIbyID("starImg12") as Image;
			this.starImg13=this.getUIbyID("starImg13") as Image;
			this.starImg14=this.getUIbyID("starImg14") as Image;
			this.starImg15=this.getUIbyID("starImg15") as Image;

			this.eleBg=this.getUIbyID("eleBg") as Image;

			this.dtimeLbl=new Label();
			this.addChild(this.dtimeLbl);

			this.dtimeLbl.defaultTextFormat=FontEnum.getTextFormat("Red14Center");
			this.dtimeLbl.x=10;

			var pname:Number=24;
			var pvalue:Number=78;
			var padd:Number=141;

			var py:Number=153;
			var py2:Number=253;

			var lb:Label;

			for (var i:int=0; i < 7; i++) {

				//============================================强化================//
				lb=new Label();
				lb.x=pname;
				lb.y=py + this.propsNameArr.length * 20;
				this.addChild(lb);
				this.propsNameArr.push(lb);

				lb=new Label();
				lb.x=pvalue;
				lb.y=py + this.propsValueArr.length * 20;
//				lb.border=true;
//				lb.borderColor=0xff0000;
				this.addChild(lb);

				lb.defaultTextFormat=FontEnum.getTextFormat("White12");
				this.propsValueArr.push(lb);

				lb=new Label();
				lb.x=padd;
				lb.y=py + this.propsRectArr.length * 20;
				this.addChild(lb);

				lb.defaultTextFormat=FontEnum.getTextFormat("White12");
				this.propsRectArr.push(lb);

				//============================================强化================//
				lb=new Label();
				lb.x=pname;
				lb.y=py2 + this.propsKeyAddArr.length * 20;
				this.addChild(lb);
				this.propsKeyAddArr.push(lb);


				lb=new Label();
				lb.x=pvalue + 15;
				lb.y=py2 + this.propsValAddArr.length * 20;
				this.addChild(lb);

				lb.defaultTextFormat=FontEnum.getTextFormat("White12");
				this.propsValAddArr.push(lb);

				//============================================附加================//

				lb=new Label();
				lb.x=pname;
				lb.y=py2 + this.propsNameAddArr.length * 20;
				this.addChild(lb);
				this.propsNameAddArr.push(lb);

				lb=new Label();
				lb.x=pvalue;
				lb.y=py2 + this.propsValueAddArr.length * 20;
				this.addChild(lb);

				lb.defaultTextFormat=FontEnum.getTextFormat("White12");
				this.propsValueAddArr.push(lb);

			}

			var k:int=0;

			for (k=0; k < 8; k++) {

				if (k < 2) {
					lb=new Label();
					lb.x=pname;
//					lb.y=py + this.suitpropNameArr.length * 20;
					this.addChild(lb);
					this.suitpropNameArr.push(lb);

					lb=new Label();
					lb.x=pvalue;
//					lb.y=py + this.suitpropKeyArr.length * 20;

					this.addChild(lb);

					lb.defaultTextFormat=FontEnum.getTextFormat("White12");
					this.suitpropKeyArr.push(lb);
				}

				if (k < 6) {
					lb=new Label();
					lb.x=pname;
					this.addChild(lb);
					lb.width=231;
					lb.wordWrap=true;
					lb.defaultTextFormat=FontEnum.getTextFormat("Green12");
					this.suitEffectArr.push(lb);
				}

				lb=new Label();
				lb.x=pname;
				this.addChild(lb);
				this.suitTypeArr.push(lb);

			}


			for (k=0; k < 13; k++) {
				this.ArrawDownOrUp[k]=new Image("ui/common/icon_down.png");
				this.ArrawDownOrUp[k].x=pvalue + 45;
				this.ArrawDownOrUp[k].visible=false;
				this.ArrawDownOrUp[k].height=14;
				this.addChild(this.ArrawDownOrUp[k]);

			}

			var star:Image;
			var keyArr:Array=[];
			var valueArr:Array=[];

			for (var g:int=0; g < 3; g++) {
				star=new Image("ui/tips/icon_xx.png");
				this.addChild(star);
				star.x=10;
				star.y=522 + g * 20;

				this.gemStarArr.push(star);

				lb=new Label();
				lb.x=26;
				lb.y=521 + g * 20;
				this.addChild(lb);

				this.gemNameArr.push(lb);

				keyArr=[];
				valueArr=[];

				for (var p:int=0; p < 2; p++) {

					lb=new Label();
					lb.x=104 + p * 78;
					lb.y=521 + g * 20;

					this.addChild(lb);

					keyArr.push(lb);

					lb=new Label();
					lb.x=132 + p * 78;
					lb.y=521 + g * 20;
					this.addChild(lb);

					lb.defaultTextFormat=FontEnum.getTextFormat("Green12");

					valueArr.push(lb);
				}

				this.gemPropsKeyArr.push(keyArr);
				this.gemPropsValueArr.push(valueArr);
			}

			this.grid=new TipsGrid();
			this.addChild(this.grid);

			this.grid.x=11;
			this.grid.y=29;

			this.addChild(this.bindImg);

			this.modeSwf=new SwfLoader();
			this.addChild(this.modeSwf);

//			this.modeSwf.y

		}

		private function setArrawDown(v:Boolean):void {

			for (var k:int=0; k < 13; k++) {
				this.ArrawDownOrUp[k].visible=v;
			}

		}


		/**
		 * @param num
		 */
		public function updateStarLv(num:int, total:int):void {

			for (var i:int=0; i < 16; i++) {
				if (i < num) {
					this["starImg" + i].updateBmp("ui/tips/icon_xx.png");
					this["starImg" + i].filters=[];
				} else if (i < total)
					this["starImg" + i].filters=[FilterUtil.enablefilter];
				else
					this["starImg" + i].visible=false;
			}

		}

		public function showPane(tips:TipsInfo):void {
			this.tipsInfo=tips;
//			this.updateInfo();
		}

		public function updatePs(p:Point):void {
			this.x=p.x;
			this.y=p.y;
		}

		/**
		 * equip title
		 * @param info
		 *
		 */
		private function updateEquipTitleInfo(info:TEquipInfo):void {
			if (info == null)
				return;

//			this.bindImg.visible=false;
			this.grid.updataInfo(info);

			this.nameLbl.text=info.name.toString();
			this.nameLbl.textColor=ItemUtil.getColorByQuality(int(info.quality));

			this.proLbl.text=PlayerUtil.getPlayerRaceByIdx(int(info.limit));
			this.lvType.text=info.level + "";
			this.partLbl.text=PlayerUtil.AvatarPartStrArr[int(info.position) - 1];

			this.strengLv.x=this.nameLbl.x + this.nameLbl.width + 5;

			if (this.tipsInfo.qh != 0) {
				this.strengLv.text="+" + this.tipsInfo.qh;
				this.onUseLbl.x=this.strengLv.x + this.strengLv.textWidth;
			} else {
				this.strengLv.text="";
				this.onUseLbl.x=this.nameLbl.x + this.nameLbl.textWidth;
			}

			this.equipImg.visible=false;
			this.bindImg.visible=false;
			this.onUseLbl.visible=false;

			if (this.tipsInfo.elea > 0) {

				this.eleBg.visible=true;

				switch (this.tipsInfo.ele) {
					case 1:
						this.eleBg.updateBmp("ui/tips/bg_fire.png");
						break;
					case 2:
						this.eleBg.updateBmp("ui/tips/bg_water.png");
						break;
					case 3:
						this.eleBg.updateBmp("ui/tips/bg_wood.png");
						break;
					case 4:
						this.eleBg.updateBmp("ui/tips/bg_light.png");
						break;
					case 5:
						this.eleBg.updateBmp("ui/tips/bg_shadow.png");
						break;
				}
			} else {
				this.eleBg.visible=false;
			}


			if (this.tipsInfo.isUse) {
//				this.equipImg.visible=PlayerUtil.getEquipToBody(info);
				this.onUseLbl.visible=true;
			}

			if (int(info.bind) == 1) {
				this.bindImg.visible=true;
			} else {
				this.bindImg.visible=false;
			}

//			if (info.subclassid > 12)
//				this.lvkeyLbl.text=PropUtils.getStringById(1931);
//			else
			this.lvkeyLbl.text=PropUtils.getStringById(1938);

			this.partkeyLbl.text=PropUtils.getStringById(1932);
		}

		/**
		 * 物品title
		 * @param info
		 */
		private function updateItemTitleInfo(info:TItemInfo):void {
			if (info == null)
				return;

			this.equipImg.visible=false;
			this.onUseLbl.visible=false;
			this.eleBg.visible=false;

			this.strengLv.text="";
			this.grid.updataInfo(info);

			this.nameLbl.text=info.name.toString();
			this.nameLbl.textColor=ItemUtil.getColorByQuality(int(info.quality));

			this.proLbl.text=PlayerUtil.getPlayerRaceByIdx(int(info.limit));
			this.lvType.text=info.level + "";
			this.partLbl.text=info.maxgroup + "";
			this.partkeyLbl.text=PropUtils.getStringById(1933);

			if (int(info.bind) == 1) {
				this.bindImg.visible=true;
			} else {
				this.bindImg.visible=false;
			}

		}


		public function updateInfo(tips:Object):void {

			var info:Object;

			if (tips is int) {

				info=TableManager.getInstance().getItemInfo(tips as int);
				this.updateItemInfo(info as TItemInfo);

			} else {

				this.tipsInfo=tips as TipsInfo;
				this.grid.tips=this.tipsInfo;
				info=TableManager.getInstance().getItemInfo(tips.itemid);

				if (info == null) {
					info=TableManager.getInstance().getEquipInfo(tips.itemid);
					if (info == null) {
						return;
					}

					this.updateEquipInfo(info as TEquipInfo);
				} else {
					this.updateItemInfo(info as TItemInfo);
				}

			}

			this.scrollRect=new Rectangle(0, 0, this.width, this.height);
		}

		/**
		 *
		 */
		private function updateEquipInfo(tinfo:TEquipInfo):void {

			this.updateEquipTitleInfo(tinfo);

			this.tdataLbl.visible=false;
			this.dateLbl.visible=false;

			this.titleLineImg.y=97;

			this.setStarState(true);
			this.clearData();

			this.updateStarLv(this.tipsInfo.qh, int(tinfo.maxlevel));

			if (int(tinfo.maxlevel) <= 8)
				this.nameLbl0.y=115;
			else
				this.nameLbl0.y=133;

			this.nameLbl0.visible=true;
			this.nameLbl1.visible=true;
			this.nameLbl2.visible=true;
			this.nameLbl3.visible=true;
			this.nameLbl4.visible=true;
			this.nameLbl6.visible=true;

			this.nameLbl7.visible=true;
			this.nameLbl8.visible=true;
			this.nameLbl9.visible=true;
			this.nameLbl10.visible=true;

			this.currentfightLbl.visible=true;
			this.fullfightLbl.visible=true;
			this.qhlvLbl.visible=true;
			this.fightlineImg.visible=true;
			this.standlineImg.visible=true;
			this.desclineImg.visible=true;

			this.desc1Lbl.width=245;
			this.getFunLbl.width=245;
			this.desc1Lbl.wordWrap=true;
			this.getFunLbl.wordWrap=true;
			this.modeSwf.visible=false;

			this.updateEquipProps(tinfo);

			this.updateDesc(tinfo.des, tinfo.desSource, this.desclineImg.y);

			if (tinfo.limitTime != 0) {
				this.dtimeLbl.visible=true;
				this.dtimeLbl.y=this.getFunLbl.y + this.getFunLbl.height + 5;

				var d:Date=new Date();
				d.time=this.tipsInfo.dtime * 1000;
				this.dtimeLbl.text=PropUtils.getStringById(1939) + ":" + TimeUtil.getDateToString(d);
			} else {
				this.dtimeLbl.visible=false;
				this.dtimeLbl.y=this.getFunLbl.y + this.getFunLbl.height - this.dtimeLbl.height;
			}

			this.priceY=this.dtimeLbl.y + this.dtimeLbl.height + 10;

			var num:int=int(this.tipsInfo.moneyNum);
			if (num == 0) {
				num=int(tinfo.price);
			}

			this.updatePrice(num, this.tipsInfo.moneyType);

			if (tinfo.Suit_Group > 0) {
				this.priceSc.visible=false;
			} else {
				this.priceSc.visible=this.tipsInfo.isShowPrice;
			}

			this.bgSc.height=this.priceSc.y;
		}

		private function updateEquipProps(info:TEquipInfo):void {

			if (info == null)
				return;

			var key:String;
			var _x:int=0;
			var _a:int=0;
			var i:int=0;

			this.clearData();

			var st:Boolean=false;
			var roleIndex:int;

			if (this.tipsInfo.isdiff) {

				var einfo:Object={};
				if (info.subclassid > 12) {
					einfo=MyInfoManager.getInstance().mountEquipArr[info.subclassid - 13];
				} else {
					var olist:Array=ItemEnum.ItemToRolePos[info.subclassid];
					einfo=MyInfoManager.getInstance().equips[olist[0]];

					if (einfo != null) {

						if (olist.length == 2) {
							var einfo1:EquipInfo=MyInfoManager.getInstance().equips[olist[1]];
							if (einfo1 != null) {
								if (einfo.tips.zdl > einfo1.tips.zdl) {
									einfo=einfo1;
								}
							}
						}

					} else {
						if (olist.length == 2)
							einfo=MyInfoManager.getInstance().equips[olist[1]];
					}
				}
			}

			if (this.tipsInfo.p != null) {
				for (i=0; i < 7; i++) {
					if (this.tipsInfo.p[i + 1] && i != 2) {

						this.propsNameArr[_x].text=PropUtils.propArr[int(i)] + ":";
						this.propsValueArr[_x].text=this.tipsInfo.p[(i + 1)] + "";
						this.propsRectArr[_x].text="(" + info[PropUtils.getEquipColumnByIndex(i)[0]] + " ~ " + info[PropUtils.getEquipColumnByIndex(i)[1]] + ")";

						this.ArrawDownOrUp[_a].y=this.propsNameArr[_x].y=this.propsValueArr[_x].y=this.propsRectArr[_x].y=this.nameLbl0.y + this.labelHeight + this.labelHeight * _x;

						if (this.tipsInfo.isdiff) {
							if (this.tipsInfo.p[(i + 1)] < einfo.tips.p[(i + 1)])
								this.setDownOrUpVisible(_a, 0);
							else if (this.tipsInfo.p[(i + 1)] > einfo.tips.p[(i + 1)])
								this.setDownOrUpVisible(_a, 1);
						}

						_a++;
						_x++;
					}
				}
			}

			this.nameLbl3.y=this.qhlvLbl.y=this.nameLbl0.y + this.labelHeight + this.labelHeight * _x;
			this.qhlvLbl.text="(" + this.tipsInfo.qh + "/" + info.maxlevel + ")";

			var qh:int=0;
			if (this.tipsInfo.p != null) {
				for (i=0; i < 7; i++) {

					if (this.tipsInfo.p.hasOwnProperty("qh_" + (i + 1))) {
						this.propsKeyAddArr[qh].text=PropUtils.getStringById(1696) + PropUtils.propArr[int(i)] + ":";
						this.propsValAddArr[qh].text=this.tipsInfo.p["qh_" + (i + 1)] + "";

						this.ArrawDownOrUp[_a].y=this.propsKeyAddArr[qh].y=this.propsValAddArr[qh].y=this.nameLbl3.y + this.labelHeight + this.labelHeight * qh;

						if (this.tipsInfo.isdiff) {
							if (this.tipsInfo.p["qh_" + (i + 1)] < einfo.tips.p["qh_" + (i + 1)])
								this.setDownOrUpVisible(_a, 0);
							else if (this.tipsInfo.p["qh_" + (i + 1)] > einfo.tips.p["qh_" + (i + 1)])
								this.setDownOrUpVisible(_a, 1);
						}

						_a++;
						qh++;
					}
				}
			}

			if (qh == 0) {
				this.qhlvLbl.visible=false;
				this.nameLbl3.visible=false;
				this.nameLbl1.y=this.nameLbl3.y;
			} else {
				this.qhlvLbl.visible=true;
				this.nameLbl3.visible=true;
				this.nameLbl1.y=this.nameLbl3.y + this.labelHeight + this.labelHeight * qh;
			}

			//附加
			var _y:int=0;
			if (this.tipsInfo.p != null) {
				for (i=7; i < PropUtils.propArr.length; i++) {

					if (this.tipsInfo.p[i + 1]) {
						this.propsNameAddArr[_y].text=PropUtils.propArr[int(i)] + ":";
						this.propsValueAddArr[_y].text="" + this.tipsInfo.p[(i + 1)];

						if (_y % 2 != 0) {
//							this.ArrawDownOrUp[_a].y=this.propsNameAddArr[_y].y=this.propsValueAddArr[_y].y
							this.ArrawDownOrUp[_a].x=240;
							this.propsNameAddArr[_y].x=141;
							this.propsValueAddArr[_y].x=195;
						}

						this.ArrawDownOrUp[_a].y=this.propsNameAddArr[_y].y=this.propsValueAddArr[_y].y=this.nameLbl1.y + this.labelHeight + Math.floor(_y / 2) * this.labelHeight;

						if (this.tipsInfo.isdiff) {
							if (this.tipsInfo.p[(i + 1)] < einfo.tips.p[(i + 1)])
								this.setDownOrUpVisible(_a, 0);
							else if (this.tipsInfo.p[(i + 1)] > einfo.tips.p[(i + 1)])
								this.setDownOrUpVisible(_a, 1);
						}

						_y++;
						_a++;
					}

				}
			}

			//精力
			i=2;
			if (this.tipsInfo.p != null && this.tipsInfo.p[i + 1]) {
				this.propsNameAddArr[_y].text=PropUtils.propArr[int(i)] + ":";
				this.propsValueAddArr[_y].text="" + this.tipsInfo.p[(i + 1)];

				if (_y % 2 != 0) {
//					this.ArrawDownOrUp[_a].y=this.propsNameAddArr[_y].y=this.propsValueAddArr[_y].y
//					this.ArrawDownOrUp[_a].x=240;
					this.propsNameAddArr[_y].x=141;
					this.propsValueAddArr[_y].x=195;
				}

				this.propsNameAddArr[_y].y=this.propsValueAddArr[_y].y=this.nameLbl1.y + this.labelHeight + Math.floor(_y / 2) * this.labelHeight;
				_y++;
			}


			if (_y == 0) {
				this.nameLbl1.visible=false;
				this.nameLbl7.y=this.nameLbl1.y;
			} else {
				this.nameLbl1.visible=true;
				this.nameLbl7.y=this.nameLbl1.y + this.labelHeight + this.labelHeight * (_y % 2 == 0 ? Math.floor(_y / 2) : Math.floor(_y / 2) + 1);
			}


			//元素
			_y=0;
//			if (info.fixed_attack > 0) {
//				this.suitpropNameArr[0].text="" + PropUtils.propArr[40] + ":";
//				this.suitpropKeyArr[0].text="" + info.fixed_attack;
//				
//				this.ArrawDownOrUp[13].y=this.suitpropNameArr[0].y=this.suitpropKeyArr[0].y=this.nameLbl7.y + this.labelHeight;
//				_y++;
//			}
//
//			if (info.fixed_defense > 0) {
//				this.suitpropNameArr[1].text="" + PropUtils.propArr[41] + ":";
//				this.suitpropKeyArr[1].text="" + info.fixed_defense;
//
//				this.suitpropNameArr[1].y=this.suitpropKeyArr[1].y=this.nameLbl7.y + this.labelHeight + this.labelHeight * _y;
//				_y++;
//			}

			if (this.tipsInfo.elea > 0) {
				this.suitpropNameArr[0].text="" + PropUtils.propArr[ItemUtil.getElementToEleId(this.tipsInfo.ele) - 1] + ":";
				this.suitpropKeyArr[0].text="" + this.tipsInfo.elea;

				if (UIManager.getInstance().roleWnd.getCurrentEle() == this.tipsInfo.ele) {
					this.suitpropNameArr[1].defaultTextFormat=FontEnum.getTextFormat("Green12");
					this.suitpropNameArr[1].text="" + PropUtils.getStringById(1948);

					if (this.tipsInfo.isdiff) {
						if (this.tipsInfo.elea > UIManager.getInstance().roleWnd.getCurrentEleValue())
							this.setDownOrUpVisible(12, 0);
						else
							this.setDownOrUpVisible(12, 1);
					}

				} else {

					this.suitpropNameArr[1].defaultTextFormat=FontEnum.getTextFormat("Red12");
					this.suitpropNameArr[1].text="" + PropUtils.getStringById(2291);

					this.ArrawDownOrUp[12].visible=false;
				}

				this.ArrawDownOrUp[12].y=this.suitpropNameArr[0].y=this.suitpropKeyArr[0].y=this.suitpropNameArr[1].y=this.nameLbl7.y + this.labelHeight;

				this.suitpropNameArr[1].x=this.propsRectArr[0].x;
				_y++;
			}


			if (_y == 0) {
				this.nameLbl7.visible=false;
				this.standlineImg.y=this.nameLbl7.y + this.lineHeight;
			} else {
				this.nameLbl7.visible=true;
				this.standlineImg.y=this.nameLbl7.y + this.labelHeight + this.labelHeight * _y + this.lineHeight;
			}

			this.nameLbl8.y=this.standlineImg.y + this.lineHeight;
			this.nameLbl9.y=this.standlineImg.y + this.lineHeight;

			_y=0;

			//套装
			var tEquip:TEquipInfo;
			var u:int=0;
			var len:int=0;
			if (info.Suit_Group > 0) {
				var suitArr:Array=TableManager.getInstance().getEquipListArrBySuitGroup(info.Suit_Group);
				len=suitArr.length;

				if (suitArr != null) {

					for each (tEquip in suitArr) {
						this.suitTypeArr[_y].text="" + tEquip.name;

						if (PlayerUtil.getEquipToBody(tEquip, true)) {
							this.suitTypeArr[_y].textColor=ItemUtil.getColorByQuality(tEquip.quality);
							u++;
						} else {
							this.suitTypeArr[_y].textColor=0xcccccc;
						}

						if (_y % 2 != 0) {
							this.suitTypeArr[_y].x=141;
						}

						this.suitTypeArr[_y].y=this.nameLbl8.y + this.labelHeight + this.labelHeight * Math.floor(_y / 2);
						_y++;

						if ([2, 3, 11].indexOf(tEquip.subclassid) > -1) {

							this.suitTypeArr[_y].text="" + tEquip.name;

							if (PlayerUtil.getEquipToBody2(tEquip, true)) {
								this.suitTypeArr[_y].textColor=ItemUtil.getColorByQuality(tEquip.quality);
								u++;
							} else {
								this.suitTypeArr[_y].textColor=0xcccccc;
							}

							if (_y % 2 != 0) {
								this.suitTypeArr[_y].x=141;
							}

							this.suitTypeArr[_y].y=this.nameLbl8.y + this.labelHeight + this.labelHeight * Math.floor(_y / 2);
							_y++;

							len++;
						}

					}

					this.nameLbl9.text="(" + u + "/" + len + ")";
				}
			}



			if (_y == 0) {
				this.nameLbl8.visible=false;
				this.nameLbl9.visible=false;
				this.nameLbl10.y=this.nameLbl8.y;
			} else {
				this.nameLbl8.visible=true;
				this.nameLbl9.visible=true;
				this.nameLbl10.y=this.nameLbl8.y + this.labelHeight + this.labelHeight * Math.ceil(_y / 2);
			}

			_y=0;
			if (info.Suit_Group > 0) {
				var tsuit:TSuit;
				suitArr.length=0;
				suitArr=TableManager.getInstance().getSuitByGroup(info.Suit_Group);

				var _yy:int=0;
				if (suitArr != null) {

					for each (tsuit in suitArr) {
						if (tsuit.SA_Num > 0)
							this.suitEffectArr[_yy].htmlText=tsuit.Suit_Num + PropUtils.getStringById(1936) + "：" + PropUtils.propArr[tsuit.Suit_Att - 1] + " +" + tsuit.SA_Num;
						else
							this.suitEffectArr[_yy].htmlText=tsuit.Suit_Num + PropUtils.getStringById(1936) + "： " + tsuit.SA_txt;

						this.suitEffectArr[_yy].y=this.nameLbl10.y + this.labelHeight + this.labelHeight * _yy;

						if (u < tsuit.Suit_Num)
							this.suitEffectArr[_yy].textColor=0xcccccc;
						else
							this.suitEffectArr[_yy].textColor=0x00ff00;

						_y+=this.suitEffectArr[_yy].height - 5;
						_yy++;

					}

				}
			}



			if (_y == 0) {
				this.nameLbl10.visible=false;

				if (this.nameLbl8.visible)
					this.gemlineImg.y=this.nameLbl10.y + this.lineHeight;
				else {
					this.standlineImg.visible=false;
					this.gemlineImg.y=this.standlineImg.y;
				}

			} else {
				this.nameLbl10.visible=true;
				this.gemlineImg.y=this.nameLbl10.y + this.labelHeight + _y + this.lineHeight;
			}


			this.nameLbl5.y=this.gemlineImg.y + this.lineHeight;

			var j:int=0;
			i=0;

			var lv:int=0;
			var slist:Array=[];
			var tmp:Image;
			var k:int=0;

			//			for (i=0; i < glist.length; i++) {
			if (!this.tipsInfo.otherPlayer)
				slist=MyInfoManager.getInstance().gemArr[this.tipsInfo.playPosition];
			else
				slist=MyInfoManager.getInstance().othergemArr[this.tipsInfo.playPosition];


			if (slist != null) {

				for (j=0; j < slist.length; j++) {
					tEquip=TableManager.getInstance().getEquipInfo(slist[j]);

					this.gemStarArr[j].visible=true;

					this.gemNameArr[j].y=this.nameLbl5.y + this.labelHeight + j * this.labelHeight;
					this.gemStarArr[j].y=this.gemNameArr[j].y + 1;

					if (tEquip == null) {

						this.gemStarArr[j].updateBmp("ui/tips/icon_xxx.png");

						this.gemNameArr[j].text=PropUtils.getStringById(1940);
						this.gemNameArr[j].textColor=0xff0000
						this.gemNameArr[j].filters=[FilterUtil.enablefilter];

						for (k=0; k < 2; k++) {
							this.gemPropsKeyArr[j][k].text="";
							this.gemPropsValueArr[j][k].text="";

							this.gemPropsKeyArr[j][k].filters=[FilterUtil.enablefilter];
							this.gemPropsValueArr[j][k].filters=[FilterUtil.enablefilter];

							this.gemPropsKeyArr[j][k].y=this.gemPropsValueArr[j][k].y=this.gemNameArr[j].y;
						}

					} else {

						this.gemStarArr[j].updateBmp("ui/tips/icon_xx.png");

						this.gemNameArr[j].text="" + tEquip.name;
						this.gemNameArr[j].textColor=ItemUtil.getColorByQuality(tEquip.quality);
						this.gemNameArr[j].filters=[];

						k=0;
						for (var p:int=0; p < PropUtils.GemEquipTableColumn.length; p++) {
							if (int(tEquip[PropUtils.GemEquipTableColumn[p]]) != 0) {
								this.gemPropsKeyArr[j][k].text="" + PropUtils.propArr[PropUtils.GemEquipTableColumnIndex[p]] + "";
								this.gemPropsValueArr[j][k].text="+" + tEquip[PropUtils.GemEquipTableColumn[p]];

								this.gemPropsKeyArr[j][k].filters=[];
								this.gemPropsValueArr[j][k].filters=[];

								this.gemPropsKeyArr[j][k].y=this.gemPropsValueArr[j][k].y=this.gemNameArr[j].y;

								k++;
							}
						}

					}
				}
			}


			if (slist == null) {
				this.nameLbl5.visible=false;
				this.gemlineImg.visible=false;
				this.fightlineImg.y=this.gemlineImg.y;
			} else {
				this.nameLbl5.visible=true;
				this.gemlineImg.visible=true;
				this.fightlineImg.y=this.nameLbl5.y + this.labelHeight + this.labelHeight * j + this.lineHeight;
			}

			this.currentfightLbl.text="" + this.tipsInfo.zdl;
			this.fullfightLbl.text="" + this.tipsInfo.mzdl;

			if (this.tipsInfo.zdl == this.tipsInfo.mzdl) {
				this.fullfightLbl.setTextFormat(FontEnum.getTextFormat("Yellow16"));
				this.nameLbl4.setTextFormat(FontEnum.getTextFormat("Yellow12"));
			} else {
				this.fullfightLbl.setTextFormat(FontEnum.getTextFormat("grey16"));
				this.nameLbl4.setTextFormat(FontEnum.getTextFormat("grey12"));
			}

			this.currentfightLbl.y=this.fightlineImg.y + this.lineHeight - 4;
			this.fullfightLbl.y=this.currentfightLbl.y + this.labelHeight;

			this.nameLbl2.y=this.currentfightLbl.y + 4
			this.nameLbl4.y=this.fullfightLbl.y + 4
			this.desclineImg.y=this.fullfightLbl.y + this.labelHeight + this.lineHeight * 2;
		}

		/**
		 *
		 */
		private function updateItemInfo(tinfo:TItemInfo):void {

			this.updateItemTitleInfo(tinfo);

			if (this.tipsInfo != null && this.tipsInfo.t > 0) {
				this.tdataLbl.visible=true;
				this.dateLbl.visible=true;

				this.dateLbl.text=TimeUtil.getIntToDateTime(this.tipsInfo.t);

				this.titleLineImg.y=this.dateLbl.y + this.dateLbl.height + 5;
			} else {
				this.tdataLbl.visible=false;
				this.dateLbl.visible=false;

				this.titleLineImg.y=97;
			}

			this.desc1Lbl.width=245;
			this.getFunLbl.width=245;
			this.desc1Lbl.wordWrap=true;
			this.getFunLbl.wordWrap=true;

			this.updateDesc(tinfo.des, tinfo.desSource, this.titleLineImg.y);

			if (tinfo.limitTime != 0) {
				this.dtimeLbl.visible=true;
				this.dtimeLbl.y=this.getFunLbl.y + this.getFunLbl.height + 5;

				var d:Date=new Date();
				d.time=this.tipsInfo.dtime * 1000;
				this.dtimeLbl.text=PropUtils.getStringById(1939) + ":" + TimeUtil.getDateToString(d);
			} else {
				this.dtimeLbl.visible=false;
				this.dtimeLbl.y=this.getFunLbl.y + this.getFunLbl.height - this.dtimeLbl.height;
			}

			this.priceY=this.dtimeLbl.y + this.dtimeLbl.height + 10;

			this.modeSwf.visible=false;
			if (tinfo.pnfId != "") {
				this.modeSwf.visible=true;

				var pstr:String;
				var pid:int;
				var h:int;
				if (tinfo.pnfId.indexOf("|") > -1) {

//					this.priceY+=150;


					pstr=tinfo.pnfId.split(",")[1];
					pid=pstr.split("|")[Core.me.info.profession - 1];
					h=tinfo.pnfId.split(",")[0];

					this.priceY+=h;

					this.modeSwf.y=this.priceY; // + h;

				} else {

//					this.priceY+=100;

					pid=tinfo.pnfId.split(",")[1];
					h=tinfo.pnfId.split(",")[0];
//					this.modeSwf.y=this.priceY - 50;

					this.priceY+=h;

					this.modeSwf.y=this.priceY; // + h;
				}

				this.modeSwf.update(pid);
				this.modeSwf.playAct(PlayerEnum.ACT_STAND, 4);

				this.modeSwf.x=120;
				
				priceY+=20;
			}

			var num:int;
			if (this.tipsInfo == null || int(this.tipsInfo.moneyNum) == 0) {
				num=int(tinfo.price);
				this.updatePrice(num);
			} else {
				num=int(this.tipsInfo.moneyNum);
				this.updatePrice(num, this.tipsInfo.moneyType);
			}


			this.bgSc.height=priceY;

			this.setStarState(false);
			this.clearData();

			this.nameLbl0.visible=false;
			this.nameLbl1.visible=false;
			this.nameLbl2.visible=false;
			this.nameLbl3.visible=false;
			this.nameLbl4.visible=false;
			this.nameLbl5.visible=false;
			this.nameLbl6.visible=false;
			this.nameLbl7.visible=false;
			this.nameLbl8.visible=false;
			this.nameLbl9.visible=false;
			this.gemlineImg.visible=false;
			this.standlineImg.visible=false;
			this.currentfightLbl.visible=false;
			this.fullfightLbl.visible=false;
			this.qhlvLbl.visible=false;
			this.fightlineImg.visible=false;
			this.desclineImg.visible=false;

			this.priceSc.visible=this.tipsInfo.isShowPrice;

		}

		private function updateDesc(d:String, ds:String, pos:Number):void {

//			var str:String="";
//			var _i:int=0;
//			if (d.length > 20) {
//				while (_i < d.length) {
//					if (_i != 0 && _i % 20 == 0)
//						str+="\n";
//
//					str+=d.charAt(_i);
//					_i++;
//				}
//			} else {
//				str=d;
//			}

			this.desc1Lbl.htmlText="" + d;

//			str="";
//			_i=0;
//
//			if (ds.length > 20) {
//				while (_i < ds.length) {
//					if (_i != 0 && _i % 20 == 0)
//						str+="\n";
//
//					str+=ds.charAt(_i);
//					_i++;
//				}
//			} else {
//				str=ds;
//			}

			this.getFunLbl.htmlText="" + ds;

			this.desc1Lbl.y=pos + this.lineHeight;
			this.getFunLbl.y=this.desc1Lbl.y + this.desc1Lbl.height;
		}

		/**
		 * @param price
		 * @param mtype
		 * @param ishsop
		 */
		private function updatePrice(price:int, mtype:int=0, isshop:int=0):void {

			this.moneyIco.updateBmp(ItemUtil.getExchangeIcon(mtype));
			this.priceLbl.text="" + price;

			if (isshop == 1) {
				this.moneyNameLbl.text=PropUtils.getStringById(1919) + ":";
			} else {
				this.moneyNameLbl.text=PropUtils.getStringById(1937) + ":";
			}

			this.priceSc.y=this.priceY;
			this.moneyNameLbl.y=this.priceSc.y + 4;
			this.priceLbl.y=this.priceSc.y + 7;
			this.moneyIco.y=this.priceSc.y + 7;
		}

		private function setStarState(v:Boolean):void {
			for (var i:int=0; i < 16; i++) {
				this["starImg" + i].visible=v;
			}
		}

		private function setDownOrUpVisible(i:int, s:int=0):void {
			this.ArrawDownOrUp[i].visible=true;

			if (s == 0) {
				this.ArrawDownOrUp[i].updateBmp("ui/common/icon_down.png");
			} else {
				this.ArrawDownOrUp[i].updateBmp("ui/common/icon_up.png");
			}
		}

		private function clearData():void {

			for (var i:int=0; i < 8; i++) {
				if (i < 6) {
					this.propsNameArr[i].text="";
					this.propsValueArr[i].text="";
					this.propsRectArr[i].text="";

					this.propsKeyAddArr[i].text="";
					this.propsValAddArr[i].text="";

					this.propsNameAddArr[i].text=""
					this.propsValueAddArr[i].text=""

					this.suitEffectArr[i].text="";
				}

				if (i < 3) {

					this.gemNameArr[i].text="";
					this.gemStarArr[i].visible=false;

					this.gemPropsKeyArr[i][0].text="";
					this.gemPropsKeyArr[i][1].text="";
					this.gemPropsValueArr[i][0].text="";
					this.gemPropsValueArr[i][1].text="";

					this.suitEffectArr[i].text="";
				}

				if (i < 2) {
					this.suitpropKeyArr[i].text="";
					this.suitpropNameArr[i].text="";
				}

				this.suitTypeArr[i].filters=[];
				this.suitTypeArr[i].text="";

			}


			this.setArrawDown(false);
		}

		public function get isFirst():Boolean {
			return this.tipsInfo.isUse;
		}

//		override public function get height():Number {
//			return this.bgSc.height + this.priceSc.height;
//		}

		override public function get width():Number {
			return 265;
		}

		override public function get height():Number {
			if (this.priceSc.visible)
				return this.bgSc.height + this.priceSc.height;
			else
				return this.bgSc.height;
		}
	}
}
