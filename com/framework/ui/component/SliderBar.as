package com.framework.ui.component
{
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.basic.sprite.DragParameters;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * 滑动条.
	 * 
	 * @author derek
	 */
	public class SliderBar extends CCanvas
	{
		private var _value : int;
		private var _max : int;
		private var _right : int;
		private var _left : int;
		private var _dp : DragParameters;
		private var _block : MovieClip;
		private var _onChange : Function;
		private var _line : DisplayObject;

		/**
		 * 构造函数
		 * 
		 * @param max 最大值
		 * @param width 宽度
		 * @param minBtnRes 最小按钮的资源
		 * @param maxBtnRes 最大按钮的资源
		 * @param leftBtn 减一按钮的资源
		 * @param rightBtn 加一按钮的资源
		 * @param bg 背景资源
		 * @param block 滑块资源
		 * @param left 滑块到左按钮的间隔
		 * @param right 滑块到右按钮的间隔
		 * @
		 */
		public function SliderBar(max : int, bg : DisplayObject, block : MovieClip, line : DisplayObject, onChange : Function, left : int = 0, right : int = 0)
		{
			super(bg.width, bg.height);

			// bg/line/block
			addChildEx(bg);
			addChildV(line, left);
			addChildV(block);

			// 记录偏移量
			_right = bg.width - right - block.width;
			_left = left;

			evts.addedToStage(function(e : Event) : void
			{
				_dp = UiUtils.setupDragable(block, true, false, true, false, 0, onMove);
			});

			_max = max;
			_block = block;
			_line = line;
			_onChange = onChange;
		}

		public function set max(val : int) : void
		{
			_max = val;

			value = value;
		}

		public function get max() : int
		{
			return _max;
		}

		public function set value(val : int) : void
		{
			// _currentValue = (ty - _dragY - _top) / scrollRange * _total;
			if (val < 0)
				val = 0;

			if (val > _max)
				val = _max;

			_value = val;

			_block.x = int((_value / _max) * (_right - _left) + _left);
			_line.width = _block.x - _left;

			if (_onChange != null)
				_onChange(val);
		}

		public function get value() : int
		{
			return _value;
		}

		private function onMove(tx : int, ty : int) : void
		{
			// _currentValue = (ty - _dragY - _top) / scrollRange * _total;
			_value = (_block.x - _left) / (_right - _left) * _max;
			_line.width = _block.x - _left;

			if (_onChange != null)
				_onChange(_value);
		}
	}
}
