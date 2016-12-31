package com.brickmice.view.component
{
	import com.brickmice.Main;
	
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	/**
	 * 被封装的.更容易使用的文本输入框
	 * 
	 * @author derek
	 */
	public class BmInputBox
	{
		private var _max : int;
		private var _min : int;
		private var _mc : TextField;

		public function set max(value:int):void
		{
			_max = value;
		}
		
		/**
		 * 设置文本内容
		 */
		public function set text(value : String) : void
		{
			_mc.text = value;
			// 回调函数
			if (onNumChange != null)
				onNumChange(parseInt(value));
		}

		/**
		 * 当被isNumber被设置为true的时候.
		 * 文本框内部数字被改变的时候会回调本函数
		 * 格式 onNumChange(num:int):void;  num为新的数字
		 */
		public var onNumChange : Function;
		
		/**
		 * 封装之后的文本框
		 * 
		 * @param mc
		 * @param title 默认的显示内容
		 * @param maxChars 最大字符数. -1 为不限制
		 * @param isNumber 文本框内容是否为纯数字(纯数字不允许输入数字以外的内容).
		 * @param max 可以输入的最大值(isNumber = true 时才有效)
		 * @param min 可以输入的最小值(isNumber = true 时才有效)
		 */
		public function BmInputBox(mc:TextField, title : String, maxChars : int = -1, isNumber : Boolean = false, max : int = -1, min : int = -1)
		{
			_mc = mc;
			_max = max;
			_min = min;
			
			_mc.text = title;
			
			if (maxChars != -1)
				_mc.maxChars = maxChars;
			
			// 如果是数字输入框.则对输入进行验证.必须是合法内容
			if (isNumber)
			{
				_mc.addEventListener(KeyboardEvent.KEY_UP, function(event : KeyboardEvent) : void
				{
					// 获取输入内容
					var num : int = parseInt(_mc.text);
					
					// 对上下限进行调整
					if (num > _max && _max >= 0)
						num = _max;
					
					if (num < _min && _min >= 0)
						num = _min;
					
					// 设置回本内容
					_mc.text = num.toString();
					
					// 回调函数
					if (onNumChange != null)
						onNumChange(num);
				});
			}
		}
	}
}
