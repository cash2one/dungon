package com.leyou.ui.ttt {

	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Arena;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Ttt;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MessageCnSeWnd extends AutoWindow {

		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;
		private var contentLbl:Label;
		private var titleNameLbl:Label;
		private var bybRBtn:RadioButton;
		private var ybRBtn:RadioButton;
		private var ybLbl:Label;
		private var itemLbl:Label;

		private var type:int=0;
		private var count:int=0;
		private var lv:int=0;

		public function MessageCnSeWnd() {
			super(LibManager.getInstance().getXML("config/ui/messagebox/MessageCnSeWnd.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.contentLbl=this.getUIbyID("contentLbl") as Label;
			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;
			this.bybRBtn=this.getUIbyID("bybRBtn") as RadioButton;
			this.ybRBtn=this.getUIbyID("ybRBtn") as RadioButton;
			this.ybLbl=this.getUIbyID("ybLbl") as Label;
			this.itemLbl=this.getUIbyID("itemLbl") as Label;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.itemLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.itemLbl.mouseEnabled=true;
			 
//			this.ybRBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onMouseMove(e:MouseEvent):void {

			var lb:Label=Label(e.target);
			var i:int=lb.getCharIndexAtPoint(e.localX, e.localY);
			var xmltxt:XML=XML(lb.getXMLText(i, i + 1));

			var url:String=xmltxt.textformat.@url;

			if (url != null && url != "") {

				var tipsInfo:TipsInfo=new TipsInfo();
				tipsInfo.itemid=int(url.split("--")[1])

				tipsInfo.isShowPrice=false;

				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipsInfo, new Point(e.stageX, e.stageY));

			} else {
				ToolTipManager.getInstance().hide();
			}

		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "confirmBtn":
					if (type == 0) {
						if (count == 1)
							Cmd_Ttt.cmfastComplete(lv, (this.ybRBtn.isOn ? 0 : 1));
						else
							Cmd_Ttt.cmfastComplete(0, (this.ybRBtn.isOn ? 0 : 1));
					} else if (type == 1) {
						Cmd_Ttt.cmCopyReset((this.ybRBtn.isOn ? 0 : 1));
					} else if (type == 2) {
						Cmd_Guild.cm_GuildCall((this.ybRBtn.isOn ? 0 : 1));
					} else if (type == 3) {
						if (count == 1)
							Cmd_Arena.cm_ArenaRefresh((this.ybRBtn.isOn ? 0 : 1));
						else if (count == 2)
							Cmd_Arena.cm_ArenaBuyPkCount((this.ybRBtn.isOn ? 0 : 1))
					}
					break;
				case "cancelBtn":
//					this.hide();
					break;
				case "bybRBtn":
					break;
				case "ybRBtn":
					break;
			}
			this.hide();
		}

		/**
		 *
		 * @param type: 0:扫荡;1:重置;
		 *
		 */
		public function showPanel(type:int, count:int, lv:int=-1):void {

			this.count=count;
			this.type=type;
			this.show();

			var tinfo:TItemInfo;
			if (type == 0) {

				tinfo=TableManager.getInstance().getItemInfo(ConfigEnum.Babel7.split("|")[0]);
				this.itemLbl.htmlText="<font color='#" + ItemUtil.getColorByQuality2(tinfo.quality) + "'><u><a href='event:itemid--" + ConfigEnum.Babel7.split("|")[0] + "'>" + tinfo.name + "</a></u> x" + count+"</font>";
				this.ybLbl.text="" + (ConfigEnum.Babel4 * count);

				this.titleNameLbl.text="" + TableManager.getInstance().getSystemNotice(10147).content;

				this.count=count;
				this.lv=lv;

			} else if (type == 1) {

				tinfo=TableManager.getInstance().getItemInfo(ConfigEnum.Babel8.split("|")[0]);
				this.itemLbl.htmlText="<font color='#" + ItemUtil.getColorByQuality2(tinfo.quality) + "'><u><a href='event:itemid--" + ConfigEnum.Babel8.split("|")[0] + "'>" + tinfo.name + "</a></u></font>";
				this.ybLbl.text="" + ConfigEnum.Babel9;

				this.titleNameLbl.text="" + TableManager.getInstance().getSystemNotice(10148).content;
				this.contentLbl.text="" + TableManager.getInstance().getSystemNotice(10142).content;

			} else if (type == 2) {

				tinfo=TableManager.getInstance().getItemInfo(ConfigEnum.union44.split("|")[0]);
				this.itemLbl.htmlText="<font color='#" + ItemUtil.getColorByQuality2(tinfo.quality) + "'><u><a href='event:itemid--" + ConfigEnum.union44.split("|")[0] + "'>" + tinfo.name + "</a></u></font>";
				this.ybLbl.text="" + ConfigEnum.union45;

				this.titleNameLbl.text="" + PropUtils.getStringById(2347);
				this.contentLbl.text="" + TableManager.getInstance().getSystemNotice(10158).content;

			} else if (type == 3) {

				if (count == 1) {
					tinfo=TableManager.getInstance().getItemInfo(ConfigEnum.Miliyary27.split("|")[0]);
					this.itemLbl.htmlText="<font color='#" + ItemUtil.getColorByQuality2(tinfo.quality) + "'><u><a href='event:itemid--" + ConfigEnum.Miliyary27.split("|")[0] + "'>" + tinfo.name + "</a></u> x "+ConfigEnum.Miliyary27.split("|")[1]+"</font>";
					this.ybLbl.text="" + ConfigEnum.Miliyary4.split("|")[0];

					this.titleNameLbl.text="" + PropUtils.getStringById(2346);
					this.contentLbl.text="" + TableManager.getInstance().getSystemNotice(10157).content;

				} else if (count == 2) {

					tinfo=TableManager.getInstance().getItemInfo(ConfigEnum.Miliyary26.split("|")[0]);
					this.itemLbl.htmlText="<font color='#" + ItemUtil.getColorByQuality2(tinfo.quality) + "'><u><a href='event:itemid--" + ConfigEnum.Miliyary26.split("|")[0] + "'>" + tinfo.name + "</a></u> x "+ConfigEnum.Miliyary26.split("|")[1]+"</font>";
					this.ybLbl.text="" + ConfigEnum.Miliyary3.split("|")[0];

					this.titleNameLbl.text="" + PropUtils.getStringById(2345);
					this.contentLbl.text="" + TableManager.getInstance().getSystemNotice(10156).content;
				}
			}

			this.ybRBtn.turnOn();
		}



	}
}
