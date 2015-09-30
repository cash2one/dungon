package com.leyou.data.copyRank
{
	import com.leyou.data.copyRank.children.CopyRankItemData;

	public class CopyRankData
	{
		private var _type:int;
		
		private var _copyList:Vector.<CopyRankItemData> = new Vector.<CopyRankItemData>();
		
		public function CopyRankData(){
		}
		
		public function get type():int{
			return _type;
		}

		public function getLength():int{
			return _copyList.length;
		}
		
		public function getCopyByIndex(index:int):CopyRankItemData{
			return _copyList[index];
		}
		
		public function getCopyById(id:int):CopyRankItemData{
			for each(var item:CopyRankItemData in _copyList){
				if(item.id == id){
					return item;
				}
			}
			return null;
		}
		
		public function loadData(obj:Object):void{
			_type = obj.ctype;
			var dataArr:Array = obj.rankl;
			var length:int = dataArr.length;
			_copyList.length = length;
			for(var n:int = 0; n < length; n++){
				var itemData:CopyRankItemData = _copyList[n];
				if(null == itemData){
					itemData = new CopyRankItemData();
					_copyList[n] = itemData;
				}
				itemData.loadData(dataArr[n]);
			}
		}
	}
}