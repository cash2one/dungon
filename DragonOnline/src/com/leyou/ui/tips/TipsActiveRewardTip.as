package com.leyou.ui.tips
{
	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TActiveRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.leyou.ui.tips.childs.TipsActiveRewardRender;
	
	public class TipsActiveRewardTip extends AutoSprite implements ITip
	{
		private var freeRenders:Vector.<TipsActiveRewardRender>;
		
		private var useRenders:Vector.<TipsActiveRewardRender>;
		
		private var bgArea:ScaleBitmap;
		
		public function TipsActiveRewardTip(){
			super(LibManager.getInstance().getXML("config/ui/tips/activeTips.xml"));
			init();
		}
		
		private function init():void{
			freeRenders = new Vector.<TipsActiveRewardRender>();
			useRenders = new Vector.<TipsActiveRewardRender>();
			bgArea = getUIbyID("bgArea") as ScaleBitmap;
		}
		
		private function getFreeRender():TipsActiveRewardRender{
			var render:TipsActiveRewardRender = freeRenders.pop();
			if(null == render){
				render = new TipsActiveRewardRender();
			}
			render.x = 5;
			render.y = 5 + 69 * useRenders.length;
			useRenders.push(render);
			addChild(render);
			return render;
		}
		
		private function clear():void{
			var length:int = useRenders.length;
			for(var n:int = 0; n < length; n++){
				var render:TipsActiveRewardRender = useRenders[n];
				removeChild(render);
				render.clear();
				freeRenders.push(render);
			}
			useRenders.length = 0;
		}
		
		/**
		 * <T>更新信息</T>
		 * 
		 * @param info 信息
		 * 
		 */		
		public function updateInfo(info:Object):void{
			clear();
			var id:int = info as int;
			var render:TipsActiveRewardRender;
			var reardInfo:TActiveRewardInfo = TableManager.getInstance().getActiveRewardInfo(id);
			if(0 != reardInfo.exp){
				render = getFreeRender();
				render.updateInfo(65534, reardInfo.exp);
			}
			if(0 != reardInfo.money){
				render = getFreeRender();
				render.updateInfo(65535, reardInfo.money);
			}
			if(0 != reardInfo.energy){
				render = getFreeRender();
				render.updateInfo(65533, reardInfo.energy);
			}
			if(0 != reardInfo.contribution){
				render = getFreeRender();
				render.updateInfo(65531, reardInfo.contribution);
			}
			if(0 != reardInfo.byb){
				render = getFreeRender();
				render.updateInfo(65532, reardInfo.byb);
			}
			if(0 != reardInfo.item1){
				render = getFreeRender();
				render.updateInfo(reardInfo.item1, reardInfo.item1Count);
			}
			if(0 != reardInfo.item2){
				render = getFreeRender();
				render.updateInfo(reardInfo.item2, reardInfo.item2Count);
			}
			bgArea.setSize(bgArea.width, 10 + 69 * useRenders.length);
		}
		
		public function get isFirst():Boolean{
			return false;
		}
	}
}