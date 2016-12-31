package com.framework.ui.component
{
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.basic.sprite.CSprite;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 支持滚动的面板
	 * @author derek
	 */
	public class ScrollPanel extends CSprite
	{
		private var _panel : CCanvas;
		private var _mask : Shape;
		private var _scrollBar : VerticalScrollBar;
		private var _hScrollBar : HScrollBar;
		private var _wheelGap : int;
		private var _scrollCallBack : Function = null;
		private var _whellAbel : Boolean;

		/**
		 * 可滚动的PANEL.
		 * 
		 * @param name 名字
		 * @param width 宽度
		 * @param height 高度
		 * @param scrollBar 纵向滚动条
		 * @param hScrollBar 横向滚动条
		 * @param wheelGap 滚轮滚动的距离
		 * @param whellAbel 是否支持滚轮事件 
		 */
		public function ScrollPanel(name : String, width : int, height : int, scrollBar : VerticalScrollBar, hScrollBar : HScrollBar, wheelGap : int = 50, whellAbel : Boolean = true)
		{
			super(name, width, height);

			// 初始化PANEL
			// 所有的被加入的控件.都是加入到他上面的.
			// 由它来响应滚动条
			_panel = new CCanvas(width, height);
			addChildEx(_panel, 0);

			if (scrollBar == null)
				_scrollBar = new VerticalScrollBar(height, new MovieClip(), new MovieClip(), new MovieClip(), new MovieClip());
			else
				_scrollBar = scrollBar;

			if (hScrollBar == null)
				_hScrollBar = new HScrollBar(width, new MovieClip(), new MovieClip(), new MovieClip(), new MovieClip());
			else
				_hScrollBar = hScrollBar;

			// 加入2个滚动条
			_hScrollBar.cWidth = width;
			_hScrollBar.blockSize = width;
			_wheelGap = wheelGap;
			_whellAbel = whellAbel;
			addChildEx(_hScrollBar, 0, 0, CCanvas.lb);

			addChildEx(_scrollBar, 0, 0, CCanvas.rt);
			_scrollBar.cHeight = height;
			_scrollBar.blockSize = height;

			// 初始化MASK
			// MASK同scrollPanel一样大.用来隐藏超出范围的部分.
			_mask = new Shape();

			setMask();

			addChild(_mask);

			// 设置mask
			mask = _mask;

			// 注册滚动事件
			registerEventHandlers();
		}

		private function setMask() : void
		{
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0, 1, cWidth, cHeight);
			_mask.graphics.endFill();
		}

		public override function set cWidth(val : Number) : void
		{
			super.cWidth = val;
			_hScrollBar.cWidth = val;
			_hScrollBar.blockSize = val;

			resize();
			setMask();
		}

		public override function set cHeight(val : Number) : void
		{
			super.cHeight = val;
			_scrollBar.cHeight = val;
			_scrollBar.blockSize = val;

			resize();
			setMask();
		}

		public function get vScrollValue() : Number
		{
			return _scrollBar.currentValue;
		}

		public function set vScrollValue(value : Number) : void
		{
			if (value > _scrollBar.bgHeight)
			{
				value = 0;
			}
			_scrollBar.currentValue = value;
		}

		public function get scrollCallBack() : Function
		{
			return _scrollCallBack;
		}

		public function set scrollCallBack(value : Function) : void
		{
			_scrollCallBack = value;
		}

		/**
		 * 设置滚动条清空 回到最上端
		 */
		public function setScrollBarNull() : void
		{
			_scrollBar.currentValue = 0;
		}

		/**
		 * 设置滚动条最大 回到最下端
		 */
		public function setScrollBarFull() : void
		{
			_scrollBar.currentValue = _scrollBar.total - _scrollBar.blockSize;
		}
		
		/**
		 * 设置滚动条清空 回到最左端
		 */
		public function setHScrollBarNull() : void
		{
			_hScrollBar.currentValue = 0;
		}
		
		/**
		 * 设置滚动条最大 回到最右端
		 */
		public function setHScrollBarFull() : void
		{
			_hScrollBar.currentValue = _hScrollBar.total - _hScrollBar.blockSize;
		}

		/**
		 * 纵向滚动条是否可用
		 */
		public function set vScrollBarEnable(value : Boolean) : void
		{
			_scrollBar.enable = value;
		}

		/**
		 * 横向滚动条是否可用
		 */
		public function set hScrollBarEnable(value : Boolean) : void
		{
			_hScrollBar.enable = value;
		}

		/**
		 * 增加一个item到panel上
		 * 
		 * @param item 可显示的对象.应该继承自displayobject
		 */
		public function addItem(item : *, x : int = -1, y : int = -1) : void
		{
			if (x == -1)
				x = item.x;
			if (y == -1)
				y = item.y;

			_panel.addChildEx(item, x, y);

			// 获取item的高度(如果是CCanvas的子类.应该使用cHeight)
			var tHeight : int = item.hasOwnProperty('cHeight') ? item.cHeight : item.height;
			var tWidth : int = item.hasOwnProperty('cWidth') ? item.cWidth : item.width;

			// 如果新加入的item使panel变大了.则修改panel的高度
			if (tHeight + item.y > _panel.cHeight)
			{
				_panel.cHeight = tHeight + item.y;

				// 重设大小后滚动条部分的处理
				resetBar();
			}

			if (tWidth + item.x > _panel.cWidth)
			{
				_panel.cWidth = tWidth + item.x;

				// 重设大小后滚动条部分的处理
				resetBar();
			}
		}

		/**
		 * 重设滚动面板大小
		 */
		public function resize() : void
		{
			var len : int = _panel.numChildren;
			var maxHeight : int = _panel.cHeight;
			var maxWidth : int = _panel.cWidth;

			for (var i : int = 0; i < len; i++)
			{
				var item : * = _panel.getChildAt(i);
				var tHeight : int = item.hasOwnProperty('cHeight') ? item.cHeight : item.height;
				var tWidth : int = item.hasOwnProperty('cWidth') ? item.cWidth : item.width;

				if (item.y + tHeight > maxHeight)
					maxHeight = item.y + tHeight;

				if (item.x + tWidth > maxWidth)
					maxWidth = item.x + tWidth;
			}

			_panel.cHeight = maxHeight;
			_panel.cWidth = maxWidth;

			resetBar();
		}

		/**
		 * 滚动面板
		 */
		public function get panel() : CCanvas
		{
			return _panel;
		}

		/**
		 * 注册所有事件
		 */
		private function registerEventHandlers() : void
		{
			if (_whellAbel)
			{
				// 鼠标滚轮
				_panel.addEventListener(MouseEvent.MOUSE_WHEEL, onPanelScroll);
			}

			// 滚动条滚动
			_scrollBar.addEventListener(Event.SCROLL, onScrollBarScroll);

			// 滚动条滚动
			_hScrollBar.addEventListener(Event.SCROLL, onScrollBarScroll);
		}

		/**
		 * 当panel滚动的时候.修改滚动条滑块的位置
		 */
		private function onPanelScroll(e : MouseEvent) : void
		{
			// _scrollBar.currentValue = -_panel.y;
			// _hScrollBar.currentValue = -_panel.x;
			if (!_scrollBar.visible) return;
			if (e.delta > 0)
			{
				if (_scrollBar.currentValue <= _wheelGap)
				{
					_scrollBar.currentValue = 0;
				}
				else
				{
					_scrollBar.currentValue -= _wheelGap;
				}
			}
			if (e.delta < 0)
			{
//				trace(_scrollBar.currentValue, _scrollBar.total, _scrollBar.scrollRange, _scrollBar._downBtnHeight, _scrollBar._upBtnHeight, _wheelGap);

				if (_scrollBar.currentValue >= (_scrollBar.total - _scrollBar.scrollRange - _scrollBar._downBtnHeight - _scrollBar._upBtnHeight - _wheelGap))
				{
					_scrollBar.currentValue = _scrollBar.total - _scrollBar.scrollRange - _scrollBar._downBtnHeight - _scrollBar._upBtnHeight;
				}
				else
				{
					_scrollBar.currentValue += _wheelGap;
				}
			}

			if (_scrollCallBack != null)
				_scrollCallBack();
		}

		/**
		 * 当滚动滚动条的时候.修改panel的位置
		 */
		private function onScrollBarScroll(e : Event) : void
		{
			_panel.y = -_scrollBar.currentValue;
			_panel.x = -_hScrollBar.currentValue;

			if (_scrollCallBack != null)
				_scrollCallBack();
		}

		/**
		 * 当修改了panel的宽高的时候
		 * 处理滚动条的相应数据
		 */
		public function resetBar() : void
		{
			_scrollBar.total = _panel.cHeight;
			_hScrollBar.total = _panel.cWidth;

			// 对BRA进行长度调整
			if (_scrollBar.visible && _hScrollBar.visible)
			{
				_scrollBar.cHeight -= _hScrollBar.cHeight;
				_hScrollBar.cWidth -= _scrollBar.cWidth;

				_hScrollBar.total += _scrollBar.cWidth;
				_scrollBar.total += _hScrollBar.cHeight;
			}
			else
			{
				_scrollBar.cHeight = cHeight;
				_hScrollBar.cWidth = cWidth;
			}
		}
	}
}
