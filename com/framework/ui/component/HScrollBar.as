package com.framework.ui.component
{
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.ui.basic.sprite.DragParameters;
	import com.framework.ui.sprites.CImageButton;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 纵向滚动条
	 * 
	 * @author derek
	 */
	public class HScrollBar extends CSprite
	{
		private var _left : int;
		private var _right : int;
		private var _dp : DragParameters;
		private var _autoHide : Boolean;
		private var _line : DisplayObject;

		/**
		 * 构造函数
		 * 
		 * @param h 高度
		 * @param upBtn 上按钮mc
		 * @param downBtn 下按钮mc
		 * @param bg 背景
		 * @param block 滑块资源
		 * @param top 滑块到滚动条背景上方的偏移量
		 * @param bottom 滑块到滚动条背景下方的偏移量
		 * 
		 */
		public function HScrollBar(width : int, leftBtn : MovieClip, rightBtn : MovieClip, bg : DisplayObject, block : MovieClip, left : int = 0, right : int = 0, autoHide : Boolean = true, line : DisplayObject = null)
		{
			_leftButton = new CImageButton(leftBtn);
			_rightButton = new CImageButton(rightBtn);

			_background = bg;
			_block = block;
			_block.gotoAndStop(1);
			_block.addEventListener(MouseEvent.MOUSE_DOWN, function(event : MouseEvent) : void
			{
				_block.gotoAndStop(3);
				addStageEvent(MouseEvent.MOUSE_UP, onMouseDown);
			});
			_block.buttonMode = true;
			_block.mouseEnabled = true;

			_left = left;
			_right = right;
			_autoHide = autoHide;

			var height : int = _leftButton.height;
			if (_rightButton.height > height) height = _rightButton.height;
			if (_background.height > height) height = _background.height;
			if (_block.height > height) height = _block.height;

			super('', width, height);

			addChildEx(_leftButton);
			addChildEx(_rightButton);
			addChildEx(_background);

			if (line != null)
			{
				_line = line;
				_line.width = 0;
				addChildV(_line, _leftButton.cWidth + _left);
			}

			addChildV(_block);

			evts.addEventListener(Event.RESIZE, function(e : Event) : void
			{
				relayout();
			});

			evts.addedToStage(function(e : Event) : void
			{
				if (_dp != null) return;
				_dp = UiUtils.setupDragable(_block, true, false, true, false, 0, onMove);
				relayout();
			});

			_leftButton.click = onLeftButtonClick;
			_rightButton.click = onRightButtonClick;
		}
		
		private function onMouseDown(event : MouseEvent) : void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseDown);
			_block.gotoAndStop(1);
		}

		/**
		 * 当前值
		 */
		public function get currentValue() : Number
		{
			return _currentValue;
		}

		/**
		 * 当前值
		 */
		public function set currentValue(value : Number) : void
		{
			if (value > total)
				return;

			_currentValue = value;
			dispatchEvent(new Event(Event.SCROLL));
			relayout();
		}

		/**
		 * 滚动目标总值
		 */
		public function get total() : Number
		{
			return _total;
		}

		/**
		 * 滚动目标总值
		 */
		public function set total(value : Number) : void
		{
			_total = value;
			if (_currentValue > _total) _currentValue = _total;

			relayout();
		}

		/**
		 * 滑块大小
		 */
		public function get blockSize() : Number
		{
			return _blockSize;
		}

		/**
		 * 滑块大小
		 */
		public function set blockSize(value : Number) : void
		{
			_blockSize = value;
			relayout();
		}

		/**
		 * 重新调整界面位置
		 */
		private function relayout() : void
		{
			var width : int = cWidth;

			_rightButton.x = width - _rightButton.width;
			_background.x = _leftButton.width;
			_background.width = _rightButton.x - _background.x;
			if (_autoHide)
				visible = (_total > _blockSize) && enable;

			if (visible)
			{
				_block.x = int(currentValue / _total * scrollRange) + _background.x + _left;
				_block.width = int(_blockSize / _total * scrollRange);

				if (_line != null) _line.width = _block.x - _line.x;

				if (_dp != null)
				{
					_dp.rect.x = _leftButton.width + _left;
					_dp.rect.width = cWidth - _rightButton.width - _right - _block.width - _dp.rect.x;
				}
			}
		}

		/**
		 * 滑块可以滑动的范围
		 */
		private function get scrollRange() : Number
		{
			return _background.width - _left - _right;
		}

		/**
		 * 滑块移动的callback
		 */
		private function onMove(tx : int, ty : int) : void
		{
			_currentValue = (tx - _background.x - _left) / scrollRange * _total;
			dispatchEvent(new Event(Event.SCROLL));
		}

		/**
		 * 上按钮按下的回调函数
		 */
		private function onLeftButtonClick(e : Event) : void
		{
			var newValue : Number = _currentValue -= 12;
			if (newValue < 0) newValue = 0;

			currentValue = newValue;
		}

		/**
		 * 下按钮按下的回调函数
		 */
		private function onRightButtonClick(e : Event) : void
		{
			var newValue : Number = _currentValue += 12;
			var maxValue : Number = total - blockSize;

			if (maxValue <= 0) return;

			if (newValue > maxValue) newValue = maxValue;

			currentValue = newValue;
		}

		private var _currentValue : Number = 0;
		private var _total : Number = 0;
		private var _blockSize : Number = 100;
		private var _leftButton : CImageButton;
		private var _rightButton : CImageButton;
		private var _background : DisplayObject;
		private var _block : MovieClip;
	}
}
