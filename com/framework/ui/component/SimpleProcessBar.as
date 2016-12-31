package com.framework.ui.component
{
	import com.framework.ui.basic.sprite.CSprite;

	import flash.display.Shape;

	/**
	 * @author derek
	 */
	public class SimpleProcessBar extends CSprite
	{
		public function SimpleProcessBar(color : int, w : int, process : Function = null, finish : Function = null, h : int = 20, bgColor : uint = 0x5fcebf)
		{
			super('', w, h);

			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, 0, cWidth - 1, cHeight - 1);
			graphics.endFill();

			_line = new Shape();
			_line.graphics.beginFill(color);
			_line.graphics.drawRect(0, 0, cWidth - 2, cHeight - 2);
			_line.graphics.endFill();

			_len = w - 2;

			_finish = finish;
			_process = process;

			_line.height = h - 2;
			_line.width = 0;

			addChildEx(_line, 1, 1);
		}

		public function set value(pos : Number) : void
		{
			_curPos = pos;

			refresh();
		}

		public function get value() : Number
		{
			return _curPos;
		}

		private function refresh() : void
		{
			// 进度条的百分比
			var curPos : Number = _curPos;

			// 不能超过100%
			if (curPos > 100)
				curPos = 100;

			_line.width = int(_len * (curPos / 100));

			if (_process != null)
				_process(_curPos);

			if (_curPos == 100 && _finish != null)
				_finish();
		}

		private var _len : uint;
		private var _line : Shape;
		private var _curPos : Number;
		private var _finish : Function;
		private var _process : Function;
	}
}
