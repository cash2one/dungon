package com.leyou.ui.bossCopy {


	import com.leyou.ui.bossCopy.child.BossCopyRender;


	public class BossCopyWnd extends BossCopyView {

		public var remainCount:int;

		public function BossCopyWnd() {

		}

		public function loadCopy(obj:Object):void {
			clear();
			var challengeLimit:int=obj.cl;
			var bossList:Array=obj.cl;
			var length:int=bossList.length;
			for (var n:int=0; n < length; n++) {
				var item:BossCopyRender=new BossCopyRender();
				item.updateInfo(bossList[n]);
				if (!item.lock()) {
					selectedBoss=item;
					currentPage=Math.ceil((n + 1) / 3) - 1;
				}
				pushItem(item);
				if (n > 0) {
					item.prevRender=items[n - 1];
				}
			}
//			setToX((currentPage-1)*435);
			setToX(currentPage * 435);
			selectBoss(selectedBoss);
			showBoss(selectedBoss.bossData);
			selectedBoss.select=true;
			prevBtn.visible=(threshold > 0);
			nextBtn.visible=(threshold < (Math.ceil(items.length / 3) - 1) * 435);
		}

		public function updateChallengeCount(obj:Object):void {
			challengeLbl.text=obj.cc;
			cost=obj.cyb;
		}
	}
}
