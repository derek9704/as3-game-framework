package com.brickmice.view.component.chat
{	
	
	import com.framework.utils.FilterUtils;
	
	import fl.controls.UIScrollBar;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class RichTextArea extends Sprite
	{
		public var _textField:RichTextField;
		private var _scrollBar:UIScrollBar;
		private var _cacheText:String = "";
		private var _index:int = 0;
		private var _bg:ResChatBg;
		
		public function RichTextArea(width : int, height : int)
		{	
			_textField = new RichTextField(width, height);
			_textField.autoScroll = true;
			_textField.filters = [FilterUtils.createGlow(0xF2EDC8, 500)];
			addChild(_textField);
			
			_scrollBar = new UIScrollBar;			
			_scrollBar.scrollTarget = _textField.textfield;
			_scrollBar.x = _textField.x + _textField.width;
			_scrollBar.y = _textField.y;
			_scrollBar.height = height;	
			addChild(_scrollBar);	
		}
		
		public function sizeChange(width : int, height : int):void
		{
			_textField.resize(width, height);
			_scrollBar.height = height;
		}
		
		public function scrollToEnd():void
		{
			if (_textField.textfield.maxScrollV > 1)_textField.textfield.scrollV = _textField.textfield.maxScrollV;	
			_scrollBar.update();
		}
		
		public function appendText(text:String, color:uint, object:Array=null):void
		{
			_textField.appendHtmlText(text, null, new TextFormat("Arial", 13, color));
		}
		
		//需要加入链接的文本应调用此函数，最后进行FLUSH
		public function appendCache(text:String, color:uint, index:int = 0):void
		{
			_cacheText += "<font color='#" + color.toString(16) + "'>" + text + "</font>";
			if(index) _index = index;
		}
		
		public function flush():void
		{
			var object:Array = null;
			_textField.appendHtmlText(_cacheText,object,new TextFormat("Arial", 13));
			_cacheText = "";
			_index = 0;
		}
		
		/**
		 * 删除文本中的前半段
		 * */
		public function clearHalf():void
		{
			if(_textField.textfield.htmlText.length > 50000){
				var enter_pos : int = _textField.textfield.htmlText.indexOf('<P ALIGN="LEFT">',20000);
				_textField.textfield.htmlText = _textField.textfield.htmlText.substr(enter_pos);
			}
		}
	}
}