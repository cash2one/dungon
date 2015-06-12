package com.leyou.ui.skill {


	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.utils.StringUtil;
	import com.leyou.data.playerSkill.TipSkillInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Skill;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.ui.skill.childs.SkillFuBar;
	import com.leyou.ui.skill.childs.SkillFuNone;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class SkillFuWnd extends AutoWindow {

		private var itemNameLbl:Label;
		private var numLbl:Label;

		private var renderArr:Array=[];

		public var index:int=0;

		public var selectIndex:int=-1;

		private var wnd:SimpleWindow;

		public function SkillFuWnd() {
			super(LibManager.getInstance().getXML("config/ui/skill/SkillFuWnd.xml"));
			this.init();
			this.mouseEnabled=true;
			this.mouseChildren=true;
			this.hideBg();
			this.clsBtn.y=20;
		}

		private function init():void {

			this.itemNameLbl=this.getUIbyID("itemNameLbl") as Label;
			this.numLbl=this.getUIbyID("numLbl") as Label;

			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, onClick);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onClick);
			this.addEventListener(MouseEvent.MOUSE_OUT, onClick);

			var render:*;
			var i:int=0;

			render=new SkillFuNone();
			this.addToPane(render);
			this.renderArr.push(render);

			render.x=11;
			render.y=57 + i * render.height;
			i++;

			render=new SkillFuBar();
			this.addToPane(render);
			this.renderArr.push(render);

			render.x=11;
			render.y=57 + i * render.height;

			i++;

			render=new SkillFuBar();
			this.addToPane(render);
			this.renderArr.push(render);

			render.x=11;
			render.y=57 + i * render.height;

			i++;

			render=new SkillFuBar();
			this.addToPane(render);
			this.renderArr.push(render);

			render.x=11;
			render.y=57 + i * render.height;

			i++;

			render=new SkillFuBar();
			this.addToPane(render);
			this.renderArr.push(render);

			render.x=11;
			render.y=57 + i * render.height;

//			var item:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.skillItem);

//			this.itemNameLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
//			this.itemNameLbl.htmlText="<font color='#00ff00'><u><a href='event:" + ConfigEnum.skillItem + "'>" + item.name + "</a></u></font>";
//			this.itemNameLbl.htmlText="";
//			this.itemNameLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
//			this.itemNameLbl.addEventListener(TextEvent.LINK, onLink);
//			this.itemNameLbl.addEventListener(MouseEvent.CLICK, onItemClick);
//			this.itemNameLbl.mouseEnabled=true;

			this.allowDrag=false;
		}

		private function onItemClick(e:MouseEvent):void {
			this.buyItem();
		}

		private function onLink(e:TextEvent):void {
			var arr:int=int(this.numLbl.text);

			var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
			swnd.pushItem(ConfigEnum.skillItem, ConfigEnum.skillbindItem, arr);

//			if (MyInfoManager.getInstance().getBagItemNumByName(this.itemNameLbl.text) == 0)
			UILayoutManager.getInstance().show(WindowEnum.SKILL, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);

//			UIManager.getInstance().quickBuyWnd.getItemNotShow(ConfigEnum.skillItem, ConfigEnum.skillbindItem, arr);
		}

		private function buyItem():void {
			var arr:int=int(this.numLbl.text);

			if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.skillItem, ConfigEnum.skillbindItem))
				UILayoutManager.getInstance().show(WindowEnum.SKILL, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);

			UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.skillItem, ConfigEnum.skillbindItem, arr);
		}

		public function showPanel(arr:Array):void {
			this.show();

//			UIManager.getInstance().skillWnd.x=(UIEnum.WIDTH - UIManager.getInstance().skillWnd.width - this.width) / 2;
//			UIManager.getInstance().skillWnd.y=(UIEnum.HEIGHT - this.height) / 2;
//
//			this.x=UIManager.getInstance().skillWnd.x + UIManager.getInstance().skillWnd.width;
//			this.y=UIManager.getInstance().skillWnd.y;

			this.updateInfo(arr);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

//			this.numLbl.text="" +Core.me.info.baseInfo.hunL;
			this.numLbl.text="" + ConfigEnum.skill3;

			if (!UIManager.getInstance().skillWnd.visible)
				UIManager.getInstance().hideWindow(WindowEnum.RUNE);
		}


		public function updateInfo(arr:Array):void {

			this.index=MyInfoManager.getInstance().skilldata.skillItems.indexOf(arr);
			var skill:Array=TableManager.getInstance().getSkillArr(arr[1]);

			skill.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			var skb:Array=MyInfoManager.getInstance().skilldata.skillItems;
//			this.titleLbl.text=""+skill[0].name;

//			for (var i:int=0; i < skill.length; i++) {
			for (var i:int=0; i < 4; i++) {

				if (i == 0) {

					if (MyInfoManager.getInstance().skilldata.skillItems[this.index].indexOf(2, 3) == -1 && (arr.length != 7 || arr[6].split("_")[1] != 2)) {
						this.renderArr[i].state=true;
						this.renderArr[i].hight=true;
					} else {
						this.renderArr[i].state=false;
						this.renderArr[i].hight=false;
					}

				} else {
					this.renderArr[i].updateInfo(skill[i]);
					this.renderArr[i].active=arr[i + 2];
				}
			}

			if (arr.length == 7) {
				this.renderArr[i].visible=true;

				var str:String=arr[i + 2];

				this.renderArr[i].updateInfo(skill[str.split("_")[0]]);
				this.renderArr[i].active=str.split("_")[1];

			} else
				this.renderArr[i].visible=false;
		}

		public function setChangeRune():void {
			if (this.selectIndex != -1) {

				var pos:int=this.selectIndex;
				if (this.selectIndex == 4) {
					pos=MyInfoManager.getInstance().skilldata.skillItems[this.index][6].split("_")[0];
				}

				Cmd_Skill.cm_sklChange(index, pos);
			}
		}

		private function onClick(e:MouseEvent):void {

			if (e.target is SkillFuNone || e.target is SkillFuBar) {

				var skill:Array=TableManager.getInstance().getSkillArr(MyInfoManager.getInstance().skilldata.skillItems[this.index][1]);
				skill.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

				var sk:TSkillInfo=skill[this.renderArr.indexOf(e.target)];

				if (e.type == MouseEvent.CLICK) {

					if (e.target is SkillFuBar && SkillFuBar(e.target).state == 0) {
						return;
					}

					var skills:Array=MyInfoManager.getInstance().skilldata.skillItems[this.index];

					var acid:int=skills.indexOf(2, 3) - 2;
					if (acid < 0 && skills.length == 7 && (skills[6]).split("_")[1]==2) {
						acid=(skills[6]).split("_")[0];
					}

					acid=acid < 0 ? 0 : acid;

					if (this.renderArr.indexOf(e.target) != acid) {

						this.selectIndex=this.renderArr.indexOf(e.target);

						var str:String="";
						if (acid == 0) {

//							str="确认将<font color='#00ff00'><u>" + sk.name + "</u></font>的符文切换为<font color='#00ff00'><u>" + sk.runeName + "</u></font>?，本次切换不消耗道具。";
							str=StringUtil.substitute(TableManager.getInstance().getSystemNotice(2121).content, [sk.name, sk.runeName]);

						} else {

//							str="切换符文需要消耗道具<font color='#00ff00'><u><a href='event:" + ConfigEnum.skillItem + "'>技能符石</a></u></font>，是否确定这样做？";
							str=StringUtil.substitute(TableManager.getInstance().getSystemNotice(2120).content, [ConfigEnum.skill3]);

						}

						PopupManager.showConfirm(str, function():void {
//							if (acid == 0) {

							UIManager.getInstance().skillWnd.setChangeRune();

//							} else {

//								if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.skillItem, ConfigEnum.skillbindItem)) {
//									UILayoutManager.getInstance().show(WindowEnum.SKILL, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
//									UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.skillItem, ConfigEnum.skillbindItem);
//								} else {
//
//									if (selectIndex != -1) {
//										Cmd_Skill.cm_sklChange(index, selectIndex, (UIManager.getInstance().quickBuyWnd.getCost(ConfigEnum.skillItem, ConfigEnum.skillbindItem) == 0 ? 2 : 1));
//									}
//
//								}

//							}
						}, null, false, "changeRune", "切换符文");
					}
				} else if (e.type == MouseEvent.MOUSE_OVER || e.type == MouseEvent.MOUSE_MOVE) {
					e.target.hight=true;

					if (e.target is SkillFuNone)
						return;

					var tipInfo:TipSkillInfo=new TipSkillInfo();
					tipInfo.skillInfo=sk;
					tipInfo.hasRune=false;
					tipInfo.level=MyInfoManager.getInstance().skilldata.skillItems[this.index][2];
					tipInfo.runde=MyInfoManager.getInstance().skilldata.skillItems[this.index].indexOf(2, 3) - 2;

					ToolTipManager.getInstance().show(TipEnum.TYPE_RUNE, tipInfo, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));

				} else if (e.type == MouseEvent.MOUSE_OUT) {
					e.target.hight=false;
				}
			}

		}

		private function onMouseOver(e:MouseEvent):void {

			var target:Label=Label(e.target);
			var n:int=target.getCharIndexAtPoint(e.localX, e.localY);
			if (n >= 0) {
				var url:String=target.getTextFormat(n, n + 1).url;
				if (url != null && url != "") {
					ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, int(url.split(":")[1]), new Point(e.stageX, e.stageY));
				}
			}

		}

		override public function hide():void {
			super.hide();

			if (wnd != null) {
				wnd.hide();
				wnd=null;
			}

			UIManager.getInstance().hideWindow(WindowEnum.MESSAGE);
		}

		override public function get height():Number {
			return 522;
		}

	}
}
