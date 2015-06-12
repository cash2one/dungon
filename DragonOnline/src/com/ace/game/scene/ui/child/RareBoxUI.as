package com.ace.game.scene.ui.child {
	import com.ace.ICommon.ILivingUI;
	import com.ace.config.Core;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.market.child.MarketGrid;

	public class RareBoxUI extends AutoSprite implements ILivingUI {
		private var desLbl:Label;

		private var nameLbl:Label;

		private var grids:Vector.<MarketGrid>;

		public function RareBoxUI() {
			super(LibManager.getInstance().getXML("config/ui/scene/titleBoxWnd.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			desLbl=getUIbyID("desLbl") as Label;
			nameLbl=getUIbyID("nameLbl") as Label;
			grids=new Vector.<MarketGrid>(3);
			for (var n:int=0; n < 3; n++) {
				var grid:MarketGrid=grids[n];
				if (null == grid) {
					grid=new MarketGrid();
					grids[n]=grid;
					grid.x=20 + n * 120;
					grid.y=89;
				}
				addChild(grid);
			}
//			updateInfo();
		}

		public function updateInfo():void {
		}

		public function showName(info:*):void {
			var nameStr:String = info.name;
			var beginIndex:int = nameStr.indexOf("(");
			var endIndex:int = nameStr.indexOf(")");
			nameLbl.text = nameStr.substr(0, beginIndex);
			var count:int = int(nameStr.substring(beginIndex+1, endIndex));
			var cid:int = (Core.isSF ? 30000 : 9945);
			var content:String = TableManager.getInstance().getSystemNotice(cid).content;
			content = StringUtil.substitute(content, count, ConfigEnum.BossBoxOpenCost);
			desLbl.htmlText = content;
			var sceneId:int = int(MapInfoManager.getInstance().sceneId);
			var copyInfo:TCopyInfo = TableManager.getInstance().getCopyInfoBySceneId(sceneId);
			if(null == copyInfo){
				throw new Error("副本宝箱表格填写错误");
			}
			grids[0].updataInfo({itemId:copyInfo.item5Data[0], count:copyInfo.item5Data[1]});
			grids[1].updataInfo({itemId:copyInfo.item6Data[0], count:copyInfo.item6Data[1]});
			grids[2].updataInfo({itemId:copyInfo.item7Data[0], count:copyInfo.item7Data[1]});
			
		}

		public function showPs(str:String):void {
		}

		public function showTitles(info:LivingInfo):void {
		}

		public function updataHp(info:LivingInfo):void {
		}

		public function updataPs(livingBase:LivingBase):void {
			x=livingBase.x - 180;
			y=livingBase.y - 2 * livingBase.bInfo.radius - 235;
		}
		
		override public function die():void {
			for each(var grid:MarketGrid in grids){
				grid.clear();
			}
			parent.removeChild(this);
		}
		
		public function get livingName():String{
			return null;
		}
		
		public function switchVisible($visible:Boolean):void{
		}
	}
}
