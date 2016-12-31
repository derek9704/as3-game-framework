package com.framework.ui.component
{
	import com.framework.ui.basic.canvas.CCanvas;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * @author Derek
	 */
	public class InputTextView extends CCanvas
	{
		public function InputTextView(w : int, h : int, scrollbar : VerticalScrollBar)
		{
			super(w, h);
			bg.setStyle(0x000000, 0.8);

			var format : TextFormat = new TextFormat();
			format.color = 0xffffff;

			_textArea = new TextField();
			_textArea.defaultTextFormat = format;
			_textArea.width = w - 18;
			_textArea.height = h;
			_textArea.multiline = true;
			_textArea.wordWrap = true;
			_textArea.type = TextFieldType.INPUT;

			_textArea.addEventListener(TextEvent.TEXT_INPUT, scroll);
			_scrollBar = scrollbar;
			_scrollBar.blockSize = h;

			addChildEx(_textArea, 0, 0);
			addChildEx(_scrollBar, w - 18, 0);

			_scrollBar.x = w - 18;

			registerEventHandlers();
		}

		/**
		 * 文本类型
		 */
		public function set type(val : String) : void
		{
			_textArea.type = val;
		}

		private function scroll(event : Event) : void
		{
			onTextAreaChanged(null);

			var newValue : Number = _scrollBar.total - _scrollBar.blockSize;
			if (newValue < 0) newValue = 0;
			_scrollBar.currentValue = newValue;
		}

		// @region Private methods
		private function registerEventHandlers() : void
		{
			// 文本滚动
			_textArea.addEventListener(Event.SCROLL, onTextAreaScroll);
			_textArea.addEventListener(MouseEvent.MOUSE_WHEEL, onTextAreaScroll);

			// 滚动条滚动
			_scrollBar.addEventListener(Event.SCROLL, onScrollBarScroll);
		}

		// @endregion
		// @region Event Handlers
		private function onTextAreaScroll(e : Event) : void
		{
			_scrollBar.currentValue = _textArea.scrollV;
		}

		private function onScrollBarScroll(e : Event) : void
		{
			_textArea.scrollV = _scrollBar.currentValue;
		}

		private function onTextAreaChanged(e : Event) : void
		{
			_scrollBar.total = _textArea.maxScrollV + _textArea.height;
		}

		// @endregion
		// @region Private members
		private var _textArea : TextField;
		private var _scrollBar : VerticalScrollBar;

		public function get text() : String
		{
			return _textArea.text;
		}

		public function set text(val : String) : void
		{
			_textArea.text = val;
			onTextAreaChanged(null);
		}

		public function get textArea() : TextField
		{
			return _textArea;
		}
		// @endregion
	}
}
