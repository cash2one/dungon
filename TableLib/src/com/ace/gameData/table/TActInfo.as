package com.ace.gameData.table {
	import com.ace.utils.StringUtil;

	public class TActInfo {
		//帧频，间隔时间
		//动作开始帧
		//动作结束帧
		//动作的帧频
		public var realName:String;
		public var startFrame:int; //起始帧
		public var endFrame:int; //结束帧
		public var preFrame:int; //如果有多方向，单方向上的帧数
		public var spaceFrame:int; //单方向上的空余帧
		public var keyFrame:int; //关键帧，主要是技能时用的
		private var _interval:int; //休息间隔帧频
		public var noDir:Boolean; //是否分方向

		public function TActInfo(info:XML=null) {
			if (info == null)
				return;
			this.realName=info.@realName;
			this.startFrame=info.@startFrame;
			this.endFrame=info.@endFrame;
			this.preFrame=info.@preFrame;
			this.spaceFrame=info.@spaceFrame;
			this.keyFrame=info.@hitTime;
			this.interval=info.@interval; // * int(UIEnum.FRAME / UIEnum.ACT_FRAME);
			//			this.interval/=2;

			this.noDir=StringUtil.intToBoolean(info.@noDir);
			if (this.noDir)
				this.endFrame=this.startFrame + this.preFrame - this.spaceFrame - 1;
		}

		public function get interval():int {
			return this._interval;
		}

//		public function get interval2():int {
//			return this._interval;
////			return 1000 / (UIEnum.ACT_FRAME - this._interval);
//		}

		public function set interval(value:int):void {
			this._interval=value;
		}

	}
}

/*

加载信息格式：
加载id、加载部位类型

图片格式：swf序列帧的，或者自定义格式
自定义格式
图片数量，图片偏移x、y，图片宽、高、图片数据；
播放信息格式：
//帧频(间隔帧)、每个动作的开始、结束帧
<id="11001" speed="">
<act="stand" startFrame="" endFrame="" preFrame="" spaceFrame=""/>
<act="walk" startFrame="" endFrame=""/>
<act="run" startFrame="" endFrame=""/>
……
</id>

实时加载接口类
函数：加载完毕(部位参数)

首先定义个“part”类
变量：part的图片数据，part的播放参数数据
函数：播放指定的动作

再定义人物“Model”类
变量：部位数组
函数：初始化要加载的内容，加载完毕接口

*/
