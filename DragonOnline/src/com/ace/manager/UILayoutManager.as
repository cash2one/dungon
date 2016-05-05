package com.ace.manager {
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.manager.ReuseManager;
	import com.ace.gameData.manager.TableManager;
	import com.greensock.TweenLite;
	import com.leyou.ui.tools.RightTopWnd;
	import com.leyou.ui.tools.ToolsWnd;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class UILayoutManager {
		// 单列
		private static var instance:UILayoutManager;

		// 两两互斥的界面
		private static const MUTEX_WNDS:Array=[WindowEnum.ROLE, WindowEnum.AUTION, WindowEnum.STOREGE, WindowEnum.SHOP, WindowEnum.MARKET, WindowEnum.MAILL, WindowEnum.EQUIP];

		// 缓动时间
		private static const MOVE_SPEED:Number=0.2;

		// 面板间距
		public static const SPACE_X:Number=-18;
		public static const SPACE_Y:Number=5;

		// 单个界面的互斥
		private static var Mutex_Signle_Wnds:Object;

		// 界面缓动的起始位置
		private static var StartObjs:Object;

		// 关联界面
		private static var LinkWnds:Object;

		// 主界面对应的子界面
		private static var ChildrenWnds:Object;

		// 已占用快捷购买界面ID
//		private static var QuickBuyUIID:int;

		private static var OffsetX:int;

		private static var Offsets:Object;

		private static var holderBitmaps:Object;

		private static var holderBitmapPool:Vector.<Bitmap>;

		public static function getInstance():UILayoutManager {
			if (!instance)
				instance=new UILayoutManager();
			return instance;
		}

		//------------------------------------------------------------
		// 展位图使用情况:
		//				 a.涉及到将窗口放大缩小时使用占位图
		//				 b.当界面已经显示出来时并且不涉及放大缩小使用窗口本身
		//				 c.占位图循环使用
		//------------------------------------------------------------
		public function UILayoutManager() {
			init();
		}

		public function init():void {
			// 缓动占位位图对象
			holderBitmaps={};
			// 图像池
			holderBitmapPool=new Vector.<Bitmap>();

			//------------------------------------------------------------
			// 互斥界面注册
			//------------------------------------------------------------
			Mutex_Signle_Wnds={};
			Mutex_Signle_Wnds[WindowEnum.EQUIP]=[WindowEnum.AUTION, WindowEnum.STOREGE, WindowEnum.SHOP, WindowEnum.MARKET, WindowEnum.BACKPACK];

			//------------------------------------------------------------
			// 起始点注册,对应的按钮名称,找到起始点
			//------------------------------------------------------------
			var toolsWnd:ToolsWnd=UIManager.getInstance().toolsWnd;
			var rightTopWnd:RightTopWnd=UIManager.getInstance().rightTopWnd;
			StartObjs={};
			StartObjs[WindowEnum.AUTION]=toolsWnd.getUIbyID("shiCBtn");
			StartObjs[WindowEnum.BACKPACK]=toolsWnd.getUIbyID("backpackBtn");
			StartObjs[WindowEnum.MARKET]=toolsWnd.getUIbyID("shopBtn");
			StartObjs[WindowEnum.ROLE]=toolsWnd.getUIbyID("playerBtn");
			StartObjs[WindowEnum.TEAM]=toolsWnd.getUIbyID("teamBtn");
			StartObjs[WindowEnum.TASK]=toolsWnd.getUIbyID("missionBtn");
			StartObjs[WindowEnum.GUILD]=toolsWnd.getUIbyID("guildBtn");
			StartObjs[WindowEnum.EQUIP]=toolsWnd.getUIbyID("duanZBtn");
			StartObjs[WindowEnum.SKILL]=toolsWnd.getUIbyID("skillBtn");
			StartObjs[WindowEnum.GEM_LV]=toolsWnd.getUIbyID("alchmyBtn");
			StartObjs[WindowEnum.BADAGE]=toolsWnd.getUIbyID("wenZBtn");
			StartObjs[WindowEnum.SHIYI]=toolsWnd.getUIbyID("fittingBtn");
			StartObjs[WindowEnum.FRIEND]=toolsWnd.getUIbyID("friendBtn");
			StartObjs[WindowEnum.PET]=toolsWnd.getUIbyID("mercenaryBtn");
			StartObjs[WindowEnum.COLLECTION]=toolsWnd.getUIbyID("collectBtn");
			StartObjs[WindowEnum.FARM]=toolsWnd.getUIbyID("framBtn");
			StartObjs[WindowEnum.ELEMENT]=toolsWnd.getUIbyID("eleBtn");
			StartObjs[WindowEnum.WORSHIP]=toolsWnd.getUIbyID("worshipBtn");
			StartObjs[WindowEnum.MAILL]=UIManager.getInstance().smallMapWnd.getUIbyID("mailBtn");
//			StartObjs[WindowEnum.FARM]=rightTopWnd.getWidget("farmBtn");
			StartObjs[WindowEnum.COPY_RANK]=rightTopWnd.getWidget("copyRBtn");
//			StartObjs[WindowEnum.STORYCOPY]=rightTopWnd.getWidget("storyCopyBtn");
//			StartObjs[WindowEnum.BOSSCOPY]=rightTopWnd.getWidget("bossCopyBtn");
			StartObjs[WindowEnum.BOSS]=rightTopWnd.getWidget("bossCopyBtn");
			StartObjs[WindowEnum.ARENA]=rightTopWnd.getWidget("arenaBtn");
			StartObjs[WindowEnum.MYSTORE]=rightTopWnd.getWidget("shopBtn");
			StartObjs[WindowEnum.TOPUP]=rightTopWnd.getWidget("firstPayBtn");
//			StartObjs[WindowEnum.FIELDBOSS]=rightTopWnd.getWidget("fieldBossBtn");
			StartObjs[WindowEnum.DRAGON_BALL]=rightTopWnd.getWidget("fieldBossBtn");
//			StartObjs[WindowEnum.EXPCOPY]=rightTopWnd.getWidget("expCopyBtn");
			StartObjs[WindowEnum.WELFARE]=rightTopWnd.getWidget("welfareBtn");
			StartObjs[WindowEnum.PKCOPY]=rightTopWnd.getWidget("deliveryBtn");
			StartObjs[WindowEnum.RANK]=rightTopWnd.getWidget("rankBtn");
			StartObjs[WindowEnum.ACTIVE]=rightTopWnd.getWidget("activityBtn");
			StartObjs[WindowEnum.ACHIEVEMENT]=rightTopWnd.getUIbyID("achievementBtn");
			StartObjs[WindowEnum.LUCKDRAW]=rightTopWnd.getWidget("lotteryBtn");
			StartObjs[WindowEnum.VIP3EXP]=rightTopWnd.getWidget("v3expBtn");
			StartObjs[WindowEnum.CLIENT_WND]=rightTopWnd.getWidget("v0");
			StartObjs[WindowEnum.CDKEY]=rightTopWnd.getWidget("keyBtn");
			StartObjs[WindowEnum.PAY_PROMOTION]=rightTopWnd.getWidget("promotionBtn");
			StartObjs[WindowEnum.TOBE_STRONG]=rightTopWnd.getWidget("tobeStrong");
//			StartObjs[WindowEnum.FIRST_PAY]=rightTopWnd.getWidget("firstPayBtn");
			StartObjs[WindowEnum.SEVENDAY]=rightTopWnd.getWidget("sevenDBtn");
			StartObjs[WindowEnum.AREA_CELEBRATE]=rightTopWnd.getWidget("areaCelebrate");
			StartObjs[WindowEnum.INVEST]=rightTopWnd.getWidget("investBtn");
			StartObjs[WindowEnum.FIRST_RETURN]=rightTopWnd.getWidget("firstReturnBtn");
			StartObjs[WindowEnum.PAY_RANK]=rightTopWnd.getWidget("payRankBtn");
			StartObjs[WindowEnum.ONLINDREWARD]=rightTopWnd.getWidget("onlineBtn");
			StartObjs[WindowEnum.GUILD_BATTLE]=rightTopWnd.getWidget("guildBattleBtn");
			StartObjs[WindowEnum.QQ_VIP]=rightTopWnd.getWidget("tecentVipBtn");
			StartObjs[WindowEnum.QQ_YELLOW]=rightTopWnd.getWidget("qqYellowBtn");
			StartObjs[WindowEnum.COLLECTION]=rightTopWnd.getWidget("collectBtn");
			StartObjs[WindowEnum.INTEGRAL]=rightTopWnd.getWidget("costBtn");
			StartObjs[WindowEnum.ABIDE_PAY]=rightTopWnd.getWidget("abidePayBtn");
			StartObjs[WindowEnum.DUNGEON_TEAM]=rightTopWnd.getWidget("teamCopyBtn");
			StartObjs[WindowEnum.GROUP_BUY]=rightTopWnd.getWidget("groupBuyBtn");
			StartObjs[WindowEnum.VENDUE]=rightTopWnd.getWidget("saleBtn");
			StartObjs[WindowEnum.LEGENDAREY_WEAPON]=rightTopWnd.getWidget("legendaryBtn");
			StartObjs[WindowEnum.BLACK_STROE]=rightTopWnd.getWidget("blackStoreBtn");
//			StartObjs[WindowEnum.PET]=rightTopWnd.getWidget("petBtn");
			StartObjs[WindowEnum.TASK_MARKET]=rightTopWnd.getWidget("taskMarketBtn");
			StartObjs[WindowEnum.KEEP_7]=rightTopWnd.getWidget("sevenDayBtn");
			StartObjs[WindowEnum.TTT]=rightTopWnd.getWidget("towerBtn");
			StartObjs[WindowEnum.LABA]=rightTopWnd.getWidget("gambleBtn");

			//------------------------------------------------------------
			// 关联界面注册,格式:
			//					界面枚举:[排版顺序枚举数组]
			//------------------------------------------------------------
			LinkWnds={};
			LinkWnds[WindowEnum.AUTION]=[WindowEnum.AUTION, WindowEnum.BACKPACK];
			LinkWnds[WindowEnum.MAILL]=[WindowEnum.MAILL, WindowEnum.BACKPACK];
			LinkWnds[WindowEnum.ROLE]=[WindowEnum.ROLE, WindowEnum.BACKPACK, WindowEnum.GEM_LV];
			LinkWnds[WindowEnum.BACKPACK]=[WindowEnum.ROLE, WindowEnum.BACKPACK, WindowEnum.MAILL, WindowEnum.AUTION, WindowEnum.GEM_LV];
			LinkWnds[WindowEnum.STOREGE]=[WindowEnum.STOREGE, WindowEnum.BACKPACK];
			LinkWnds[WindowEnum.SHOP]=[WindowEnum.SHOP, WindowEnum.BACKPACK];
			LinkWnds[WindowEnum.LABA_DESC]=[WindowEnum.LABA, WindowEnum.LABA_DESC];

			//------------------------------------------------------------
			// 子界面注册,格式:
			//				  界面枚举:[子界面枚举数组]
			//------------------------------------------------------------
			ChildrenWnds={};
			ChildrenWnds[WindowEnum.ROLE]=[WindowEnum.MOUTLVUP, WindowEnum.MOUTTRADEUP, WindowEnum.MEDIC, WindowEnum.WING_FLY, WindowEnum.WINGLVUP, WindowEnum.QUICK_BUY, WindowEnum.MARRY4];
			ChildrenWnds[WindowEnum.SKILL]=[WindowEnum.RUNE, WindowEnum.QUICK_BUY];
			ChildrenWnds[WindowEnum.BACKPACK]=[WindowEnum.SELLEXPEFFECT];
			ChildrenWnds[WindowEnum.EQUIP]=[WindowEnum.QUICK_BUY];
			ChildrenWnds[WindowEnum.MAILL]=[WindowEnum.MAILL_READ];
			ChildrenWnds[WindowEnum.PET]=[WindowEnum.QUICK_BUY];
			ChildrenWnds[WindowEnum.LUCKDRAW]=[WindowEnum.LUCKDRAW_STORE];
			ChildrenWnds[WindowEnum.ELEMENT]=[WindowEnum.ELEMENT_UPGRADE, WindowEnum.QUICK_BUY];


			Offsets={};
		}

		private function getFreeBitmap():Bitmap {
			var bmp:Bitmap=holderBitmapPool.pop();
			if (null == bmp) {
				bmp=new Bitmap();
			}
			return bmp;
		}

		private function freeBitmap(bmp:Bitmap):void {
			LayerManager.getInstance().windowLayer.removeChild(bmp);
			if (-1 == holderBitmapPool.indexOf(bmp)) {
				if (null != bmp.bitmapData) {
					bmp.bitmapData.dispose();
					bmp.bitmapData=null;
				}
				bmp.scaleX=1;
				bmp.scaleY=1;
				holderBitmapPool.push(bmp);
			}
		}

		private function creeatHolder(dis:DisplayObject, dname:String):Bitmap {
			var bitmap:Bitmap=holderBitmaps[dname];
			if (null == bitmap) {
				bitmap=getFreeBitmap();
				holderBitmaps[dname]=bitmap;
				bitmap.bitmapData=new BitmapData(dis.width, dis.height, true, 0);
			}

			bitmap.bitmapData.draw(dis);
			LayerManager.getInstance().windowLayer.addChild(bitmap);
			return bitmap;
		}

		private function nvlHolder(id:int):Bitmap {
			var dis:DisplayObject=UIManager.getInstance().creatWindow(id);
			var bitmap:Bitmap=holderBitmaps[id];
			if (null == bitmap) {
				bitmap=getFreeBitmap();
				holderBitmaps[id]=bitmap;
				bitmap.bitmapData=new BitmapData(dis.width, dis.height, true, 0);
			}
			bitmap.bitmapData.draw(dis);
			LayerManager.getInstance().windowLayer.addChild(bitmap);
			return bitmap;
		}

		private function getHolder(id:int):Bitmap {
			return holderBitmaps[id];
		}

		private function freeHolder(key:String):void {
			var bitmap:Bitmap=holderBitmaps[key];
			if (null != bitmap) {
				holderBitmaps[key]=null;
				freeBitmap(bitmap);
			}
		}

		/**
		 * 缓动一个显示对象
		 *
		 * @param dispaly 要操作的显示对象
		 * @param mod     操作模式 1 -- 显示 2 -- 隐藏
		 * @param linkPt 缓动开始点
		 * @param scale   是否采用缩放
		 *
		 */
		public function singleMove(dispaly:DisplayObject, dname:String, mod:int, startPt:Point=null, endPt:Point=null):void {
			var ex:int;
			var ey:int;
			var holder:Bitmap=creeatHolder(dispaly, dname);
			if (1 == mod) {
				TweenLite.killTweensOf(dispaly);
				dispaly.scaleX=1;
				dispaly.scaleY=1;
				if (null == endPt) {
					ex=(UIEnum.WIDTH - dispaly.width) * 0.5;
					ey=(UIEnum.HEIGHT - dispaly.height) * 0.5;
				} else {
					ex=endPt.x;
					ey=endPt.y;
				}
				holder.width=40;
				holder.height=40;
				holder.alpha=0.1;
				if (null == startPt) {
					holder.x=(UIEnum.WIDTH - dispaly.width) * 0.5;
					holder.y=(UIEnum.HEIGHT - dispaly.height) * 0.5;
				} else {
					holder.x=startPt.x;
					holder.y=startPt.y;
				}
				TweenLite.to(holder, MOVE_SPEED, {alpha: 1, scaleX: 1, scaleY: 1, x: ex, y: ey, onComplete: onShowMoveOver})
			} else if (2 == mod) {
				if (null == startPt) {
					ex=(UIEnum.WIDTH - 40) * 0.5;
					ey=(UIEnum.HEIGHT - 40) * 0.5;
				} else {
					ex=startPt.x;
					ey=startPt.y;
				}
				if (dispaly.hasOwnProperty("hide")) {
					dispaly["hide"]();
				} else {
					dispaly.visible=false;
				}
				TweenLite.to(holder, MOVE_SPEED, {alpha: 0, width: 40, height: 40, x: ex, y: ey, onComplete: onHideMoveOver});
			}

			// 缓动显示完成
			function onShowMoveOver():void {
				if (dispaly.hasOwnProperty("show")) {
					dispaly["show"]();
				} else {
					dispaly.visible=true;
				}
				dispaly.x=holder.x;
				dispaly.y=holder.y;
				freeHolder(dname);
				GuideManager.getInstance().resize();
			}

			// 缓动完毕隐藏
			function onHideMoveOver():void {
				dispaly.x=holder.x;
				dispaly.y=holder.y;
				freeHolder(dname);
			}
		}

		/**
		 * 重新排列一个界面的所有关联界面
		 *
		 * @param id 界面枚举
		 *
		 */
		public function composingWnd(id:int):void {
			// 生成关联枚举列表
			var ids:Array=generateRelatedId(id);
			// 剔除隐藏项
			for (var n:int=ids.length - 1; n >= 0; n--) {
				var wnd:Object=UIManager.getInstance().getWindow(ids[n]);
				if ((null == wnd) || !wnd.visible) {
					ids.splice(n, 1);
				}
			}

			// 重排界面
			composing(ids, true);
		}

		/**
		 * 布局隐藏函数
		 *
		 * @param id 窗口编号
		 *
		 */
		public function hide(id:int, chlidid:int=-1):void {
			if (-1 == chlidid) {
				// 隐藏主界面
				hideMian(id);
				return;
			}
			// 隐藏子界面
			hideChlid(id, chlidid);
		}

		private function hideChlid(id:int, chlidid:int):void {
			// 生成关联枚举列表
			var ids:Array=generateRelatedId(id);
			for (var m:int=ids.length - 1; m >= 0; m--) {
				var wnd:Object=UIManager.getInstance().getWindow(ids[m]);
				// 找到子界面并直接隐藏
				if (chlidid == ids[m]) {
					UIManager.getInstance().hideWindow(chlidid);
				}
				// 是否隐藏中
				if ((null == wnd || !wnd.visible)) {
					ids.splice(m, 1);
				}
			}
			// 调整各个界面位置
			composing(ids);
		}

		public function hideMian(id:int):void {
			// 立即关闭主界面的所有子界面
			closeChlid(id);
			// 开始隐藏缓动
			hideMove(id);
			// 生成调整关联列表
			var ids:Array=generateLinkIds_II(id, id);
			// 调整关联界面的位置
			composing(ids);
		}

		/**
		 * 关闭主界面的所有子界面
		 *
		 * @param id 主界面枚举
		 *
		 */
		private function closeChlid(id:int):void {
			var ids:Array=ChildrenWnds[id] || [];

			// 快捷购买界面特殊处理
//			var qi:int = ids.indexOf(WindowEnum.QUICK_BUY);
//			if((-1 != qi) && (QuickBuyUIID != id)){
//				ids.splice(qi, 1);
//			}

			var c:int=ids.length;
			for (var n:int=0; n < c; n++) {
				UIManager.getInstance().hideWindow(ids[n]);
			}
		}

		/**
		 * 关闭缓动
		 *
		 * @param id 界面枚举
		 *
		 */
		public function hideMove(id:int):void {
			var wnd:DisplayObject=UIManager.getInstance().getWindow(id);
			if (null == wnd || !wnd.visible) {
				return;
			}
			var point:Point;
			// 获得缓动起始点数组
			if (!isLinkBtn(id)) {
				// 没有绑定按钮以屏幕中心为终点
				point=new Point();
				point.x=(UIEnum.WIDTH - 40) * 0.5;
				point.y=(UIEnum.HEIGHT - 40) * 0.5;
			} else {
				// 绑定按钮状态下以按钮位置为起点
				var display:DisplayObject=StartObjs[id];
				point=display.localToGlobal(new Point(0, 0));
			}
			// 向起始点缓动
			var moveDis:DisplayObject=nvlHolder(id);
			TweenLite.killTweensOf(moveDis);
			UIManager.getInstance().hideWindow(id);
//			if (wnd.hasOwnProperty("startHide")) {
//				wnd.startHide();
//			}
			TweenLite.to(moveDis, MOVE_SPEED, {alpha: 0, width: 40, height: 40, x: point.x, y: point.y, onComplete: onHideMoveOver, onCompleteParams: [id]});
		}

		private function onHideMoveOver(id:int):void {
			var holder:Bitmap=getHolder(id);
			if (null == holder) {
				return;
			}
//			LayerManager.getInstance().windowLayer.removeChild(holder);
			freeHolder(String(id));
		}

		//------------------------------------------------------------
		// 南鼎吕添加
		public function open_II(id:int, chlidid:int=-1, $offsetX:int=0, $offsetY:int=0):void {
			var rid:int=(-1 == chlidid) ? id : chlidid;
			var wnd:Object=UIManager.getInstance().creatWindow(rid);
			if (wnd.visible) {
				hide(id, chlidid);
			} else {
				show_II(id, chlidid, $offsetX, $offsetY);
			}
		}

		public function show_II(id:int, childid:int=-1, $offsetX:int=0, $offsetY:int=0):void {

//			callbackShow(id, childid, $offsetX, $offsetY);
//			return ;
			var wnd:Object

			if (-1 == childid) {

				wnd=UIManager.getInstance().creatWindow(id);
				UIManager.getInstance().slidesWndArr[id]=true;
				UIManager.getInstance().slidesWnd.setEffectVisiable(true);
				wnd.sendOpenPanelProtocol(show, id, childid, $offsetX, $offsetY);
				return;
			}

			show(id, childid, $offsetX, $offsetY);
		}

		//------------------------------------------------------------

		/**
		 * 布局显示
		 *
		 * @param id 窗口编号
		 *
		 */
		public function show(id:int, childid:int=-1, $offsetX:int=0, $offsetY:int=0):void {
			// 快捷购买特殊处理
//			if(WindowEnum.QUICK_BUY == childid){
//				QuickBuyUIID = id;
//			}
			OffsetX=$offsetX;
//			offsetY=$offsetY;
			if (-1 == childid) {
				// 调用主界面显示
//				trace("------------------------------show window.(id=" + id + ")")
				showMian(id);
				ReuseManager.getInstance().imgSyLoader.priorityLoad(TableManager.getInstance().getModuleRes(id));
				return;
			}
			// 调用主界面的子界面显示
//			trace("------------------------------show window.(id=" + childid + ")")
			if (null == Offsets[childid]) {
				Offsets[childid]=$offsetX;
			}
			showChild(id, childid);
		}

		/**
		 * 显示子界面
		 *
		 * @param mianId  子界面所属主界面枚举
		 * @param chlidId 子界面枚举
		 *
		 */
		private function showChild(mianId:int, chlidId:int):void {
			// 重置要显示的窗口的起始缓动状态
			prepareWnd(chlidId);
			// 生成关联枚举列表
			var ids:Array=generateClildIds(mianId, chlidId);
			// 调整关联界面的位置
			composing(ids);
			// 显示出要显示的窗口
//			UIManager.getInstance().showWindow(chlidId, true, 1, false);
		}

		/**
		 * 生成主界面的关联枚举列表
		 *
		 * @param mianId
		 * @param chlidId
		 * @return
		 *
		 */
		private function generateClildIds(mianId:int, chlidId:int):Array {
			// 生成关联枚举列表
			var ids:Array=generateRelatedId(mianId);
			for (var m:int=ids.length - 1; m >= 0; m--) {
				// 不是要显示的子界面
				if (chlidId != ids[m]) {
					// 是否隐藏中
					var wnd:Object=UIManager.getInstance().getWindow(ids[m]);
					if ((null == wnd || !wnd.visible /*此判断条件不严谨，以后改*/ || (WindowEnum.QUICK_BUY == ids[m]))) {
						ids.splice(m, 1);
					}
				}
			}
			return ids;
		}

		/**
		 * 主界面的显示方法
		 *
		 * @param id 界面枚举
		 *
		 */
		private function showMian(id:int):void {
			// 关闭互斥界面
			mutexWnd(id);
			// 重置要显示的窗口的起始缓动状态
			prepareWnd(id);
			// 生成关联枚举列表
			var ids:Array=generateLinkIds(id, id);
			// 调整关联界面的位置
			composing(ids);
			// 显示界面
//			UIManager.getInstance().showWindow(id, true, 1, false);
		}

		/**
		 * 根据主窗口枚举,找到相关联的窗口枚举
		 *
		 * @param id      主窗口枚举
		 * @param childid 强制加入的子界面枚举,若没有只返回已显示出来的
		 * @return        关联的窗口枚举列表并包含自身
		 *
		 */
		private function generateLinkIds(id:int, ... childid):Array {
			// 生成关联枚举列表
			var ids:Array=generateRelatedId(id);
			// 连接子界面枚举
//			ids=ids.concat(ChildrenWnds[id] || []);
			for (var m:int=ids.length - 1; m >= 0; m--) {
				// 是否在强制加入列表
				if (-1 == childid.indexOf(ids[m])) {
					// 是否隐藏中
					var wnd:Object=UIManager.getInstance().getWindow(ids[m]);
					if ((null == wnd) || !wnd.visible /*此判断条件不严谨，以后改*/ || (WindowEnum.QUICK_BUY == ids[m])) {
						ids.splice(m, 1);
					}

				}
			}
			return ids;
		}

		/**
		 * 根据主窗口枚举,找到相关联的窗口枚举
		 *
		 * @param id      主窗口枚举
		 * @param childid 强制删除的界面枚举,若没有只返回已显示出来的
		 * @return        关联的窗口枚举列表并包含自身
		 *
		 */
		private function generateLinkIds_II(id:int, ... childid):Array {
			// 生成关联枚举列表
			var ids:Array=generateRelatedId(id);
			for (var m:int=ids.length - 1; m >= 0; m--) {
				if (-1 != childid.indexOf(ids[m]) /*此判断条件不严谨，以后改*/ || (WindowEnum.QUICK_BUY == ids[m])) {
					// 是否在强制删除列表
					ids.splice(m, 1);
					continue;
				}
				// 是否隐藏中
				var wnd:Object=UIManager.getInstance().getWindow(ids[m]);
				if ((null == wnd || !wnd.visible)) {
					ids.splice(m, 1);
				}
			}
			return ids;
		}

		/**
		 * 生成关联枚举列表
		 *
		 * @param id 主界面枚举
		 * @return   和主界面有关联的所有窗口枚举
		 *
		 */
		private function generateRelatedId(id:int):Array {
			// 获得关联界面枚举
			var ids:Array=LinkWnds[id] || [id];
			ids=ids.concat();
			// 放入关联界面的子界面枚举
			var tmpIds:Array=[];
			var c:int=ids.length;
			for (var n:int=0; n < c; n++) {
				var mainId:int=ids[n];
				tmpIds.push(mainId);
				tmpIds=tmpIds.concat(ChildrenWnds[mainId] || []);
			}

			return tmpIds;
		}

		/**
		 * 准备要缓动的起始状态
		 *
		 * @param id
		 *
		 */
		private function prepareWnd(id:int):void {
			var bitmap:Bitmap=nvlHolder(id);
			bitmap.width=40;
			bitmap.height=40;
			bitmap.alpha=0.1;
			var wnd:DisplayObject=UIManager.getInstance().creatWindow(id);
			TweenLite.killTweensOf(wnd);
//			wnd.width=40;
//			wnd.height=40;
//			wnd.alpha=0.1;
		}

		/**
		 * 隐藏互斥界面
		 *
		 * @param id 要互斥的界面ID
		 *
		 */
		private function mutexWnd(id:int):void {
			// 是否存在于两两互斥列表中
			var index:int=MUTEX_WNDS.indexOf(id);
			if (-1 != index) {
				var length:int=MUTEX_WNDS.length;
				for (var n:int=0; n < length; n++) {
					if (n != index) {
						UIManager.getInstance().hideWindow(MUTEX_WNDS[n]);
					}
				}
			}

			// 检测是否存在于单个互斥列表
			var arr:Object=Mutex_Signle_Wnds[id];
			if (null != arr) {
				var l:int=arr.length;
				for (var m:int=0; m < l; m++) {
					UIManager.getInstance().hideWindow(arr[m]);
				}
			}
		}

		/**
		 * 开启界面,若子界面枚举不为-1,则开启子界面
		 *
		 * @param id      主界面枚举
		 * @param chlidid 子界面枚举
		 *
		 */
		public function open(id:int, chlidid:int=-1, $offsetX:int=0, $offsetY:int=0):void {
			var rid:int=(-1 == chlidid) ? id : chlidid;
			var wnd:Object=UIManager.getInstance().creatWindow(rid);
			if (wnd.visible) {
				hide(id, chlidid);
			} else {
				show(id, chlidid, $offsetX, $offsetY);
			}
		}

		/**
		 * 根据枚举列表的顺序进行位置排版
		 *
		 * @param ids 枚举列表
		 *
		 */
		public function composing(ids:Array, compos:Boolean=false):void {
			// 停止所有缓动,并重置参数,防止计算新坐标错误
			stopAll(ids);
			// 获得缓动起始点数组
			var spArr:Array=getStartPoints(ids);
			/** 获得结束点数组*/
			var epArr:Array=getEndPoints(ids);
			// 开始缓动
			startMove(ids, spArr, epArr, compos);
		}

		/**
		 * 将界面从起始点缓动到结束点
		 *
		 * @param ids   缓动的界面枚举数组
		 * @param spArr 缓动的起始坐标数组
		 * @param epArr 缓动的结束坐标数组
		 * @param indexes 指定缓动强制缩放的索引
		 *
		 */
		private function startMove(ids:Array, spArr:Array, epArr:Array, composing:Boolean=false):void {
			if (ids.length != spArr.length || ids.length != epArr.length) {
				throw new Error("windows move error");
			}

			var l:int=ids.length;
			for (var n:int=0; n < l; n++) {
				var id:int=ids[n];
				var moveObj:DisplayObject;
				var wnd:DisplayObject=UIManager.getInstance().creatWindow(id);
				moveObj=wnd;
				var sPoint:Point=spArr[n];
				var ePoint:Point=epArr[n];
				if (sPoint.equals(ePoint)) {
					continue;
				}
				if (!wnd.visible) {
					moveObj=nvlHolder(id);
				}
				moveObj.x=sPoint.x;
				moveObj.y=sPoint.y;
//				var index:int = wnd.toString().indexOf("::");
//				var wName:String = wnd.toString().substr(index+2);
//				trace(StringUtil.substitute("----------------------move wnd.name = {1}, startPoint = [{3},{4}], endPoint = [{5},{6}]",wName, sPoint.x, sPoint.y, ePoint.x, ePoint.y));
				TweenLite.to(moveObj, MOVE_SPEED, {alpha: 1, scaleX: 1, scaleY: 1, x: ePoint.x, y: ePoint.y, onComplete: onMoveOver, onCompleteParams: [id, wnd.visible]});
			}

		}

		private function onMoveOver(id:int, visible:Boolean):void {
			var holder:Bitmap=getHolder(id);

			var wnd:DisplayObject=UIManager.getInstance().creatWindow(id);
			if (null != holder) {
				wnd.x=holder.x;
				wnd.y=holder.y;
//				var index:int = wnd.toString().indexOf("::");
//				var wName:String = wnd.toString().substr(index+2);
//				trace(StringUtil.substitute("----------------------set wnd.name = {1}, finalPostition = [{5},{6}]",wName, holder.x, holder.y));
				freeHolder(String(id));
			}
			if (!visible) {
				UIManager.getInstance().showWindow(id, true, 1, false);
			}
			GuideManager.getInstance().resize();
		}

		/**
		 * 停止所有缓动
		 *
		 * @param ids 界面枚举数组
		 *
		 */
		private function stopAll(ids:Array):void {
			var l:int=ids.length;
			for (var n:int=0; n < l; n++) {
				var moveObj:DisplayObject;
				moveObj=UIManager.getInstance().creatWindow(ids[n]);
				if (!moveObj.visible) {
					moveObj=getHolder(ids[n]);
				}
				TweenLite.killTweensOf(moveObj);
//				var wnd:DisplayObject=UIManager.getInstance().creatWindow(ids[n]);
//				var index:int = wnd.toString().indexOf("::");
//				var wName:String = wnd.toString().substr(index+2);
//				trace("-------------------------kill wnd move. name ="+wName)
			}
		}

		/**
		 * 获得结束点数组
		 *
		 * @param ids 窗口枚举数组
		 * @return
		 *
		 */
		private function getEndPoints(ids:Array):Array {
			var y:int=0; // 界面的统一纵坐标
			var fy:int=0;
			var tw:int=0; // 界面总宽度
			var l:int=ids.length;
//			trace("----------------------layout width begin");
			for (var n:int=0; n < l; n++) {
				var wnd:Object=UIManager.getInstance().creatWindow(ids[n]);
				// 计算坐标时应先恢复原始大小
//				var cScaleX:Number=wnd.scaleX;
//				var cScaleY:Number=wnd.scaleY;
//				wnd.scaleX=1;
//				wnd.scaleY=1;
				OffsetX=Offsets[ids[n]];
				// ------------test
//				var index:int = wnd.toString().indexOf("::");
//				var wName:String = wnd.toString().substr(index+2);
//				trace("----------------------wnd.name = "+wName+" --wnd.width = " + wnd.width+" --wnd.height = "+wnd.height);
				// 开始结算
				tw+=wnd.width + OffsetX;
				var ty:int=(UIEnum.HEIGHT - wnd.height) * 0.5;
				if ((0 == y) || fy > ty) { // 选一个最小的
					fy=ty;
					y=fy + wnd.height;
				}
					// 计算完毕,置为原状态
//				wnd.scaleX=cScaleX;
//				wnd.scaleY=cScaleY;
			}
//			trace("----------------------layout width end, height begin");
			tw-=int(Offsets[ids[0]]);
			var pArr:Array=[]; // 坐标数组
			for (var m:int=0; m < l; m++) {
				var cwnd:Object=UIManager.getInstance().creatWindow(ids[m]);
				// 计算坐标时应先恢复原始大小
//				var ccScaleX:Number=cwnd.scaleX;
//				var ccScaleY:Number=cwnd.scaleY;
//				cwnd.scaleX=1;
//				cwnd.scaleY=1;
				// 开始计算
				var x:int=(UIEnum.WIDTH - tw) * 0.5;
				var yy:int=y - cwnd.height;
				pArr.push(new Point(x, yy));
				OffsetX=Offsets[ids[m + 1]];
				tw-=(cwnd.width + OffsetX) * 2;
//				var index:int = cwnd.toString().indexOf("::");
//				var wName:String = cwnd.toString().substr(index+2);
//				trace("----------------------wnd.name = "+wName+" --wnd.width = " + cwnd.width+" --wnd.height = "+cwnd.height);
					// 计算完毕,置为原状态
//				cwnd.scaleX=ccScaleX;
//				cwnd.scaleY=ccScaleY;
			}
//			trace("----------------------layout height end");
			return pArr;
		}

		/**
		 * 获得缓动的起始点
		 *
		 * @param ids  窗口列表
		 * @return     坐标数组
		 *
		 */
		private function getStartPoints(ids:Array):Array {
			var pArr:Array=[]; // 坐标数组
			var x:int, y:int=0;
			var l:int=ids.length;
			for (var n:int=0; n < l; n++) {
				var wnd:Object=UIManager.getInstance().creatWindow(ids[n]);
				// 正在显示状态下从当前点开始缓动
				if (wnd.visible) {
					pArr.push(new Point(wnd.x, wnd.y));
					continue;
				}
				// 隐藏状态下
				if (!isLinkBtn(ids[n])) {
					// 没有绑定按钮以屏幕中心为起点
					x=(UIEnum.WIDTH - 40) * 0.5;
					y=(UIEnum.HEIGHT - 40) * 0.5;
					pArr.push(new Point(x, y));
				} else {
					// 绑定按钮状态下以按钮位置为起点
					var display:DisplayObject=StartObjs[ids[n]];
					pArr.push(display.localToGlobal(new Point(0, 0)));
				}
			}
			return pArr;
		}

		/**
		 * 是否有绑定按钮
		 *
		 * @param id 窗口编号
		 * @return   有木有
		 *
		 */
		private function isLinkBtn(id:int):Boolean {
			return (null != StartObjs[id]);
		}
	}
}
