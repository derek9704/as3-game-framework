package com.framework.ui.component
{
	import com.framework.ui.basic.sprite.CSprite;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	/**
	 * 进度条
	 * 
	 * @author derek
	 */
	public class ProcessBar extends CSprite
	{
		/**
		 * 构造函数
		 * 
		 * @param bgDo 进度条背景
		 * @param lineDo bar的背景
		 * @param maskDo 遮罩(可以为空.遮罩会位于bar上层.提供一些.显示的效果)
		 * @param border 边线宽度.
		 * @param width 宽度
		 * @param height 高度
		 * @param process 进度改变的callback:格式为 process(value:Number):void; value = 当前进度(取值范围 0 - 1).
		 * @param finish 进度条走到100%的时候的回调函数.格式为 finish():void;
		 */
		public function ProcessBar(bgDo : DisplayObject, lineDo : DisplayObject, maskDo : Bitmap, border : int, width : int, height : int, process : Function, finish : Function)
		{
			super('', width, height);
			bgDo.width = width;
			bgDo.height = height;

			// 背景

			addChild(bgDo);
			// 最大长度

			_len = width - border * 2;

			// 2个CALLBACK
			_finish = finish;
			_process = process;

			// bar
			_line = lineDo;

			// 默认 = 0
			_line.width = 0;
			_line.height = height - border * 2;

			// 加入BAR

			addChildEx(_line, border, border);

			// 如果有MASK.则加入之
			if (maskDo != null)
			{
				maskDo.width = _len;
				maskDo.height = _line.height;
				addChildEx(maskDo, border, border);
			}
		}

		/**
		 * 设置值进度.取值范围: 0 - 1 ; 0.5为中间
		 */
		public function set value(pos : Number) : void
		{
			_curPos = pos;

			refresh();
		}

		/**
		 * 获取当前值.
		 * 值范围 0 - 1
		 */
		public function get value() : Number
		{
			return _curPos;
		}

		/**
		 * 根据当前值刷新BAR
		 */
		private function refresh() : void
		{
			// 不能超过100%
			if (_curPos > 1)
				_curPos = 1;

			// 修改bar长度
			_line.width = int(_len * _curPos);

			// CALLBACK
			if (_process != null)
				_process(_curPos);

			if (_curPos == 1 && _finish != null)
				_finish();
		}

		/**
		 * 最大长度
		 */
		private var _len : uint;
		/**
		 * bar
		 */
		private var _line : DisplayObject;
		/**
		 * 当钱位置
		 */
		private var _curPos : Number;
		/**
		 * 完成的CALLBACK
		 */
		private var _finish : Function;
		/**
		 * PROCESS的CALLBACK
		 */
		private var _process : Function;
	}
}
