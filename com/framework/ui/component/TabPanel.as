package com.framework.ui.component
{
	import com.framework.utils.FilterUtils;
	import com.framework.ui.basic.canvas.CCanvas;

	import flash.text.TextFormat;

	/**
	 * TAB按钮面板.上面会放着一排的TAB按钮.
	 * 
	 * @author derek
	 */
	public class TabPanel extends CCanvas
	{
		private var _textFormat : TextFormat;
		private var _embed : Boolean;
		private var _btnResRef : Class;
		private var _horizontal : Boolean;
		private var _space : int;
		private var _callback : Function;
		private var _textHorizontal : Boolean;
		private var _tabs : Vector.<SwitchButton>;
		private var _filters : Array;
		private var _normalColor : int;
		private var _overColor : int;
		private var _selectColor : int;
		private var _allowSelect : Boolean;
		private var _tabTextTop : int;
		private var _selectedId : int;

		/**
		 * TAB按钮
		 * 
		 * @param callback 某个tab按钮被点击后的回调函数.格式为 callback(id:String):void; id = tab按钮设定的id
		 * @param btnRes 按钮资源的类名(要求3帧.1帧 = 普通状态,2帧OVER状态,3帧按下状态)
		 * @param space 按钮之间的间隔
		 * @param horizontal 是否是水平方向
		 * @param normalColor 普通模式文本颜色
		 * @param overColor over状态文本颜色
		 * @param selectColor 被选择后的文本颜色
		 * @param textFontmat 按钮上文本格式
		 * @param embed 按钮文本是否使用.嵌入字体
		 * @param textHorizontal 文本方向
		 * @param filters 文本的效果
		 */
		public function TabPanel(callback : Function, btnResRef : Class, space : int, horizontal : Boolean, normalColor : int, overColor : int, selectColor : int, textFontmat : TextFormat, embed : Boolean, textHorizontal : Boolean, filters : Array, allowSelect : Boolean = false, tabTextTop : int = 0)
		{
			super(0, 0);

			_tabTextTop = tabTextTop;
			_textFormat = textFontmat;
			_embed = embed;
			_btnResRef = btnResRef;
			_horizontal = horizontal;
			_space = space;
			_callback = callback;
			_textHorizontal = textHorizontal;
			_filters = filters;
			_allowSelect = allowSelect;

			_normalColor = normalColor;
			_overColor = overColor;
			_selectColor = selectColor;

			_tabs = new Vector.<SwitchButton>();
		}

		/**
		 * 加入一个TAB
		 * 
		 * @param title TAB上的文本
		 * @param id TAB被点击返回的id值.如果为空.则返回内容为title
		 */
		public function addTab(title : String, id : String = null, w : int = -1, h : int = -1, marginX : int = 0) : void
		{
			// id为空.则id = title
			if (id == null )
				id = title;

			// 如果文本是垂直方向的.则修改title内容
			if (!_textHorizontal)
			{
				var newTitle : String = '';

				for (var i : int = 0; i < title.length; i++)
				{
					newTitle += "\n" + title.charAt(i);
				}

				if (newTitle != '')
					title = newTitle.substr(1);
			}

			// 构造按钮
			var btn : SwitchButton = new SwitchButton(_btnResRef, title, id, _normalColor, _overColor, _selectColor, _textFormat, _embed, w, h, resetTabs, _filters, null, _tabTextTop == 0, _tabTextTop, false, marginX, _allowSelect ? resetTabs : null);

			// 加入按钮
			_tabs.push(btn);

			// 修改面板大小
			if (_horizontal)
			{
				cWidth += btn.cWidth + _space;

				if (cHeight < btn.cHeight)
					cHeight = btn.cHeight;
			}
			else
			{
				cHeight += btn.cHeight + _space;

				if (cWidth < btn.cWidth)
					cWidth = btn.cWidth;
			}
			// 加入对象.如果是水平.则右上
			// 否则是左下
			addChildEx(btn, 0, 0, _horizontal ? rt : lb);

			// 设置默认第一个激活
			selectIndex = 0;
		}

		/**
		 * 重设所有按钮
		 */
		private function resetTabs(id : String = null) : void
		{
			var len : int = _tabs.length;

			for (var i : int = 0; i < len; i++)
			{
				if (_tabs[i].id != id)
				{
					_tabs[i].status = 1;
					_selectedId = i;
				}
			}

			if (id != null)
				_callback(id);
		}

		/**
		 * 根据IDNEX设置选中项
		 */
		public function set selectIndex(index : int) : void
		{
			if (index < 0 || index >= _tabs.length)
				throw '指定的INDEX超出了范围';

			resetTabs();
			_tabs[index].status = 3;
		}

		/**
		 * 根据ID设置当前的选中项
		 */
		public function set selectId(id : String) : void
		{
			var len : int = _tabs.length;

			for (var i : int = 0; i < len; i++)
			{
				if (_tabs[i].id == id)
				{
					resetTabs();
					_tabs[i].status = 3;
				}
			}
		}

		public function get selectedIndex() : int
		{
			return _selectedId;
		}

		public function get selectedId() : String
		{
			if (_selectedId < 0 || _selectedId >= _tabs.length)
				return null;

			return _tabs[_selectedId].id;
		}

		/**
		 * 设置该tab上按钮的状态
		 * 传入的数组的长度需要和tab数量相同
		 * 数组中放的是布尔值，true为可点击，false为不可点击
		 * 数组的指针与tab按钮相对应
		 * @param arr
		 */
		public function setTabState(arr : Array) : void
		{
			if (arr.length == _tabs.length)
			{
				for (var i : int = 0, len : int = _tabs.length ; i < len ; i++)
				{
					FilterUtils.clearColorMask(_tabs[i]);
					_tabs[i].mouseEnabled = _tabs[i].mouseChildren = true;

					if (!arr[i])
					{
						FilterUtils.setColorMask(_tabs[i]);
						if (_tabs[i].enable == true)
							_tabs[i].mouseEnabled = _tabs[i].mouseChildren = false;
					}
				}
			}
		}

		/**
		 * 根据传入的index获取TAB按钮
		 * @param index
		 * @return 
		 */
		public function getTabByIndex(index : int) : SwitchButton
		{
			var returntab : SwitchButton;

			if (index < _tabs.length)
			{
				for (var i : int = 0, len : int = _tabs.length ; i < len ; i++)
				{
					if (index == i)
					{
						returntab = _tabs[i];
						break;
					}
				}
			}

			return returntab;
		}
	}
}
