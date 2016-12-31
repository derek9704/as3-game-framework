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
	public class VerticalScrollBar extends CSprite
	{
		private var _top : Number;
		private var _bottom : Number;
		private var _dp : DragParameters;
		public var _upBtnHeight : Number;
		public var _downBtnHeight : Number;
		private var _dragHeight : Number;
		private var _dragY : Number;
		private var _bgHeight : Number;

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
		public function VerticalScrollBar(h : Number, upBtn : MovieClip, downBtn : MovieClip, bg : DisplayObject, block : MovieClip, top : Number = 0, bottom : Number = 0, upBtnHeight : Number = -1, downBtnHeight : Number = -1)
		{
			_upButton = new CImageButton(upBtn);
			_downButton = new CImageButton(downBtn);
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

			_upBtnHeight = upBtnHeight == -1 ? _upButton.height : upBtnHeight;
			_downBtnHeight = downBtnHeight == -1 ? _downButton.height : downBtnHeight;

			_top = top;
			_bottom = bottom;

			var w : Number = _upButton.width;
			if (_downButton.width > w) w = _downButton.width;
			if (_background.width > w) w = _background.width;
			if (_block.width > w) w = _block.width;

			super('', w, h);

			addChildH(_upButton);
			addChildH(_downButton);
			addChildH(_background);
			addChildH(_block);

			evts.addEventListener(Event.RESIZE, function(e : Event) : void
			{
				relayout();
			});

			evts.addedToStage(function(e : Event) : void
			{
				if (_dp != null) return;
				_dp = UiUtils.setupDragable(_block, true, true, false, false, 0, onMove);
				relayout();
			});

			_upButton.addEventListener(MouseEvent.CLICK, onUpButtonClick);
			_downButton.addEventListener(MouseEvent.CLICK, onDownButtonClick);
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
			_currentValue = int(value);
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

		public function get bgHeight() : Number
		{
			return _bgHeight;
		}

		/**
		 * 重新调整界面位置
		 */
		private function relayout() : void
		{
			var h : Number = cHeight;

			_downButton.y = h - _downButton.height;
			_background.y = _upButton.height;
			_background.height = _downButton.y - _background.y;
			_bgHeight = _total - h;

			_dragY = _upBtnHeight + _top;
			_dragHeight = h - _downBtnHeight - _bottom - _dragY;

			visible = (_total > _blockSize) && enable;

			if (visible)
			{
				_block.y = int(currentValue / _total * scrollRange) + _dragY + _top;

				_block.width = _block.width;
				_block.height = int(_blockSize / _total * scrollRange);

//				 if (_block.y + _block.height < _upButton.x + _upButton.height + _top)
//				 _block.y = _upButton.x + _upButton.height + _top;
//
//				 if (_block.y + _block.height > _downButton.y - _bottom)
//				 _block.y = _downButton.y - _block.height - _bottom;
				 
				if (_dp != null)
				{
					_dp.rect.y = _dragY;
					_dp.rect.height = cHeight - _upButton.height - _bottom - _dp.rect.y - _block.height;
				}
			}
		}

		/**
		 * 滑块可以滑动的范围
		 */
		public function get scrollRange() : Number
		{
			return _dragHeight - _top - _bottom;
		}

		/**
		 * 滑块移动的callback
		 */
		private function onMove(tx : int, ty : int) : void
		{
			// trace('ty:' + ty);
			// trace("dragY:" + _dragY);
			// trace('top' + _top);
			// trace('_dragHeight:' + _dragHeight);
			// trace('bottom:' + _bottom);
			// trace('total:' + _total);

			_currentValue = int((ty - _dragY - _top) / scrollRange * _total);
			dispatchEvent(new Event(Event.SCROLL));
		}

		/**
		 * 上按钮按下的回调函数
		 */
		private function onUpButtonClick(e : Event) : void
		{
			var newValue : Number = _currentValue -= 12;
			if (newValue < 0) newValue = 0;

			currentValue = newValue;
		}

		/**
		 * 下按钮按下的回调函数
		 */
		private function onDownButtonClick(e : Event) : void
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
		private var _upButton : CImageButton;
		private var _downButton : CImageButton;
		private var _background : DisplayObject;
		private var _block : MovieClip;
	}
}
