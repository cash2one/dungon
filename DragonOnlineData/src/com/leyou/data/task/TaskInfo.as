package com.leyou.data.task {


	/**
	 *
		  tr -- 任务信息
			 tid -- 任务id
			 st  -- 任务状态(0：未完成 1：已完成 -1：可领取)
			 var -- 任务当前完成进度变量num

	 * @author Administrator
	 *
	 */
	public class TaskInfo {

		public var tr:String;
		public var tid:int;
		public var st:int;
		public var progressVar:int;

		
		public function TaskInfo() {
		}



	}
}
