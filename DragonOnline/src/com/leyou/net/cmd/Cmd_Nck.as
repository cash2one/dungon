package com.leyou.net.cmd {

	import com.ace.manager.LayerManager;
	import com.ace.manager.UIManager;
	import com.leyou.net.NetGate;
	import com.leyou.ui.title.child.TitleObtain;


	/**
	隐藏称号		//隐藏全部称号
	上行：nck|H
	下行：nck|{"mk":"H",s:0}
	s==状态,0是隐藏,1显示

	 * @author Administrator
	 *
	 */
	public class Cmd_Nck {


		public function Cmd_Nck() {

		}

		public static function sm_Nck_I(o:Object):void {
			if (!o.hasOwnProperty("mlist"))
				return;

			UIManager.getInstance().roleWnd.updateTitleList(o);
		}

		/**
		 *	打开称号界面:
	上行: nck|I
	下行：nck|{"mk":"I",totalfight:"",fight:"",curNckid:id,"mlist":[["id":id,"time":time]]}

	id==titleid
	time=开启时间
	curnck==当前称号id
	totalfight==总战斗力
	fight=累计战斗力

	title_type:		1.人物历程：		显示一个
			2.身份象征：		显示一个
			3.竞技排名：		全部显示
		 *
		 */
		public static function cm_NckInit():void {
			NetGate.getInstance().send("nck|I");
		}

		/**
		 *获得称号

			下行：nck|{"mk":"G","id":id,"time":time}
		 *
		 */
		public static function sm_Nck_G(o:Object):void {
			if (!o.hasOwnProperty("curNckid"))
				return;
			
			var tob:TitleObtain=new TitleObtain();
			
			LayerManager.getInstance().windowLayer.addChild(tob);
			tob.showPanel(o);
			
			cm_NckInit();
		}

		public static function sm_Nck_S(o:Object):void {
			if (!o.hasOwnProperty("curNckid"))
				return;

			UIManager.getInstance().roleWnd.titlePanel.updateStartNick(o);
		}

		/**
		 *	启用称号
	上行：nck|S,id
	下行：nck|{"mk":"S",totalfight:"",fight:"",curNckid:id,"time":time}
		 *
		 */
		public static function cm_NckStart(id:int):void {
			NetGate.getInstance().send("nck|S," + id);
		}

		public static function sm_Nck_T(o:Object):void {
			if (!o.hasOwnProperty("id"))
				return;
			
			UIManager.getInstance().roleWnd.titlePanel.updateLastTime(o);
		}
		
		public static function sm_Nck_N(o:Object):void {
			if (!o.hasOwnProperty("id"))
				return;
			
			UIManager.getInstance().roleWnd.titlePanel.updateProgress(o);
		}
		
		/**
		 *-------------------------------------------
称号时间
nck|Tid
npc|{"id":id,"time":time}
   id -- 称号id
   time -- 称号剩余时间 （0为无剩余时间 ） 
		 * @param id
		 * 
		 */ 
		public static function cm_NckLastTime(id:int):void {
			NetGate.getInstance().send("nck|T" + id);
		}

		public static function sm_Nck_U(o:Object):void {
			if (!o.hasOwnProperty("curNckid"))
				return;

			UIManager.getInstance().roleWnd.titlePanel.updateUninstall(o);
		}

		/**
		 *卸下称号		// 只能卸下 人物历程类，身份象征类称号
	上行：nck|U,id
	下行：nck|{"mk":"U",totalfight:"",fight:"",id:id}
		 *
		 */
		public static function cm_NckUninstall(id:int):void {
			NetGate.getInstance().send("nck|U," + id);
		}
		
		/**
		 *----------------------------------------------------
-- 请求称号计数
nck|Ntid
npc|{mk:"N","id":id,"count":num} 
		 * @param id
		 * 
		 */		
		public static function cm_NckProgress(id:int):void {
			NetGate.getInstance().send("nck|N," + id);
		}
		
	}
}
