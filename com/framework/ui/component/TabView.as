package com.framework.ui.component
{
	import com.framework.utils.KeyValue;
	import com.framework.ui.basic.canvas.CCanvas;

	import flash.display.MovieClip;
	import flash.text.TextFormat;

	/**
	 * @author derek
	 */
	public class TabView extends CCanvas
	{
		private var _tab : TabPanel;
		private var _align : int;
		private var _bgMc : MovieClip;

		public function TabView(width : int, height : int, bgMc : MovieClip, align : int, tabs : Vector.<KeyValue>, marginX : int, callback : Function, btnResRef : Class, space : int, horizontal : Boolean, normalColor : int, overColor : int, selectColor : int, textFontmat : TextFormat, embed : Boolean, textHorizontal : Boolean, filters : Array, tabOffset : int, topMargin : int, allowSelect : Boolean, tabTextTop : int = 0)
		{
			// 添加背景
			_bgMc = bgMc;

			cWidth = width;
			cHeight = height;

			_bgMc.width = width;
			_bgMc.height = height;

			addChild(_bgMc);

			// tab
			_tab = new TabPanel(callback, btnResRef, space, horizontal, normalColor, overColor, selectColor, textFontmat, embed, textHorizontal, filters, allowSelect, tabTextTop);

			// 记录tab的位置
			_align = align;

			// 加入tabs
			for each (var kv : KeyValue in tabs)
			{
				_tab.addTab(kv.key, kv.value, -1, -1, marginX);
			}

			// 加入tab
			var xOffset : int = topMargin;
			var yOffset : int = topMargin;

			switch(align)
			{
				case CCanvas.top:
					yOffset = tabOffset - _tab.cHeight;
					break;
				case CCanvas.bottom:
					yOffset = tabOffset - _tab.cHeight;
					break;
				case CCanvas.left:
					xOffset = tabOffset - _tab.cWidth;
					break;
				case CCanvas.right:
					xOffset = tabOffset - _tab.cWidth;
					break;
				default:
			}

			addChildEx(_tab, xOffset, yOffset, align);
		}

		public function set selectIndex(index : int) : void
		{
			_tab.selectIndex = index;
		}

		/**
		 * 根据ID设置当前的选中项
		 */
		public function set selectId(id : String) : void
		{
			_tab.selectId = id;
		}

		public function get selectId() : String
		{
			return _tab.selectedId;
		}

		public function get selectIndex() : int
		{
			return _tab.selectedIndex;
		}

		override public function set cHeight(val : Number) : void
		{
			super.cHeight = val;
			_bgMc.height = val;

			autoSizeChildren();
		}

		override public function set cWidth(val : Number) : void
		{
			super.cWidth = val;
			_bgMc.width = val;

			autoSizeChildren();
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
			_tab.setTabState(arr);
		}

		/**
		 * 根据传入的index获取TAB按钮
		 * @param index
		 * @return 
		 */
		public function getTabByIndex(index : int) : SwitchButton
		{
			var returntab : SwitchButton;

			returntab = _tab.getTabByIndex(index);

			return returntab;
		}
	}
}
