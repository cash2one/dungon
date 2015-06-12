package com.leyou.ui.tips {

	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.table.TBloodBase;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.TipsEnum;
	import com.leyou.utils.BadgeUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.Sprite;

	public class TipsBadge extends Sprite {

		private var bg:ScaleBitmap;
		private var lbl:Label;

		private var w:int;

		public function TipsBadge() {

			this.bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.getTextScaleInfo("Tips").imgUrl));
			this.bg.scale9Grid=FontEnum.getTextScaleInfo("Tips").rect;
			this.bg.alpha=.8;
			this.addChildAt(this.bg, 0);

			this.w=132;

			this.lbl=new Label();
			this.lbl.width=this.w - 2;
			this.lbl.wordWrap=true;
			this.lbl.multiline=true;
			this.lbl.x=2;
			this.lbl.y=2;
			this.addChild(this.lbl);

//			var format:TextFormat=new TextFormat();
//			format.size=12;
//
//			this.lbl.defaultTextFormat=format;

			//LayerManager.getInstance().windowLayer.addChild(this);
			LayerManager.getInstance().clientTipLayer.addChild(this);

			this.visible=false;
		}

		public function show():void {
			LayerManager.getInstance().clientTipLayer.addChild(this);
		}

		private function updateSize():void {
			if (this.lbl.height + 2 < this.lbl.y + this.lbl.height + 2)
				this.bg.setSize(this.w + 2, this.lbl.y + this.lbl.height + 2);
			else
				this.bg.setSize(this.w + 2, this.lbl.height + 2);
		}

		/**
		 *p_attack	p_defense	m_attack	m_defense	extraHP	extraMP	crit	critReduce	hit	dodge	critDam	critDamReduce
		 *
		 */
		public function updateData(info:TBloodBase, state:int):void {
			var str:String=StringUtil_II.getColorStr("  " + info.bPDes, TipsEnum.COLOR_YELLOW, 18) + "\n\n";

			if (state == 0 || state == 1) {
				str+=StringUtil_II.getColorStr("  "+PropUtils.getStringById(1921), TipsEnum.COLOR_YELLOW) + "\n";
			} else {
				str+=StringUtil_II.getColorStr("  "+PropUtils.getStringById(1922), TipsEnum.COLOR_YELLOW) + "\n";
			}

			if (info.p_attack != "0")
				str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[3] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.p_attack, TipsEnum.COLOR_WHITE) + "\n";

			if (info.p_defense != "0")
				str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[4] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.p_defense, TipsEnum.COLOR_WHITE) + "\n";

//			if (info.m_attack != "0")
//				str+="     " + StringUtil_II.getColorStr("法术攻击: ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.m_attack, TipsEnum.COLOR_WHITE) + "\n";

//			if (info.m_defense != "0")
//				str+="     " + StringUtil_II.getColorStr("法术防御: ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.m_defense, TipsEnum.COLOR_WHITE) + "\n";

			if (info.extraHP != "0")
				str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[21] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.extraHP, TipsEnum.COLOR_WHITE) + "\n";

			if (info.extraMP != "0")
				str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[22] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.extraMP, TipsEnum.COLOR_WHITE) + "\n";

			if (info.crit != "0")
				str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[7] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.crit, TipsEnum.COLOR_WHITE) + "\n";

			if (info.critReduce != "0")
				str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[8] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.critReduce, TipsEnum.COLOR_WHITE) + "\n";

			if (info.hit != "0")
				str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[9] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.hit, TipsEnum.COLOR_WHITE) + "\n";

			if (info.dodge != "0")
				str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[10] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.dodge, TipsEnum.COLOR_WHITE) + "\n";

			if (info.critDam != "0")
				str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[11] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.critDam, TipsEnum.COLOR_WHITE) + "\n";

			if (info.critDamReduce != "0")
				str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[12] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.critDamReduce, TipsEnum.COLOR_WHITE) + "\n";

			//str+="     " + StringUtil.getColorStr("经验: ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil.getColorStr(info.expSuccess, TipsEnum.COLOR_WHITE) + "\n";

			if (state == 0) {
				str+=StringUtil_II.getColorStr("\n "+PropUtils.getStringById(1923), TipsEnum.COLOR_RED) + "\n";
				str+=StringUtil_II.getColorStr(" "+PropUtils.getStringById(1924), TipsEnum.COLOR_RED) + "\n";

			} else if (state == 1) {
				str+=StringUtil_II.getColorStr("  "+PropUtils.getStringById(1925), TipsEnum.COLOR_YELLOW) + "\n";

				var tcolor:String=TipsEnum.COLOR_DEFAULT_FONT;
				if (UIManager.getInstance().backpackWnd.jb < int(info.money))
					str+=StringUtil_II.getColorStr("   " + PropUtils.propArr[31] + ": " + info.money, TipsEnum.COLOR_RED) + "\n";
				else
					str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[31] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.money, TipsEnum.COLOR_WHITE) + "\n";

				tcolor=TipsEnum.COLOR_DEFAULT_FONT;
				if (Core.me.info.baseInfo.hunL < int(info.energy))
					str+=StringUtil_II.getColorStr("   " + PropUtils.propArr[28] + ": " + info.energy, TipsEnum.COLOR_RED) + "\n";
				else
					str+="     " + StringUtil_II.getColorStr(PropUtils.propArr[28] + ": ", TipsEnum.COLOR_DEFAULT_FONT) + StringUtil_II.getColorStr(info.energy, TipsEnum.COLOR_WHITE) + "\n";

				str+="     " + StringUtil_II.getColorStr(PropUtils.getStringById(1926)+": ", TipsEnum.COLOR_YELLOW) + StringUtil_II.getColorStr(BadgeUtil.getTypeByRate(int(info.rate)), TipsEnum.COLOR_WHITE) + "\n";

				str+=StringUtil_II.getColorStr("\n  "+PropUtils.getStringById(1927), TipsEnum.COLOR_GREEN) + "\n";
			} else if (state == 2) {

				str+=StringUtil_II.getColorStr("\n  "+PropUtils.getStringById(1928), TipsEnum.COLOR_ORANGE1) + "\n";
			}

			this.lbl.htmlText=str;
			this.updateSize();
		}

		public function updatePs(x:Number, y:Number):void {

//			var p:Point=this.globalToLocal(new Point(x,y));
//			
//			x=p.x;
//			y=p.y;

			if (y < 0)
				y=0;

			if (x < 0)
				x=0;

			if (x + this.width > UIEnum.WIDTH)
				x=UIEnum.WIDTH - this.width;

			if (y + this.height > UIEnum.HEIGHT)
				y=UIEnum.HEIGHT - this.height;

			this.x=x + 5;
			this.y=y + 5;
		}


	}
}
