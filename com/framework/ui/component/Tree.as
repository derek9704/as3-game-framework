package com.framework.ui.component
{
	import com.framework.utils.KeyValue;
	import com.framework.ui.basic.canvas.CCanvas;

	import flash.display.MovieClip;

	/**
	 * 树控件
	 * 
	 * @author derek
	 */
	public class Tree extends CCanvas
	{
		/**
		 * 构造函数
		 * 
		 * @param bg 背景
		 * @param barMcRef bar的movieclip类
		 * @param itemMcRef item的movieclip类
		 * @param width 宽度
		 * @param height 高度
		 * @param bars 所有bar的列表
		 * @param barNormalColor bar文本默认颜色
		 * @param barOverColor bar文本over颜色
		 * @param barSelectColor bar文本被选中颜色
		 * @param barFilters bar文本的filter
		 * @param barSpace bar之间的间隔
		 * @param itemNormalColor item文本默认颜色
		 * @param itemOverColor item文本over颜色
		 * @param itemSelectColor item文本被选中颜色
		 * @param itemFilters item文本的filter
		 * @param itemSpace item之间的间隔
		 * @param onItemClick 当item被点击的时候
		 * @param itemWidth item的宽度
		 * @param itemHeight item的高度
		 * @param barWidth bar宽度
		 * @param barHeight bar高度
		 * @param panel 滚动面板(面板的宽度应该和item相同).面板水平居中加在控件中.
		 */
		public function Tree(bg : MovieClip, barMcRef : Class, itemMcRef : Class, width : int, height : int, bars : Vector.<String>, barNormalColor : int, barOverColor : int, barSelectColor : int, barFilters : Array, barSpace : int, itemNormalColor : int, itemOverColor : int, itemSelectColor : int, itemFilters : Array, itemSpace : int, onItemClick : Function, itemWidth : int, itemHeight : int, barWidth : int, barHeight : int, panel : ScrollPanel, barTextMargin : int, itemTextMargin : int)
		{
			// bg.width = width;
			// bg.height = height;
			addChild(bg);

			super(width, height);

			// 加入panel
			_panel = panel;
			_panel.hScrollBarEnable = false;
			addChildH(_panel);

			// 初始化bar
			_bars = new Vector.<AccordionItem>();

			var len : int = bars.length;
			var item : AccordionItem;

			for (var i : int = 0; i < len; i++)
			{
				item = new AccordionItem(barMcRef, barWidth, barHeight, barNormalColor, barOverColor, barSelectColor, barFilters, i, bars[i], i.toString(), openBar, closeBar, false, barTextMargin);
				item.status = CLOSE;

				_bars.push(item);

				_panel.addItem(item.item, 0, i * (item.item.cHeight + barSpace));
			}

			// 各种bar之间的间隔
			_barSpace = barSpace;

			// 记录item 的数据
			_itemNormalColor = itemNormalColor;
			_itemOverColor = itemOverColor;
			_itemSelectColor = itemSelectColor;
			_itemFilters = itemFilters;
			_itemSpace = itemSpace;
			_itemMcRef = itemMcRef;
			_itemWidth = itemWidth;
			_itemHieght = itemHeight;
			_itemTextMargin = itemTextMargin;

			_onItemClick = onItemClick;
		}

		/**
		 * 清空指定index下的item
		 */
		public function clearItem(index : int, r : Boolean = true) : void
		{
			_bars[index].items = new Vector.<AccordionItem>();

			if (r)
				refresh();
		}

		public function setBarTitle(index : int, title : String) : void
		{
			_bars[index].title = title;
		}

		/**
		 * 加入一个item到指定index的bar下面
		 * 
		 * @param index bar的index
		 * @param title item显示的title
		 * @param id item的id.回调函数用.如果null则 id = title
		 * @param r 是否刷新界面
		 * @param fixed 固定的颜色.即不使用初始化时指定的颜色
		 */
		public function addItem(index : int, title : String, id : String = null, r : Boolean = true, special : int = -1) : void
		{
			if (index < 0 || index >= _bars.length)
				throw 'index范围超出了bar的数量';

			var normal : int = special > -1 ? special : _itemNormalColor;
			var over : int = special > -1 ? special : _itemOverColor;
			var select : int = special > -1 ? special : _itemSelectColor;

			_bars[index].items.push(new AccordionItem(_itemMcRef, _itemWidth, _itemHieght, normal, over, select, _itemFilters, index, title, id, itemClick, itemClick, false, _itemTextMargin));

			if (r)
				refresh();
		}

		/**
		 * item的单击响应函数
		 * 
		 * @param id 被点击item的id
		 */
		private function itemClick(id : String) : void
		{
			// 清空所有的被选择项
			var len : int = _bars.length;

			for (var i : int = 0; i < len; i++)
			{
				var itemsLen : int = _bars[i].items.length;

				for (var j : int = 0; j < itemsLen; j++)
				{
					_bars[i].items[j].item.status = 1;
				}
			}

			// 统一的回调函数
			_onItemClick(id);
		}

		/**
		 * 批量加入item
		 * 
		 * @param index 准备加入item的bar的index.
		 * @param titles item的信息.key为显示的title,value为id(可以为空,为空则 id = title).
		 */
		public function addItems(index : int, titles : Vector.<KeyValue>) : void
		{
			if (index < 0 || index >= _bars.length)
				throw 'index范围超出了bar的数量';

			var len : int = titles.length;

			for (var i : int = 0; i < len; i++)
			{
				addItem(index, titles[i].key, titles[i].value, false);
			}

			refresh();
		}

		/**
		 * 设置items到bar下
		 * 
		 * @param index bar的index
		 * @param titles item的信息.key为显示的title,value为id(可以为空,为空则 id = title).
		 */
		public function setItems(index : int, titles : Vector.<KeyValue>) : void
		{
			_bars[index].items = new Vector.<AccordionItem>();

			addItems(index, titles);

			// 如果当前正在显示.则刷新之
			if (_bars[index].status == OPEN)
				refresh();
		}

		/**
		 * 打开某个BAR
		 * 
		 * @param i bar的index
		 */
		private function openBar(i : String) : void
		{
			var index : int = parseInt(i);

			// 检查index
			if (index < 0 || index >= _bars.length)
				throw 'index范围超出了bar的数量';

			_bars[index].status = OPEN;

			// 刷新界面
			refresh();
		}

		/**
		 * 关闭某个BAR
		 * 
		 * @param i bar的index
		 */
		private function closeBar(i : String) : void
		{
			var index : int = parseInt(i);

			// 检查index
			if (index < 0 || index >= _bars.length)
				throw 'index范围超出了bar的数量';

			trace('close bar:' + index);

			_bars[index].status = CLOSE;

			// 刷新界面
			refresh();
		}

		/**
		 * 刷新控件界面
		 */
		public function refresh() : void
		{
			// 清空panel
			_panel.panel.removeAllChildren(false);
			_panel.panel.cHeight = 0;

			// 所有bar数量
			var len : int = _bars.length;
			var newY : int = 0;

			// 遍历所有bar.依次显示之
			for (var i : int = 0; i < len; i++)
			{
				var bar : SwitchButton = _bars[i].item;

				// 加入bar
				_panel.addItem(bar, 0, newY);
				// 调整便宜量
				newY += bar.cHeight;

				// 如果关闭状态.则下一个
				if (_bars[i].status == CLOSE)
					continue;

				var itemsLen : int = _bars[i].items.length;
				var items : Vector.<AccordionItem> = _bars[i].items;

				// 遍历ITEMS
				for (var j : int = 0; j < itemsLen; j++)
				{
					// 加入item
					_panel.addItem(items[j].item, 0, newY);
					// 调整偏移量
					newY += items[j].item.cHeight;
				}
			}

			_panel.resize();
		}

		private static const OPEN : int = 1;
		private static const CLOSE : int = 0;
		private var _itemTextMargin : int;
		private var _itemMcRef : Class;
		private var _onItemClick : Function;
		private var _barSpace : int;
		private var _itemSelectColor : int;
		private var _itemWidth : int;
		private var _itemHieght : int;
		private var _panel : ScrollPanel;
		private var _bars : Vector.<AccordionItem>;
		private var _itemSpace : int;
		private var _itemFilters : Array;
		private var _itemOverColor : int;
		private var _itemNormalColor : int;
	}
}
