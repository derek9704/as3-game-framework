package com.brickmice.view.component
{
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.DateUtils;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class BmTiming
	{
		private var _timeRemain : TextField;
		private var _timeNum : int;
		private var _timer : Timer;
		private var _timerOver : Function;
		private var _defaultStr : String;
		private var _everyTimeHandler : Function;
		private var _everyMinuteHandler : Function;
		private var _maxTime : int;
		private var _MinuteNow : int;

		/**
		 * 正数计时 
		 * @param txt
		 * @param timeStart 开始时间
		 * @param timeFinish 到顶时间 0为无限
		 * @param timerOver
		 * @param defauletStr
		 * 
		 */
		public function BmTiming(txt:TextField, timeStart : int = 0, timeFinish : int = 0, timerOver : Function = null, defauletStr : String = "--:--:--")
		{
			_timeRemain = txt;
			// 记录时间
			_timeNum = timeStart;
			_maxTime = timeFinish;
			_timerOver = timerOver;
			_defaultStr = defauletStr;

			// 通过timer来实现倒数
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			txt.addEventListener(Event.REMOVED_FROM_STAGE, function():void{
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			});
		}

		/**
		 * 设置时间
		 * @param time
		 */
		public function setTime(time : int = 0) : void
		{
			// 记录时间
			_timeNum = time;
		}

		/**
		 * 倒计时开始开关
		 */
		public function startTimer() : void
		{
			if (_timer.running)
				stopTimerWithoutCallBack();

			if(_timeNum >= _maxTime) {
				_timeNum = _maxTime;
				_timeRemain.text = DateUtils.toTimeString(_timeNum);
			}else{
				_timeRemain.text = DateUtils.toTimeString(_timeNum);
				_MinuteNow = int((_timeNum % 3600) / 60);
				_timer.start();				
			}
		}

		/**
		 * 停止计时，不派发结束事件 
		 */
		public function stopTimerWithoutCallBack() : void
		{
			_timeRemain.text = _defaultStr;
			_timer.stop();
		}

		/**
		 * 停止计时并派发结束事件
		 */
		public function stopTimer() : void
		{
			_timeRemain.text = _defaultStr;
			_timer.stop();

			if (_timerOver != null)
				_timerOver();
		}

		/**
		 * 设置结束回调函数
		 * @param fun
		 */
		public function set timerOver(fun : Function) : void
		{
			_timerOver = fun;
		}

		/**
		 * 获取当前剩余时间
		 * @return 
		 */
		public function get nowTime() : int
		{
			return _timeNum;
		}

		/**
		 * 设置倒计时文本颜色
		 */
		public function set textColor(value : uint) : void
		{
			_timeRemain.textColor = value;
		}

		/**
		 * 设置默认文本
		 * @param value
		 */
		public function set defaultStr(value : String) : void
		{
			_defaultStr = value;
		}

		/**
		 * timer控制函数
		 * @param evt
		 */
		private function timerHandler(evt : TimerEvent) : void
		{
			// 时间递增并转成小时制
			_timeNum += 1;
			_timeRemain.text = DateUtils.toTimeString(_timeNum);

			if (_everyTimeHandler != null)
				_everyTimeHandler();
			
			if (_everyMinuteHandler != null){
				var min:int = int((_timeNum % 3600) / 60);
				if(_MinuteNow != min){
					_MinuteNow = min;
					_everyMinuteHandler();
				}
			}
			

			// 停止timer
			if (_maxTime && _timeNum >= _maxTime)
			{
				stopTimer();
			}
		}

		public function set everyTimeHandler(fun : Function) : void
		{
			_everyTimeHandler = fun;
		}
		
		//注意 容易造成反复刷新
		public function set everyMinuteHandler(fun : Function) : void
		{
			_everyMinuteHandler = fun;
		}
	}
}