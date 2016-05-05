package com.leyou.ui.ttt {

	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.TipEnum;
	import com.ace.game.scene.player.Living;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class TttLog extends AutoWindow {

		private var closeBtn:NormalButton;
		private var descLbl:Label;
		private var gridlist:ScrollPane;

		private var str:String="";

		public function TttLog() {
			super(LibManager.getInstance().getXML("config/ui/ttt/tttLog.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.closeBtn=this.getUIbyID("closeBtn") as NormalButton
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.gridlist=this.getUIbyID("gridlist") as ScrollPane;

			this.descLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.descLbl.mouseEnabled=true;

			this.gridlist.addToPane(this.descLbl);
			this.descLbl.x=0;
			this.descLbl.y=0;

			this.descLbl.wordWrap=true;
			this.descLbl.multiline=true;
			this.descLbl.width=455;
//			this.descLbl.height=437;

			this.closeBtn.addEventListener(MouseEvent.CLICK, onClosed);
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

		public function showPanel(o:Object):void {

			if (!this.visible)
				this.show();

			var lving:TLivingInfo;
			if (o.jllist.length > 0) {

				lving=TableManager.getInstance().getLivingInfo(o.mid);
				var titem:TItemInfo=TableManager.getInstance().getItemInfo(o.itemid);

				var tmp:Array=[];
				var tmp1:Array=[];
				for each (tmp in o.jllist) {
					titem=TableManager.getInstance().getItemInfo(tmp[0]);
					tmp1.push("<font color='#" + ItemUtil.getColorByQuality2(titem.quality) + "'><u><a href='event:itemid--" + tmp[0] + "'>" + titem.name + "</a></u></font> x " + tmp[1]);
				}

				str+=StringUtil.substitute(TableManager.getInstance().getSystemNotice(10155).content, [o.floor, lving.name, tmp1.join(",")]) + "\n";

			} else {

				lving=TableManager.getInstance().getLivingInfo(o.mid);
				str+=StringUtil.substitute(TableManager.getInstance().getSystemNotice(10154).content, [o.floor, lving.name]) + "\n";

			}

			this.descLbl.htmlText="" + str;

			this.gridlist.scrollTo(0);
			this.gridlist.updateUI();
			DelayCallManager.getInstance().add(this, this.gridlist.updateUI, "updateUI", 4);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

		}

		private function onClosed(e:MouseEvent):void {
			this.hide();
		}

		override public function hide():void {
			super.hide();
			this.descLbl.text="";
			this.str="";
		}

	}
}
