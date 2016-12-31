package com.framework.ui.component
{
	import com.framework.ui.basic.sprite.CSprite;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Derek
	 */
	public class LogView extends CSprite
	{
		public function LogView(w : int, h : int, scrollBar : VerticalScrollBar)
		{
			super('', w, h);
			bg.setStyle(0x000000, 0.8);

			_textArea = new TextField();
			_textArea.width = w - 18;
			_textArea.height = h;
			_textArea.multiline = true;
			_textArea.wordWrap = true;

			_scrollBar = scrollBar;
			_scrollBar.blockSize = h;

			addChildEx(_textArea, 0, 0);
			addChildEx(_scrollBar, w - 18, 0);

			_scrollBar.x = w - 18;

			registerEventHandlers();
		}

		public function writeLog(color : String, message : String) : void
		{
			if (_htmlText != '') _htmlText += "<br />";
			_htmlText += "<font color='" + color + "'>" + message + "</font>";
			_textArea.htmlText = _htmlText;

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
		private var _htmlText : String = '';
		// @endregion
	}
}
