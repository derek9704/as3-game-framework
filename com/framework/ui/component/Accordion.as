package com.framework.ui.component
{
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.utils.KeyValue;
	import com.framework.utils.greensock.TweenLite;
	
	import flash.display.MovieClip;

	/**
	 * 手风琴控件
	 * 
	 * @author derek
	 */
	public class Accordion extends CCanvas
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
		public function Accordion(bg : MovieClip, barMcRef : Class, itemMcRef : Class, width : int, height : int, bars : Vector.<String>, barNormalColor : int, barOverColor : int, barSelectColor : int, barFilters : Array, barSpace : int, itemNormalColor : int, itemOverColor : int, itemSelectColor : int, itemFilters : Array, itemSpace : int, onItemClick : Function, itemWidth : int, itemHeight : int, barWidth : int, barHeight : int, panel : ScrollPanel)
		{
			bg.width = width;
			bg.height = height;
			addChild(bg);

			super(width, height);

			// 加入所以bar
			_bars = new Vector.<AccordionItem>();

			var len : int = bars.length;
			var item : AccordionItem;

			for (var i : int = 0; i < len; i++)
			{
				item = new AccordionItem(barMcRef, barWidth, barHeight, barNormalColor, barOverColor, barSelectColor, barFilters, i, bars[i], i.toString(), changeBar);
				_bars.push(item);

				addChildH(item.item, i * (item.item.cHeight + barSpace));
			}

			// 各种bar之间的间隔
			_barSpace = barSpace;

			// 加入显示item的面板
			_panel = panel;
			_panel.hScrollBarEnable = false;
			addChildH(_panel);

			// 记录item 的数据
			_itemNormalColor = itemNormalColor;
			_itemOverColor = itemOverColor;
			_itemSelectColor = itemSelectColor;
			_itemFilters = itemFilters;
			_itemSpace = itemSpace;
			_itemMcRef = itemMcRef;
			_itemWidth = itemWidth;
			_itemHieght = itemHeight;

			_onItemClick = onItemClick;
		}

		/**
		 * 加入一个item到指定index的bar下面
		 * 
		 * @param index bar的index
		 * @param title item显示的title
		 * @param id item的id.回调函数用.如果null则 id = title
		 * @param r 是否刷新界面
		 */
		public function addItem(index : int, title : String, id : String = null, r : Boolean = true) : void
		{
			if (index < 0 || index >= _bars.length)
				throw 'index范围超出了bar的数量';

			_bars[index].items.push(new AccordionItem(_itemMcRef, _itemWidth, _itemHieght, _itemNormalColor, _itemOverColor, _itemSelectColor, _itemFilters, index, title, id, itemClick));

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

		public function selectItem(index : int, itemIndex : int) : Boolean
		{
			if (index >= _bars.length)
				return false;

			if (itemIndex >= _bars[index].items.length)
				return false;

			_currentIndex = index;

			// 刷新界面
			refresh();

			// 回调函数
			_onItemClick(_bars[index].items[itemIndex].item.id);

			return true;
		}

		public function get index() : int
		{
			return _currentIndex;
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
			if (index == _currentIndex)
				showItems();
		}

		/**
		 * 修改指定index的bar为当前bar
		 * 
		 * @param index bar的index
		 */
		private function changeBar(i : String) : void
		{
			var index : int = parseInt(i);

			trace('changebar:' + index);

			// 检查index
			if (index < 0 || index >= _bars.length)
				throw 'index范围超出了bar的数量';

			// 当前项
			_currentIndex = index;

			// 刷新界面
			refresh(true);
		}

		/**
		 * 刷新控件界面
		 * 
		 * @param animation 是否动画显示
		 */
		private function refresh(animation : Boolean = false) : void
		{
			// 移动bar的时间.如果开启动画.就1秒..否则瞬间到
			var time : Number = animation ? 0.5 : 0;

			// 所有bar数量
			var len : int = _bars.length;

			// 所有bar的数量
			var total : int = len;

			// 隐藏panel
			_panel.visible = false;

			// 遍历所有bar.根据bar的位置.进行移动
			for (var i : int = 0; i < len; i++)
			{
				var bar : SwitchButton = _bars[i].item;
				var newY : int;

				// 清空bar的状态
				bar.status = 1;

				// 所有应该在上部的bar?
				if (i <= _currentIndex)
				{
					newY = i * (bar.cHeight + _barSpace);
				}
				else
				{
					// 应该在下部的bar
					newY = cHeight - (((len - i) * (bar.cHeight + _barSpace)));
				}

				// 缓动之
				TweenLite.to(bar, time, {y:newY, onComplete:function() : void
				{
					total--;

					if (total == 0)
						showItems();
				}});
			}
		}

		/**
		 * 显示所有ITEM
		 */
		private function showItems() : void
		{
			// 清空panel
			_panel.panel.removeAllChildren(false);
			_panel.panel.cHeight = 0;
			_panel.panel.y = 0;
			_panel.resize();

			// 调整panel位置
			_panel.y = _bars[_currentIndex].item.y + _bars[_currentIndex].item.cHeight;

			var items : Vector.<AccordionItem> = _bars[_currentIndex].items;

			if (items.length < 1)
				return;

			// 添加各种item
			var len : int = items.length;
			var itemHeight : int = items[0].item.cHeight + _itemSpace;

			for (var i : int = 0; i < len; i++)
			{
				_panel.addItem(items[i].item, 0, itemHeight * i);
			}

			// 显示panel
			_panel.visible = true;
		}

		private var _itemMcRef : Class;
		private var _onItemClick : Function;
		private var _barSpace : int;
		private var _itemSelectColor : int;
		private var _itemWidth : int;
		private var _itemHieght : int;
		private var _panel : ScrollPanel;
		private var _currentIndex : int;
		private var _bars : Vector.<AccordionItem>;
		private var _itemSpace : int;
		private var _itemFilters : Array;
		private var _itemOverColor : int;
		private var _itemNormalColor : int;
	}
}
