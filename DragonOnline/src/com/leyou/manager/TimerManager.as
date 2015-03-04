package com.leyou.manager {

	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class TimerManager {

		/**
		 *当前服务器时间
		 */
		public static var ServerTime:int=0;

		private var dic:Dictionary=new Dictionary(true);

		private var _i:int=0;

		private var time:int=1000;
		private static var starttime:int=0;
		private static var endtime:int=0;

		private static var _instance:TimerManager;
		private var _timer:Timer;

		public static var currentTime:int=0;

		public function TimerManager() {
			_timer=new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}

		public static function getInstance():TimerManager {
			if (_instance == null)
				_instance=new TimerManager();

			return _instance;
		}

		private function onTimer(e:TimerEvent):void {
			if (length() <= 0) {
				_timer.stop();
				_timer.reset();
			}

			currentTime=((getTimer() - starttime) / 1000);

			var func:Object;
			for each (func in dic) {
				if (func["fun"] != null && func["time"] != null)
					func["fun"](int((getTimer() - int(func["time"])) / 1000));
			}
			
		}

		public function add(f:Function, key:String=null):void {

			if (search(f))
				return;

			var func:Object={"fun": f, time: getTimer()};

			if (key == null) {
				dic[_i]=func;
				_i++;
			} else
				dic[key]=func;

			if (!_timer.running)
				_timer.start();


		}

		public function search(f:Function):Boolean {
			var _f:Object;
			for each (_f in dic) {
				if (_f["fun"] == f) {
					return true;
				}
			}

			return false;
		}

		public function remove(f:Function):void {
			var _f:String;
			for (_f in dic) {
				if (dic[_f]["fun"] == f) {
					dic[_f] == null;
					delete dic[_f];
					break;
				}
			}
		}

		public function removeBykey(key:String):void {
			var _f:String;
			for (_f in dic) {
				if (_f == key) {
					dic[_f] == null;
					delete dic[_f];
					break;
				}
			}
		}

		public function removeAll():void {
			var key:String;
			for (key in dic) {
				dic[key] == null;
				delete dic[key];
			}

			stop();
			reset();
		}
 

		public function start():void {
			_timer.start();
		}

		public function stop():void {
			_timer.stop();
		}

		public function reset():void {
			_timer.reset();
		}

		public function length():int {
			var i:int=0;
			var f:Object;
			for each (f in dic) {
				i++
			}

			return i;
		}

		public function setDelay(_d:int):void {
			_timer.delay=_d;
		}


		public static function set CurrentServerTime(i:int):void {
			ServerTime=i;
			currentTime=0;

			starttime=getTimer();

		}

		/**
		 *服务器的时间戳
		 * @return
		 *
		 */
		public static function get CurrentServerTime():int {
			return ServerTime;
		}

		/**
		 * 单前时间戳,  秒;
		 * @return
		 *
		 */
		public static function get CurrentTime():int {
			return (ServerTime + currentTime);
		}

	}
}
