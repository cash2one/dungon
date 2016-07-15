package com.leyou.data.crossServer {
	import com.ace.config.Core;
	import com.leyou.data.crossServer.children.CrossServerLvData;
	import com.leyou.data.crossServer.children.CrossServerMissionData;
	import com.leyou.enum.ConfigEnum;

	import flash.utils.getTimer;

	public class CrossServerData {
		// 我的国家数据
		public var myServerData:CrossServerLvData=new CrossServerLvData();

		// 国家数据列表
		public var serverList:Vector.<CrossServerLvData>=new Vector.<CrossServerLvData>();

		// 国家任务数据
		public var taskId:int;

		public var tnum:int;

		public var myrank:int;

		public var ptnum:int;

		public var stime:uint;

		public var rtime:int;

		private var tick:uint;

		public var st:Boolean;

		public var gname:String;

		// 任务排名
		public var taskRankList:Vector.<CrossServerMissionData>=new Vector.<CrossServerMissionData>();

		public var snl:Array;

		private var _openStatus:int=-1;

		public var remainCount:int;

		public function CrossServerData() {
		}

		public function isOpen():Boolean {
			return (1 == _openStatus);
		}

		public function remianTime():uint {
			return (rtime - (getTimer() - tick));
		}

		public function currentTime():Number {
			var interval:int=getTimer() - tick;
			return (stime * 1000 + interval);
		}

		public function loadData_I(obj:Object):void {
			myServerData.loadInfo(obj.mysinfo);
			var dataList:Array=obj.slist;
			var length:int=dataList.length;
			serverList.length=length;
			for (var n:int=0; n < length; n++) {
				var sData:CrossServerLvData=serverList[n];
				if (null == sData) {
					sData=new CrossServerLvData();
					serverList[n]=sData;
				}
				sData.loadInfo(dataList[n]);
			}
		}

		public function loadData_T(obj:Object):void {
			tick=getTimer();
			taskId=obj.taskid;
//			taskId = 1;
			tnum=obj.tnum;
			myrank=obj.myrank;
			ptnum=obj.ptnum;
			stime=obj.stime;
			st=(1 == obj.st);
			gname=obj.gname;

			var timeArr:Array=ConfigEnum.multiple2.split("|");
			var endArr:Array=ConfigEnum.multiple3.split("|");
			var serverDate:Date=new Date(stime * 1000);
			var startTick1:Date=new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(timeArr[0].split(":")[0]), int(timeArr[0].split(":")[1]));
			var endTick1:Date=new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(endArr[0].split(":")[0]), int(endArr[0].split(":")[1]));
			var startTick2:Date=new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(timeArr[1].split(":")[0]), int(timeArr[1].split(":")[1]));
			var endTick2:Date=new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(endArr[1].split(":")[0]), int(endArr[1].split(":")[1]));
			if ((serverDate.time >= startTick1.time) && (serverDate.time <= endTick1.time)) {
				rtime=endTick1.time - serverDate.time;
			} else if ((serverDate.time >= startTick2.time) && (serverDate.time <= endTick2.time)) {
				rtime=endTick2.time - serverDate.time;
			}
		}

		public function loadData_S(obj:Object):void {
			tick=getTimer();
			taskId=obj.taskid;
			tnum=obj.tnum;
			stime=obj.stime;
			st=(1 == obj.st);
			gname=obj.gname;

			var timeArr:Array=ConfigEnum.multiple2.split("|");
			var endArr:Array=ConfigEnum.multiple3.split("|");
			var serverDate:Date=new Date(stime * 1000);
			var startTick1:Date=new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(timeArr[0].split(":")[0]), int(timeArr[0].split(":")[1]));
			var endTick1:Date=new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(endArr[0].split(":")[0]), int(endArr[0].split(":")[1]));
			var startTick2:Date=new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(timeArr[1].split(":")[0]), int(timeArr[1].split(":")[1]));
			var endTick2:Date=new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(endArr[1].split(":")[0]), int(endArr[1].split(":")[1]));
			if ((serverDate.time >= startTick1.time) && (serverDate.time <= endTick1.time)) {
				rtime=endTick1.time - serverDate.time;
			} else if ((serverDate.time >= startTick2.time) && (serverDate.time <= endTick2.time)) {
				rtime=endTick2.time - serverDate.time;
			}
		}

		public function loadData_L(obj:Object):void {
			var tlist:Array=obj.tlist;
			if (null == tlist) {
				return;
			}
			var length:int=tlist.length;
			taskRankList.length=length;
			for (var n:int=0; n < length; n++) {
				var rankInfo:CrossServerMissionData=taskRankList[n];
				if (null == rankInfo) {
					rankInfo=new CrossServerMissionData();
					taskRankList[n]=rankInfo;
				}
				rankInfo.loadInfo(tlist[n]);
			}
		}

		public function loadData_K(obj:Object):void {
			_openStatus=obj.st;
			remainCount=obj.sdc;
			myServerData.lv=1;
			myServerData.masterName=obj.master;
			myServerData.boomValue=obj.fr;
			myServerData.serverName=obj.sname;
			var dataList:Array=obj.gxlist;
			var length:int=dataList.length;
			serverList.length=length;
			for (var n:int=0; n < length; n++) {
				var sData:CrossServerLvData=serverList[n];
				if (null == sData) {
					sData=new CrossServerLvData();
					serverList[n]=sData;
				}
				sData.loadOpenInfo(dataList[n]);
			}
		}

		public function loadData_G(obj:Object):void {
			snl=obj.sidlist.concat();
		}

		public function contains(sn:String):Boolean {
			if (null == snl)
				return false;
			return (-1 != snl.indexOf(sn));
		}
	}
}
