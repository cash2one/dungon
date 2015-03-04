package com.leyou.data.achievement
{
	import com.ace.gameData.manager.TableManager;

	public class AchievementData
	{
		// 是否有数据
		public var empty:Boolean = true;
		
		// 信息所属服务器ID
		public var serverId:String;
		
		// 服务器列表
		private var serverIds:Vector.<String> = new Vector.<String>();
		
		// 完成的成就数据列表
		private var eraDataArr:Vector.<AchievementEraData> = new Vector.<AchievementEraData>();
		
		// 风云任务数据列表
		private var roleDataArr:Vector.<AchieveRoleData> = new Vector.<AchieveRoleData>();
		
		// 焦点角色进度数据
		private var selfProgressArr:Vector.<AchievementRoleProgressData> = new Vector.<AchievementRoleProgressData>();
		
		public function AchievementData(){
		}
		
		public function get roleDataCount():int{
			return roleDataArr.length;
		}
		
		public function get serverCount():int{
			return serverIds.length;
		}
		
		public function clear():void{
			for each(var era:AchievementEraData in eraDataArr){
				era.dispose();
			}
			for each(var role:AchieveRoleData in roleDataArr){
				role.dispose();
			}
			serverIds.length = 0;
			eraDataArr.length = 0;
			roleDataArr.length = 0;
		}
		
		public function pushServerId(ids:Array):void{
			for each(var id:String in ids){
				serverIds.push(id);
			}
			serverId = serverIds[0];
			empty = false;
		}
		
		public function getServerId(index:int):String{
			if(index >= 0 && index < serverIds.length){
				return serverIds[index];
			}
			return null;
		}
		
		public function getEraData(id:int):AchievementEraData{
			for each(var data:AchievementEraData in eraDataArr){
				if(data.tid == id){
					return data;
				}
			}
			return null;
		}
		
		public function getRoleData(index:int):AchieveRoleData{
			if(index >= 0 && index < roleDataArr.length){
				return roleDataArr[index];
			}
			return null;
		}
		
		public function getMyProgressData(id:int):AchievementRoleProgressData{
			for each(var data:AchievementRoleProgressData in selfProgressArr){
				if(data.id == id){
					return data;
				}
			}
			return null;
		}
		
		public function getProgress():String{
			return eraDataArr.length + "/" + TableManager.getInstance().achievementCount;
		}
		
		public function loadData_I(obj:Object):void{
			serverId = obj.cid;
			var hl:Array = obj.hl;
			var l:int = hl.length;
			eraDataArr.length = l;
			for(var n:int = 0; n < l; n++){
				var sdata:Array = hl[n];
				var tdata:AchievementEraData = eraDataArr[n];
				if(null == tdata){
					tdata = new AchievementEraData();
					eraDataArr[n] = tdata;
				}
				tdata.serverId = serverId;
				tdata.unserialize(sdata);
			}
			var myl:Array = obj.myl;
			var ml:int =  myl.length;
			selfProgressArr.length = ml;
			for(var m:int = 0; m < ml; m++){
				var mData:Array = myl[m];
				var tmData:AchievementRoleProgressData = selfProgressArr[m];
				if(null == tmData){
					tmData = new AchievementRoleProgressData();
					selfProgressArr[m] = tmData;
				}
				tmData.unserialize(mData);
			}
		}
		
		public function loadData_R(obj:Object):void{
			serverId = obj.cid;
			var rl:Array = obj.rl;
			var l:int = rl.length;
			roleDataArr.length = l;
			for(var n:int = 0; n < l; n++){
				var sdata:Object = rl[n];
				var tdata:AchieveRoleData = roleDataArr[n];
				if(null == tdata){
					tdata = new AchieveRoleData();
					roleDataArr[n] = tdata;
				}
				tdata.serverId = serverId;
				tdata.unserialize(sdata);
			}
		}
	}
}