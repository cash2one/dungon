package com.leyou.ui.rank.child
{
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.leyou.net.cmd.Cmd_Rank;
	
	import flash.events.MouseEvent;
	
	//英雄榜列表
	public class RankHeroRender extends AutoSprite
	{
		private const RankCount:int = 8;
		
		private var renders:Vector.<RankHeroItemRender>;
		
		private var listener:Function;
		
		public function RankHeroRender(){
			super(LibManager.getInstance().getXML("config/ui/rank/rankAll.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			renders = new Vector.<RankHeroItemRender>();
			for(var n:int = 0; n < RankCount; n++){
				var render:RankHeroItemRender = new RankHeroItemRender();
				render.x = 35 + int(n % 2) * 327;
				render.y = 10 + int(n / 2) * 103;
				renders.push(render);
				addChild(render);
				render.setType(getType(n));
				render.addEventListener(MouseEvent.CLICK, onRenderClick);
			}
		}
		
		private function getType(n:int):int{
			switch(n){
				case 0:
					return 6;
				case 1:
					return 1;
				case 2:
					return 4;
				case 3:
					return 2;
				case 4:
					return 3;
				case 5:
					return 5;
				case 6:
//					return 7;
					return 9;
				case 7:
//					return 8;
					return 10;
			}
			return 0;
		}
		
		protected function onRenderClick(event:MouseEvent):void{
			var render:RankHeroItemRender = event.target as RankHeroItemRender;
			var type:int = render.type;
			if(type == 3){
				type = 4;
			}else if(type == 2){
				type = 3;
			}else if(type == 4){
				type = 2;
			}
			UIManager.getInstance().rankWnd.selectPageByType(type);
		}
		
		public function updateInfo(obj:Object):void{
			var yrankl:Object = obj.yrankl;
			for each(var render:RankHeroItemRender in renders){
				var typeData:Array = yrankl[render.type];
				if(null != typeData){
					render.updateInfo(typeData);
				}else{
					render.clearData();
				}
			}     
//			var yrankl:Object = obj.yrankl;
//			for(var type:String in yrankl){
//				var typeData:Array = yrankl[type];
//				var render:RankHeroItemRender = getItemByType(int(type));
//				render.updateInfo(typeData);
//			}
		}
		
		protected function getItemByType(type:int):RankHeroItemRender{
			for each(var render:RankHeroItemRender in renders){
				if((null != render) && (render.type == type)){
					return render;
				}
			}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
			return null;
		}
		
		public function requestInfo():void{
			Cmd_Rank.cm_RAK_Y();
		}
	}
}