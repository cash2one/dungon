package com.leyou.ui.copy
{
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.utils.StringUtil;
	import com.leyou.net.cmd.Cmd_SCP;
	import com.leyou.ui.copy.child.CopyItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class StoryCopyWnd extends StoryCopyView
	{
		public function StoryCopyWnd(){
			super();
		}
		
		protected override function onButtonClick(event:MouseEvent):void{
			var n:String = event.target.name;
			switch(n){
				case "prevBtn":
					previousPage();
					break;
				case "nextBtn":
					nextPage();
					break;
				case "allPastBtn":
					// vip全部扫荡
					Cmd_SCP.cm_SCP_A(0);
					break;
			}
		}
		
		public function updateVipLv():void{
			var limit:int = DataManager.getInstance().vipData.getCopyVipLv();
			 if(Core.me && (Core.me.info.vipLv < limit)){
				 var vl:int = Core.me.info.vipLv;
				 var tipText:String = TableManager.getInstance().getSystemNotice(4605).content;
				 tipText = StringUtil.substitute(tipText, limit);
				 allPastBtn.setToolTip(tipText);
				 allPastBtn.setActive(false, 1, true);
			 }else{
				 var tt:String = TableManager.getInstance().getSystemNotice(4607).content;
				 tt = StringUtil.substitute(tt, limit);
				 allPastBtn.setToolTip(tt);
			 }
		}
		
		public function loadCopy(obj:Object):void{
			var cl:Array = obj.cl;
			var count:int = cl.length;
			items.length = count;
			for(var n:int = 0; n < count; n++){
				var copyData:Object = cl[n];
				var copy:CopyItem = items[n];
				if(null == copy){
					copy = new CopyItem();
					copy.loadData(copyData);
					pushItem(copy, n);
					continue;
				}
				copy.loadData(copyData);
			}
			var zjl:Object = obj.zjl;
			grids[0].updataInfo({itemId:65531, count:zjl.bg});
			grids[1].updataInfo({itemId:65533, count:zjl.energy});
			grids[2].updataInfo({itemId:65534, count:zjl.exp});
			grids[3].updataInfo({itemId:65535, count:zjl.money});
			updateVipLv();
			prevBtn.visible = (threshold > 0);
			nextBtn.visible = (threshold < (Math.ceil(items.length/4)-1)*600);
		}
		
		public function updateInfo(obj:Object):void{
			var item:CopyItem = items[obj.cid-1];
			item.loadData(obj);
		}
	}
}