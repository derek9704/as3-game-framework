package com.framework.ui.component
{
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.ui.sprites.CTip;
	import com.framework.utils.TipHelper;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * 列表
	 * @author derek
	 */
	public class List extends ScrollPanel
	{
		private var _itemTextColor : uint;
		private var _itemTextHotColor : uint;
		private var _itemHotBg : Class;
		private var _itemSelectedBg : Class;
		private var _itemTextSelectedColor : uint;
		private var _itemBg : Class;
		private var _itemBg2 : Class;
		private var _split : int;
		private var _itemHeight : int;
		private var _maxItem : int;
		private var _index : int = -1;

		/**
		 * 构造函数
		 * 
		 * @param w 宽度
		 * @param changed 选项改变的回调函数
		 * @param listBg list的背景
		 * @param itemBg 选项的背景
		 * @param itemTextColor 文本颜色
		 * @param itemTextHotColor 文本鼠标移入颜色
		 * @param itemTextAlpha 文本透明度
		 * 
		 */
		public function List(w : uint, changed : Function, listBg : Class, itemHotBg : Class, itemTextColor : uint, itemTextHotColor : uint, itemSelectedBg : Class = null, itemTextSelectedColor : int = -1, itemBg : Class = null, itemBg2 : Class = null, split : int = 0, itemHeight : int = 20, maxItem : int = -1, scrollBar : VerticalScrollBar = null, hScrollBar : HScrollBar = null, tf : TextFormat = null)
		{
			super('', w, 1, scrollBar, hScrollBar);
			bg.setBg(new listBg());

			// 文本格式
			if (tf == null)
			{
				_textFormat = new TextFormat();
				_textFormat.align = TextFormatAlign.CENTER;
			}
			else
			{
				_textFormat = tf;
			}

			// 回调函数
			_changed = changed;

			// 文本2种状态颜色
			_itemTextColor = itemTextColor;
			_itemTextHotColor = itemTextHotColor;

			// 未指定则为普通颜色
			_itemTextSelectedColor = itemTextSelectedColor == -1 ? itemTextHotColor : itemTextSelectedColor;

			// 4个背景

			_itemHotBg = itemHotBg;
			_itemSelectedBg = itemSelectedBg == null ? itemHotBg : itemSelectedBg;
			_itemBg = itemBg;
			_itemBg2 = itemBg2 == null ? itemBg : itemBg2;

			// item间隔
			_split = split;

			// item高度
			_itemHeight = itemHeight;

			// 最大item数量
			_maxItem = maxItem;
		}

		/**
		 * 清空list
		 */
		public function clear() : void
		{
			for each (var item : ListItemInfo in _items)
			{
				item.canvas.removeSelf();
			}

			cHeight = 2;
			_items = [];
			panel.cHeight = 1;
			resize();
		}

		public function get itemCount() : int
		{
			return _items.length;
		}

		/**
		 * 加入一个新的item
		 * 
		 * @param text 文本
		 * @param tips 提示
		 */
		public function addListItem(text : String, id : String = null, tips : CTip = null) : void
		{
			var canvas : CSprite = new CSprite('', this.cWidth - 2, _itemHeight);
			canvas.bg.setStyle(0, 0);
			// 如果指定了背景.就设置背景
			if (_itemBg != null)
			{
				var itemBg : DisplayObject;
				// 是否为双行
				var double : Boolean = int(_items.length % 2) != 0;

				// 如果是双行,则为itembg2,辅路泽是itembg
				itemBg = double ? (new _itemBg2()) : (new _itemBg());

				// 设置大小
				itemBg.width = canvas.cWidth;
				itemBg.height = canvas.cHeight;

				// 加入背景
				canvas.addChild(itemBg);
			}

			// HOT状态的背景

			var itemHotBg : DisplayObject = new _itemHotBg();
			itemHotBg.width = canvas.cWidth;
			itemHotBg.height = canvas.cHeight;

			// 被选中状态的背景
			var selectedBg : DisplayObject = new _itemSelectedBg();
			selectedBg.width = canvas.cWidth;
			selectedBg.height = canvas.cHeight;

			// 加入背景并设置初始状态
			canvas.addChild(selectedBg);
			canvas.addChild(itemHotBg);
			selectedBg.visible = false;
			itemHotBg.visible = false;

			// 文本栏
			var textField : TextField = new TextField();
			textField.width = canvas.cWidth;
			textField.height = canvas.cHeight;
			textField.defaultTextFormat = _textFormat;
			textField.text = text;
			textField.selectable = false;
			textField.mouseEnabled = false;

			canvas.addChild(textField);

			// 设置属性
			var item : ListItemInfo = new ListItemInfo();
			item.canvas = canvas;
			item.textfield = textField;
			item.text = text;
			item.hotBg = itemHotBg;
			item.selectedBg = selectedBg;
			item.hotColor = _itemTextHotColor;
			item.normalColor = _itemTextColor;
			item.selectedColor = _itemTextSelectedColor;

			item.id = (id == null ? text : id);

			item.setStatus(ListItemInfo.NORMAL);

			canvas.evts.addEventListener(MouseEvent.MOUSE_OVER, function(e : Event) : void
			{
				item.setStatus(ListItemInfo.HOT);
			});

			canvas.evts.addEventListener(MouseEvent.MOUSE_OUT, function(e : Event) : void
			{
				if (item == _selectedItem)
				{
					return;
				}

				item.setStatus(ListItemInfo.NORMAL);
			});

			canvas.evts.addClick(function(e : Event) : void
			{
				setSelectedItem(item);
			});

			// item的y.如果是第一个.则添加margintop,否则添加_split
			var cY : int = panel.cHeight + (_items.length == 0 ? 0 : _split);

			_items.push(item);

			// 加入对象
			addItem(canvas, 1, cY);

			// 如果小于指定数量.则修改面板高度
			if (_maxItem == -1 || _items.length <= _maxItem)
				cHeight = panel.cHeight;

			// 添加提示
			if (tips == null)
				return;

			TipHelper.setTip(canvas, tips);
		}

		public function get index() : int
		{
			return _index;
		}

		/**
		 * 设置指定index的项为选中项
		 * 
		 * @param index 项的index
		 * @param event 是否触发回调事件
		 */
		public function setSelection(index : int, event : Boolean = true) : void
		{
			setSelectedItem(_items[index], event);
		}

		/**
		 * 获取被选中的文本
		 */
		public function get selectedText() : String
		{
			return _selectedItem == null ? '' : _selectedItem.text;
		}

		public function set index(val : int) : void
		{
			if (val < 0 || val >= _items.length)
				return;

			setSelectedItem(_items[val], false);
		}

		private function setSelectedItem(item : ListItemInfo, event : Boolean = true) : void
		{
			_selectedItem = item;

			// 所有设置为普通状态
			for each (var otherItem : ListItemInfo in _items)
			{
				otherItem.setStatus(ListItemInfo.NORMAL);
			}

			// 被选择的设置为选择状态
			_selectedItem.setStatus(ListItemInfo.SELECTED);

			// index
			_index = _items.indexOf(_selectedItem);

			// 回调
			if (_changed != null)
				_changed(_selectedItem, event);
		}

		/**
		 * item列表
		 */
		public function get items() : Array
		{
			return _items;
		}

		private var _textFormat : TextFormat;
		private var _selectedItem : ListItemInfo = null;
		private var _items : Array = [];
		private var _changed : Function;
	}
}
