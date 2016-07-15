/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-21 下午3:17:57
 */
package com.ace.ui.notice {
	import com.ace.config.Core;
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.tools.TimeCounter;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.reuse.ReuseDic;
	import com.ace.ui.notice.child.NoticeIcon;
	import com.ace.ui.notice.child.NoticeImgRender;
	import com.ace.ui.notice.child.NoticeRender;
	import com.ace.ui.notice.message.Message1;
	import com.ace.ui.notice.message.Message10;
	import com.ace.ui.notice.message.Message11;
	import com.ace.ui.notice.message.Message2;
	import com.ace.ui.notice.message.Message4;
	import com.ace.ui.notice.message.Message5;
	import com.ace.ui.notice.message.Message6;
	import com.ace.ui.notice.message.Message7;
	import com.ace.ui.notice.message.Message8;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;

	import flash.display.Sprite;

	/**
	 * 系统提示
	 * @author ace
	 *
	 */
	public class NoticeManager {
		private static var instance:NoticeManager;

		public static function getInstance():NoticeManager {
			if (!instance)
				instance=new NoticeManager();
			return instance;
		}

		public var noticelblReuseDic:ReuseDic;
		public var noticeImgReuseDic:ReuseDic;
		public var noticeIconReuseDic:ReuseDic;
		public var con:Sprite; //提示的容器
		public var callBackFun:Function; //单击文本后要回调的函数
		private var message1:Message1;
		private var message2:Message2;
		private var message4:Message4;
		private var message5:Message5;
		private var message6:Message6;
		private var message7:Message7;
		private var message8:Message8;
//		private var message9:Message9;
		private var message10:Message10;
		private var message11:Message11;

//		private var tick:uint;
		private var msgId:uint;
//		private var remainT:uint;
		private var timer:TimeCounter;
		private var onCountDown:Function;

		public function NoticeManager() {
		}

		private function init():void {
			this.noticelblReuseDic=new ReuseDic(NoticeRender, 100);
			this.noticeImgReuseDic=new ReuseDic(NoticeImgRender, 100);
			this.noticeIconReuseDic=new ReuseDic(NoticeIcon, 100);
			this.message7=new Message7();
			this.message8=new Message8();
			this.con.addChild(this.message7);
			this.con.addChild(this.message8);

			this.message1=new Message1();
			this.message2=new Message2();
			this.message4=new Message4();
			this.message5=new Message5();
			this.message6=new Message6();
//			this.message9=new Message9()
			this.message10=new Message10();
			this.message11=new Message11();
			this.timer=new TimeCounter();
		}

		/**
		 * 设置系统提示
		 * @param $con 要添加到的容器层
		 * @param fun  单击文本后要回调的函数
		 *
		 */
		public function setup($con:Sprite, fun:Function):void {
			this.con=$con;
			this.callBackFun=fun;
			this.init();
		}

		/**
		 * 直接提示
		 * @param id 提示ID
		 * @param values 附加数据
		 *
		 */
		public function broadcastById(id:int, values:Array=null):void {
			var notice:TNoticeInfo=TableManager.getInstance().getSystemNotice(id);
			broadcast(notice, values);
		}

		/**
		 * 广播消息
		 * @param type 消息类型
		 * @param notice 消息字符串
		 * @param values 消息字符串替换值
		 *
		 */
		public function broadcast(info:TNoticeInfo, values:Array=null):void {
			if (info.screenId1 > 0)
				this.ass(info.screenId1, info, values);
			if (info.screenId2 > 0)
				this.ass(info.screenId2, info, values);
			if (info.screenId3 > 0)
				this.ass(info.screenId3, info, values);

			if (Core.me)
				SoundManager.getInstance().play(Core.me.info.sex == PlayerEnum.SEX_BOY ? info.soundM : info.soundF);

			if (info.Low_Money > 0) {

				if (info.Low_Money == 5 && (MyInfoManager.getInstance().firstItem.fst == 0 || MyInfoManager.getInstance().firstItem.st == 0)) {
					if (MyInfoManager.getInstance().firstItem.fst == 0) {

						if (UIManager.getInstance().firstPay == null || !UIManager.getInstance().firstPay.visible) {
							UILayoutManager.getInstance().open(WindowEnum.FIRST_PAY);
						}

					} else if (MyInfoManager.getInstance().firstItem.st == 0) {

						if (UIManager.getInstance().topUpWnd == null || !UIManager.getInstance().topUpWnd.visible) {
							UILayoutManager.getInstance().open_II(WindowEnum.TOPUP);
						}
					}
				} else {

					if (Core.me.info.level < ConfigEnum.common9)
						return;

					UILayoutManager.getInstance().show(WindowEnum.INTROWND);

					TweenLite.delayedCall(0.3, function():void {
						UIManager.getInstance().introWnd.setTabIndex(info.Low_Money);
					});
				}
			}

		}

		public function broadcastMap(sceneId:String):void {
			message10.broadcast(sceneId);
		}

		/**
		 * 战斗力改变(滚动效果)
		 * @param value 战斗力数值
		 *
		 */
		public function rollToPower(value:int):void {
			UIManager.getInstance().roleHeadWnd.updateZDL(value);
//			message9.rollToNum(value);
		}

		/**
		 * 设置战斗力(直接显示)
		 * @param value 战斗力数值
		 *
		 */
//		public function setPower(value:int):void{
//			message9.setNum(value);
//		}

		public function ass(type:int, info:TNoticeInfo, values:Array=null):void {
			switch (type) {
				case NoticeEnum.TYPE_MESSAGER1:
					this.message1.broadcast(info.content, values);
					break;
				case NoticeEnum.TYPE_MESSAGER2:
					this.message2.broadcast(info.content, values);
					break;
				case NoticeEnum.TYPE_MESSAGER3:
					// 聊天栏显示
					break;
				case NoticeEnum.TYPE_MESSAGER4:
					this.message4.broadcast(info, values);
					break;
				case NoticeEnum.TYPE_MESSAGER5:
					this.message5.broadcast(info.content, values);
					break;
				case NoticeEnum.TYPE_MESSAGER6:
					this.message6.broadcast(info, values);
					break;
				case NoticeEnum.TYPE_MESSAGER7:
					this.message7.show(info.content, values);
					break;
				case NoticeEnum.TYPE_MESSAGER8:
					this.message8.broadcast(info, values);
					break;
				case NoticeEnum.TYPE_MESSAGER11:
					this.message11.broadcast(info, values);
					break;
				default:
					break;
			}
		}

		public function ass_II(type:int, content:String, values:Array=null):void {
			switch (type) {
				case NoticeEnum.TYPE_MESSAGER1:
					this.message1.broadcast(content, values);
					break;
				case NoticeEnum.TYPE_MESSAGER2:
					this.message2.broadcast(content, values);
					break;
				case NoticeEnum.TYPE_MESSAGER3:
					// 聊天栏显示
					break;
				case NoticeEnum.TYPE_MESSAGER4:
//					this.message4.broadcast(info, values);
					break;
				case NoticeEnum.TYPE_MESSAGER5:
					this.message5.broadcast(content, values);
					break;
				case NoticeEnum.TYPE_MESSAGER6:
//					this.message6.broadcast(info, values);
					break;
				case NoticeEnum.TYPE_MESSAGER7:
					this.message7.show(content, values);
					break;
				case NoticeEnum.TYPE_MESSAGER8:
//					this.message8.broadcast(info, values);
					break;
				case NoticeEnum.TYPE_MESSAGER11:
//					this.message11.broadcast(info, values);
					break;
				default:
					break;
			}
		}

		public function setMsgVisible(type:int, v:Boolean):void {
			switch (type) {
				case NoticeEnum.TYPE_MESSAGER1:
					break;
				case NoticeEnum.TYPE_MESSAGER2:
					break;
				case NoticeEnum.TYPE_MESSAGER3:
					// 聊天栏显示
					break;
				case NoticeEnum.TYPE_MESSAGER4:
					break;
				case NoticeEnum.TYPE_MESSAGER5:
					break;
				case NoticeEnum.TYPE_MESSAGER6:
					break;
				case NoticeEnum.TYPE_MESSAGER7:
					break;
				case NoticeEnum.TYPE_MESSAGER8:
					message8.visible=v;
					break;
				default:
					break;
			}
		}

		public function removeType(type:int):void {
			message8.removeType(type);
		}

		public function countdown($msgId:int, $remainT:int, $onCountDown:Function=null):void {
			msgId=$msgId;
			timer.startCounter($remainT * 1000, 800, countTimer, onCountDown);
			countTimer($remainT * 1000);
		}

		public function stopCount():void {
			timer.stopCounter();
		}

		private function countTimer(remain:int):void {
			broadcastById(msgId, [int(remain / 1000)]);
		}

		/**
		 * <T>界面尺寸重置</T>
		 *
		 */
		public function resize():void {
			this.message2.resize();
			this.message4.resize();
			this.message5.resize();
			this.message6.resize();
			this.message7.resize();
			this.message8.resize();
//			this.message9.resize();
			this.message10.resize();
			this.message11.resize();
		}
	}
}
