package com.framework.ui.component
{
	import com.brickmice.view.component.BmButton;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.ui.sprites.CImageButton;
	import com.framework.utils.KeyValue;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * 下拉框
	 * 
	 * @author derek
	 */
	public class DropDownList extends CSprite
	{
		private var _list : List;
		private var _textField : TextField;
		private var _onChanged : Function;
		private var _down : Boolean;

		/**
		 * 当前选中项的文本 
		 */
		public function get selectedText() : String
		{
			return _list.selectedText;
		}

		/**
		 * 修改index
		 */
		public function set index(index : int) : void
		{
			_list.setSelection(index);
		}

		/**
		 * 修改index(不触发回调函数)
		 */
		public function setIndex(index : int) : void
		{
			_list.setSelection(index, false);
		}

		/**
		 * 构造函数
		 * 
		 * @param icon 下拉框按钮
		 * @param fontSize 字体大小
		 * @param w 宽度
		 * @param h 高度
		 * @param items 选项列表.KeyValue数组
		 * @param index 默认的index
		 * @param onChanged 当选项被改变的回调函数
		 * @param itemTextColor 选项文本颜色
		 * @param itemTextHotColor 选项文本鼠标移入的颜色
		 * @param itemBg 选项背景
		 * @param listBg 列表背景
		 * @param titleBg 文本框背景/或者文本框按钮
		 * @param down 是否是向下
		 * 
		 */
		public function DropDownList(icon : MovieClip, fontSize : int, w : uint, h : uint, items : Array, index : uint, onChanged : Function, itemTextColor : uint, itemTextHotColor : uint, itemBg : Class, listBg : Class, titleBg : Class, down : Boolean = true, scrollbar : VerticalScrollBar = null, hscrollbar : HScrollBar = null, maxItem : int = -1, format : TextFormat = null, filters:Array = null)
		{
			var title : MovieClip = new titleBg();
			title.width = w;
			title.height = h;
			super('', w, h);		
			addChild(title);
			
			if(icon){
				var btn : CImageButton = new CImageButton(icon);
				addChildV(btn, 5, rt);
			}
			
			var textFormat : TextFormat = format;

			if (textFormat == null)
			{
				textFormat = new TextFormat();
				textFormat.align = TextFormatAlign.CENTER;
			}

			textFormat.size = fontSize;
			textFormat.color = itemTextColor;

			var text : String = '';

			// 存储下拉列表框的位置
			_down = down;

			_onChanged = onChanged;

			_textField = new TextField();
			_textField.defaultTextFormat = textFormat;
			_textField.filters = filters;

			_textField.text = text;

			if(icon)
				_textField.width = cWidth - icon.width - 5;
			else
				_textField.width = cWidth;
			_textField.height = 18;
			_textField.mouseEnabled = false;
			_textField.selectable = false;

			_list = new List(w, changed, listBg, itemBg, itemTextColor, itemTextHotColor, null, -1, null, null, 0, 20, maxItem, scrollbar, hscrollbar, textFormat);
			_list.visible = false;

			// 初始化items.并且设置默认item
			if (items != null)
			{
				var len : int = items.length;

				for (var i : int = 0;i < len; i++)
				{
					var item : KeyValue = items[i];

					_list.addListItem(item.value, item.key);

					if (index == i)
					{
						text = item.value;
					}
				}

				// 如果index合法.则设置默认item
				if (text != '')
					_list.setSelection(index, false);
			}

			if(icon){
				title.addEventListener(MouseEvent.CLICK, onClick);
				title.buttonMode = true;
				btn.click = onClick;
			}else{
				//兼容一下 title 作为 Btn 的情况
				new BmButton(title, onClick);
			}
			
			addChildV(_textField);
			addChildEx(_list, 0, _textField.height);
		}

		public function close() : void
		{
			_list.visible = false;
		}

		public function resetList(items : Array, event : Boolean = false) : void
		{
			_list.clear();

			var len : int = items.length;

			for (var i : int = 0;i < len; i++)
			{
				var item : KeyValue = items[i];

				_list.addListItem(item.value, item.key);
			}

			if (len > 0)
				_list.setSelection(0, event);
		}

		private function onClick(event : MouseEvent) : void
		{
			_list.visible = !_list.visible;

			// 如果不显示.则直接退出
			if (!_list.visible)
				return;

			// 设定下拉列表的位置
			if (_down)
				_list.y = _textField.height;
			else
				_list.y = - _list.cHeight;

			event.stopImmediatePropagation();
		}

		private function changed(item : ListItemInfo, callback : Boolean = true) : void
		{
			if (item.text != null)
			{
				_textField.text = item.text;
				_list.visible = false;

				if (_onChanged != null && callback)
					_onChanged(item.id);
			}
		}
	}
}
