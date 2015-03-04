package com.leyou.ui.tips {

	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.utils.StringUtil;
	import com.leyou.data.element.ElementInfo;
	import com.leyou.data.element.Elements;
	import com.leyou.ui.tips.childs.TipsGrid;
	import com.leyou.utils.PropUtils;

	public class TipsElementWnd extends AutoSprite implements ITip {

		private var nameLbl:Label;
		private var lvLbl:Label;
		private var dateLbl:Label;
		private var bKeLbl:Label;
		private var keLbl:Label;

		private var desc1Lbl:TextArea;
		private var desc2Lbl:TextArea;
		private var desc3Lbl:TextArea;

		private var bindImg:Image;
		private var progressSc:ScaleBitmap;

		private var grid:TipsGrid;
		private var eleSwf:SwfLoader;

		public function TipsElementWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsElementWnd.xml"));
			this.init();
//			this.hideBg();
//			this.clsBtn.visible=false;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.dateLbl=this.getUIbyID("dateLbl") as Label;
			this.bKeLbl=this.getUIbyID("bKeLbl") as Label;
			this.keLbl=this.getUIbyID("keLbl") as Label;

			this.desc1Lbl=this.getUIbyID("desc1Lbl") as TextArea;
			this.desc2Lbl=this.getUIbyID("desc2Lbl") as TextArea;
			this.desc3Lbl=this.getUIbyID("desc3Lbl") as TextArea;

			this.bindImg=this.getUIbyID("bindImg") as Image;
			this.progressSc=this.getUIbyID("progressSc") as ScaleBitmap;

//			this.grid=new TipsGrid();
//			this.addChild(this.grid);
//
//			this.grid.x=13;
//			this.grid.y=23;

			this.eleSwf=new SwfLoader();
			this.addChild(this.eleSwf);

			this.eleSwf.x=-25;
			this.eleSwf.y=-13;

			this.desc1Lbl.visibleOfBg=false;
			this.desc2Lbl.visibleOfBg=false;
			this.desc3Lbl.visibleOfBg=false;
		}

		public function updateInfo(info:Object):void {
			if (info == null)
				return;

			var ele:Elements=info as Elements;

			switch (ele.id) {
				case 0:
					this.eleSwf.update(99925);
					break;
				case 1:
					this.eleSwf.update(99924);
					break;
				case 2:
					this.eleSwf.update(99922);
					break;
				case 3:
					this.eleSwf.update(99921);
					break;
				case 4:
					this.eleSwf.update(99923);
					break;
			}


			this.bindImg.visible=ele.flag

			this.nameLbl.text=PropUtils.elementArr[ele.id] + "元素"
			this.lvLbl.text=ele.lv + "级";

			this.dateLbl.text=ele.exp + "/" + ele.sumExp;
			this.progressSc.scaleX=ele.exp / ele.sumExp;

			this.bKeLbl.text="" + PropUtils.elementArr[PropUtils.elementKeyArr.indexOf(ele.id)];
			this.keLbl.text="" + PropUtils.elementArr[PropUtils.elementKeyArr[ele.id]];

			this.desc1Lbl.setHtmlText(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9909).content, [PropUtils.elementArr[PropUtils.elementKeyArr[ele.id]]]));
			this.desc2Lbl.setHtmlText(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9910).content, [PropUtils.elementArr[PropUtils.elementKeyArr.indexOf(ele.id)]]));

			this.desc3Lbl.setHtmlText(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9911).content, [int(ele.lv * 5) + "%", int(ele.lv * 5) + "%",]));

		}

		public function get isFirst():Boolean {
			// TODO Auto Generated method stub
			return false;
		}

	}
}
