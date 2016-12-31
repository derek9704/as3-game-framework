package com.brickmice.view.component
{
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.DateUtils;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class BmCountDown
	{
		private var _timeRemain : TextField;
		private var _timeNum : int;
		private var _timer : Timer;
		private var _timerOver : Function;
		private var _defaultStr : String;
		private var _everyTimeHandler : Function;

		public function BmCountDown(txt:TextField, time : int = 0, timerOver : Function = null, defauletStr : String = "--:--:--")
		{
			_timeRemain = txt;
			_timeRemain.text = defauletStr;
			// 记录时间
			_timeNum = time;
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

			if (_timeNum != 0)
			{
				_timeRemain.text = DateUtils.toTimeString(_timeNum);
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
			// 时间递减并转成小时制
			_timeNum -= 1;
			_timeRemain.text = DateUtils.toTimeString(_timeNum);

			if (_everyTimeHandler != null)
				_everyTimeHandler();

			// 停止timer
			if (_timeNum <= 0)
			{
				stopTimer();
			}
		}

		public function set everyTimeHandler(fun : Function) : void
		{
			_everyTimeHandler = fun;
		}
	}
}