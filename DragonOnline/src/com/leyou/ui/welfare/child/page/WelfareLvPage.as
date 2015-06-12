package com.leyou.ui.welfare.child.page
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TLevelGiftInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.leyou.ui.welfare.child.component.WelfareLvRender;

	/**
	 * 福利等级奖励分页
	 * @author wfh
	 * 
	 */	
	public class WelfareLvPage extends AutoSprite
	{
		private var renders:Object;
		
		public function WelfareLvPage(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareLv.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			renders = {};
		}
		
		public function updateInfo(obj:Object):void{
			var ll:Array = obj.ulist;
			var count:int = ll.length;
			for(var n:int = 0; n < count; n++){
				var level:int = ll[n][0];
//				var st:Boolean = (0 != ll[n][1]);
				var render:WelfareLvRender = getRender(level);
				var giftInfo:TLevelGiftInfo = TableManager.getInstance().getLevelGiftInfo(level);
				render.updateInfo(giftInfo, ll[n][1]);
			}
		}
		
		private function getRender(level:int):WelfareLvRender{
			var render:WelfareLvRender = renders[level];
			if(null == render){
				render = new WelfareLvRender();
				addChild(render);
				render.x = 5;
				if(Core.isSF){
					render.y = 5 + (level/10-2)*62;
				}else{
					render.y = 5 + (level/10-1)*62;
				}
				renders[level] = render;
			}
			return render;
		}
		
		public function flyItem():void{
			for(var key:String in renders){
				var render:WelfareLvRender =  renders[key];
				if(render.waitFly){
					render.waitFly = false;
					render.flyItem();
				}
			}
		}
		
		public function hasReward():Boolean{
			for(var key:String in renders){
				var render:WelfareLvRender =  renders[key];
				if(render.hasReward()){
					return true;
				}
			}
			return false;
		}
	}
}