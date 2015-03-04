package com.ace.game.scene.ui.child {
	import com.ace.ICommon.ILivingUI;
	import com.ace.enum.FilterEnum;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.gameData.player.LivingInfo;
	import com.leyou.utils.ItemUtil;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ItemUI extends Sprite implements ILivingUI {
		private static var textFormat:TextFormat=new TextFormat("Microsoft YaHei", 12);
//		private var mc:SwfLoader;
//		private var titleNameLbl:Label; //称号
		private var nameLbl:TextField; //玩家名称

//		private var blodImg:Image; //没有血

		public function ItemUI() {
			init();
		}

		protected function init():void {
			nameLbl=new TextField();
			nameLbl.defaultTextFormat=textFormat;
			nameLbl.autoSize=TextFieldAutoSize.LEFT;
			addChild(nameLbl);
			nameLbl.filters=[FilterEnum.hei_miaobian];
		}

		/**更新：根据race不同，显示不同的样式*/
		public function updata(info:LivingInfo):void {

		}

		/**调整ui的位置*/
		public function updataPs(livingBase:LivingBase):void {
			this.x=livingBase.x - nameLbl.width * 0.5;
			this.y=livingBase.y - 40;
		}

		/**显示玩家名称*/
		public function showName(info:*):void {
			this.nameLbl.textColor=ItemUtil.getColorByQuality(info.quality);
			this.nameLbl.text=((info.tId == 65535) ? info.num : "") + info.name;
		}

		public function showTitles(info:LivingInfo):void {
		}

		public function showPs(str:String):void {
		}

		/**更新血值*/
		public function updataHp(info:LivingInfo):void {
		}

		public function die():void {
			this.parent.removeChild(this);
		}
		
		public function get livingName():String{
			return null;
		}
		
		public function switchVisible($visible:Boolean):void{
		}
	}
}
