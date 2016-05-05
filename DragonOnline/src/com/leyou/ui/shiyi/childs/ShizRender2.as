package com.leyou.ui.shiyi.childs {

	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.manager.VersionManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.flv.FlvStreamPayer;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Syj;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;

	public class ShizRender2 extends AutoSprite {

		private var lastTimeLbl:Label;

		private var fightLbl:Label;
		private var descLbl:Label;
		private var buyBtn:NormalButton;

		private var rollNum:RollNumWidget;
		private var effSwf:SwfLoader;
		private var weaponSwf:SwfLoader;
		private var priceImg:Image;
		private var noticeLbl:Label;

		private var pTxtArr:Array=[];
		private var pLblArr:Array=[];

		private var itemArr:Array=[];

		private var selectIndex:int=0;

		private var bigAvater:BigAvatar;

		private var currentTabInfo:Object;

		private var videoPlay:FlvStreamPayer;

		private var swfloader:Loader;

		private var dis:DisplayObject;

		public function ShizRender2() {
			super(LibManager.getInstance().getXML("config/ui/shiyi/shizRender2.xml"));
			this.init();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
		}

		private function init():void {

			this.lastTimeLbl=this.getUIbyID("lastTimeLbl") as Label;

			this.fightLbl=this.getUIbyID("fightLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.buyBtn=this.getUIbyID("buyBtn") as NormalButton;

			var i:int=0;
			for (i=0; i < 3; i++) {
				this.pTxtArr.push(this.getUIbyID("p" + (i + 1) + "Txt") as Label);
				this.pLblArr.push(this.getUIbyID("p" + (i + 1) + "Lbl") as Label);
			}

			this.rollNum=new RollNumWidget();
			this.addChild(this.rollNum);
			this.rollNum.loadSource("ui/num/{num}_zdl.png");

			this.rollNum.x=142;
			this.rollNum.y=404;

			this.rollNum.alignCenter();

			this.effSwf=new SwfLoader();
			this.addChild(this.effSwf);

			this.effSwf.x=469;
			this.effSwf.y=270;

			this.weaponSwf=new SwfLoader();
			this.addChild(this.weaponSwf);

			this.weaponSwf.x=469;
			this.weaponSwf.y=270;

			this.priceImg=new Image();
			this.addChild(this.priceImg);

			this.priceImg.x=379;
			this.priceImg.y=100;

			this.bigAvater=new BigAvatar();
			this.addChild(this.bigAvater);

			this.descLbl.wordWrap=true;
			this.descLbl.multiline=true;

			this.descLbl.width=232;
			this.descLbl.height=102;

//			this.videoPlay=new FlvStreamPayer();

//			this.videoPlay.setVideoWidth(

//			this.videoPlay.x=40;
//			this.videoPlay.y=100;

			this.swfloader=new Loader();
			this.swfloader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);


			this.buyBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.descLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.descLbl.mouseEnabled=true;

		}

		private function onClick(e:MouseEvent):void {
			if (this.selectIndex > 0)
				Cmd_Syj.cmBuy(this.selectIndex);
		}

		private function onMouseMove(e:MouseEvent):void {

			var lb:Label=Label(e.target);
			var i:int=lb.getCharIndexAtPoint(e.localX, e.localY);
			var xmltxt:XML=XML(lb.getXMLText(i, i + 1));

			var url:String=xmltxt.textformat.@url;

			if (url != null && url != "") {
				var tips:TipsInfo=new TipsInfo();
				tips.itemid=url.split("--")[1];
				tips.isShowPrice=true;

				ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(e.stageX, e.stageY));
			}
		}

		public function updateInfo(o:Object):void {

			this.selectIndex=o.sinfo[0];



			if (o.sinfo[2] > 0) {
				var d:Date=new Date();
				d.time=o.sinfo[2] * 1000;
				this.lastTimeLbl.text="" + TimeUtil.getDateToString2(d);
			} else {
				this.lastTimeLbl.visible=(o.sinfo[1] != 0)
				this.lastTimeLbl.text="" + PropUtils.getStringById(2368);
			}

			var tinfo:TTitle=TableManager.getInstance().getTitleByID(o.sinfo[0]);
			var power:int=0;

			for (var i:int=0; i < this.pTxtArr.length; i++) {

				if (int(tinfo["attribute" + (i + 1)]) > 0) {

					this.pTxtArr[i].text="" + PropUtils.getStringEasyById(int(tinfo["attribute" + (i + 1)])) + ":";
					this.pLblArr[i].text="" + tinfo["value" + (i + 1)];

					power+=TableManager.getInstance().getZdlElement(int(tinfo["attribute" + (i + 1)])).rate * int(tinfo["value" + (i + 1)]);

				} else {

					this.pTxtArr[i].text="";
					this.pLblArr[i].text="";

				}

			}

			if (power == 0)
				this.pTxtArr[0].text="" + PropUtils.getStringEasyById(1594);

			this.rollNum.setNum(power);

			if (tinfo.model2 == "" || tinfo.model2 == null) {
				this.effSwf.visible=false;
			} else {
				this.effSwf.visible=true;
			}

			this.weaponSwf.visible=false;
			this.bigAvater.visible=false;
			this.priceImg.fillEmptyBmd();
//			this.addChild(this.videoPlay);

//			videoPlay.play(UIEnum.DATAROOT + VersionManager.getInstance().urlAddVersion("flv/" + tinfo.flv.split("|")[Core.me.info.profession - 1]));

			var str:String;
			switch (tinfo.Sz_type) {
				case 5:
//					videoPlay.play(UIEnum.DATAROOT + VersionManager.getInstance().urlAddVersion("flv/" + tinfo.flv.split("|")[Core.me.info.profession - 1]));
					str=UIEnum.DATAROOT + VersionManager.getInstance().urlAddVersion("flv/" + tinfo.flv.split("|")[Core.me.info.profession - 1]);
//					str=UIEnum.DATAROOT + VersionManager.getInstance().urlAddVersion("flv/skill_fs_dark.swf");
					this.swfloader.load(new URLRequest(str));

					break;
				case 6:
//					videoPlay.play(UIEnum.DATAROOT + VersionManager.getInstance().urlAddVersion("flv/" + tinfo.flv));

					this.swfloader.load(new URLRequest(UIEnum.DATAROOT + VersionManager.getInstance().urlAddVersion("flv/" + tinfo.flv)));
					break;
			}

			/**
			 *1	等级（进度条）
2	杀死怪物	怪物名
3	杀死怪物数量（进度条）
4	完成指定任务	任务名
5	装备品质达成（进度条）（0普通，1优秀，2精良，3史诗，4传说）	品质名
6	开启指定纹章组
7	坐骑达到指定等阶（进度条）
8	翅膀达到指定等阶（进度条）
9	好友数量（进度条）
10	战斗力排行
11	军衔积分排行榜达到指定名次及以上
12	使用道具后获得	道具名
13	历史事件激活
14	全身装备强化（进度条）
15	宝石战斗力达成
16
17	宝石合成达到级别
18	消费排行榜排名
19	副本通关榜
20	VIP等级
21	购买（有时间限制为租用）
22	22
23	竞技场获胜次数
24	成为升龙城主
25	元素类型(1火，2水，3火，4光，5，暗)	元素类型
26	元素等级
27	职业性别战斗力排名
28	全身强化级别
29	全身装备品质达到级别
30	驯养坐骑时任意属性提升百分比达成
31	翅膀飞升(等级)重数达成
32	击杀玩家数量达成
33	点亮星座数量达成
34	在农场开地块数达成
35	农场单块土地级别达成
36	帮助他人怪灌溉神树次数达成
37	偷菜次数达成
38	在自己农场收获次数达成
39	任意单个佣兵亲密度星级达成
40	任意单个佣兵亲密度等级达成
41	佣兵学会技能数量的达成
42	拥有指定品质的佣兵 (1绿，2蓝，3紫，4金)	品质名
43
44
45
46
47
48	全身都有装备且装备属性均为指定元素(1火，2水，3火，4光，5，暗)	元素类型
49	所属行会赢得行会争霸冠军
50
51
52	升龙城占领行会全部成员
53	升龙城占领行会官衔（1，会长，2，长老，3精英，4，普通）
54	总战斗力达成
55	所属行会级别
56	世界成就获得数量
57	使用指定结婚戒指结婚(1第一个,2第二个,3第三个)

*/

			var marryarr:Array=[2399, 2400, 2401, 2402];
			var marr:Array=[2395, 2396, 2397, 2398];
			var qarr:Array=[1604, 1605, 1606, 1607, 1608];
			var quarr:Array=[2391, 2392, 2393, 2394];
			var earr:Array=[2370, 2371, 2372, 2373, 2374];
			var arr:Array=[];
			var ttinfo:TItemInfo;
			var stStr:String;
			var strcontent:String;
			for (i=0; i < o.sinfo[3].length; i++) {
				if (int(tinfo["factorNum" + (i + 1)]) > 0) {

					if ([1, 3, 7, 8, 14].indexOf(int(tinfo["factor" + (i + 1)])) > -1) {
						strcontent="(" + o.sinfo[3][i] + "/" + int(tinfo["factorNum" + (i + 1)]) + ")";
					} else if ([2, 4, 5, 12, 25, 48, 42, 57, 53].indexOf(int(tinfo["factor" + (i + 1)])) > -1) {

						if (int(tinfo["factor" + (i + 1)]) == 25 || int(tinfo["factor" + (i + 1)]) == 48) {
							strcontent="<font color='#00ff00'>" + PropUtils.getStringEasyById(earr[int(tinfo["factorNum" + (i + 1)]) - 1]) + "</font>";
						} else if (int(tinfo["factor" + (i + 1)]) == 5) {
							strcontent="<font color='#00ff00'>" + PropUtils.getStringEasyById(qarr[int(tinfo["factorNum" + (i + 1)]) - 1]) + "</font>";
						} else if (int(tinfo["factor" + (i + 1)]) == 42) {
							strcontent="<font color='#00ff00'>" + PropUtils.getStringEasyById(quarr[int(tinfo["factorNum" + (i + 1)]) - 1]) + "</font>";
						} else if (int(tinfo["factor" + (i + 1)]) == 57) {
							strcontent="<font color='#00ff00'>" + PropUtils.getStringEasyById(marryarr[int(tinfo["factorNum" + (i + 1)]) - 1]) + "</font>";
						} else if (int(tinfo["factor" + (i + 1)]) == 53) {
							strcontent="<font color='#00ff00'>" + PropUtils.getStringEasyById(marr[int(tinfo["factorNum" + (i + 1)]) - 1]) + "</font>";
						} else {
							ttinfo=TableManager.getInstance().getItemInfo(int(tinfo["factorNum" + (i + 1)]));
							strcontent="<font color='#" + ItemUtil.getColorByQuality2(ttinfo.quality) + "'><u><a href='event:itemid--" + int(tinfo["factorNum" + (i + 1)]) + "'>" + ttinfo.name + "</a></u></font>";
						}

					} else {
						strcontent="" + int(tinfo["factorNum" + (i + 1)]);
					}

					if (strcontent != null) {
						if (i == 0)
							strcontent=StringUtil.substitute(tinfo.des, [strcontent]);
						else
							strcontent=StringUtil.substitute(tinfo["des" + (i + 1)], [strcontent]);

						if (int(o.sinfo[3][i]) < int(tinfo["factorNum" + (i + 1)])) {
							strcontent+="<font color='#ff0000'>" + PropUtils.getStringEasyById(2360) + "</font>";
						} else {
							strcontent+="<font color='#00ff00'>" + PropUtils.getStringEasyById(2361) + "</font>";
						}

						//						strcontent+=strcontent;
						arr.push(strcontent);
					}
				}
			}


			this.descLbl.htmlText="" + arr.join("\n");

			if (tinfo.moneyType > 0) {
				this.buyBtn.visible=true;

				if (tinfo.time > 0) {
					this.buyBtn.text="" + PropUtils.getStringById(2362);
				} else {
					this.buyBtn.text="" + PropUtils.getStringById(1721);
				}

			} else {
				this.buyBtn.visible=false;
			}

			UIManager.getInstance().shiyeWnd.reAddChild();
		}

		private function onComplete(e:Event):void {

			if (this.dis != null && this.dis.parent == this)
				this.removeChild(this.dis);

			this.dis=e.target.content as DisplayObject;
			this.addChild(dis);

			this.dis.x=41;
		}

		public function clear():void {
			this.removeChild(this.videoPlay);
		}


	}
}
