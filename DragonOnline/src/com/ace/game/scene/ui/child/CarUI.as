package com.ace.game.scene.ui.child
{
	import com.ace.ICommon.ILivingUI;
	import com.ace.config.Core;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.component.ProgressImage;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.StringUtil_II;
	
	public class CarUI extends AutoSprite implements ILivingUI
	{
		private static const colorDic:Object={1700:"#ffffff", 1701:"#69e053", 1702:"#3fa6ed", 1703:"#cc54ea", 1704:"#f6d654"};
		
		private var palyerNameLbl:Label;
		
		private var carNameLbl:Label;
		
		private var pointSwf:SwfLoader;
		
		private var blodImg:ProgressImage;
		
		public function CarUI(){
			super(LibManager.getInstance().getXML("config/ui/scene/titleDeWnd.xml"));
			init();
		}
		
		private function init():void{
			palyerNameLbl = getUIbyID("palyerNameLbl") as Label;
			carNameLbl = getUIbyID("carNameLbl") as Label;
			pointSwf = getUIbyID("pointSwf") as SwfLoader;
			if(null == blodImg){
				blodImg=new ProgressImage();
				blodImg.x = 70;
				blodImg.y = 42;
				addChild(blodImg);
				blodImg.updateBmp("ui/other/HP_Red_mini.png");
			}
		}
		
		public function updataHp(info:LivingInfo):void{
			blodImg.rollToProgress(info.baseInfo.hp / info.baseInfo.maxHp);
		}
		
		public function showName(info:*):void{
			var cn:String = info.name;
			var pn:String = info.name;
			var bi:int = info.name.indexOf("(");
			var ei:int = info.name.indexOf(")");
			if(-1 != bi){
				cn = info.name.substr(0, bi);
				pn = info.name.substring(bi+1, ei);
			}
			carNameLbl.htmlText = StringUtil_II.getColorStr(info.name + "[lv" + info.level + "]",colorDic[info.tId], 14);;
//			carNameLbl.text = cn+"[" + info.id + "][lv" + info.level + "][" + info.speed + "]";
			palyerNameLbl.text = pn;
			if(pn != Core.me.info.name){
				pointSwf.stop();
				pointSwf.visible = false;
			}else{
//				pointSwf.playAct
				pointSwf.visible = true;
			}
		}
		
		public function showTitles(info:LivingInfo):void{
		}
		
		public function showPs(str:String):void{
		}
		
		public function updataPs(livingBase:LivingBase):void{
			x=livingBase.x - 94;
			y=livingBase.y - 2 * livingBase.bInfo.radius - 45;
		}
		
		override public function die():void {
			parent.removeChild(this);
		}
		
		public function get livingName():String{
			return null;
		}
		
		public function switchVisible($visible:Boolean):void{
		}
	}
}