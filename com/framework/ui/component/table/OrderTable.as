package com.framework.ui.component.table
{
	import com.framework.utils.KeyValue;
	import com.framework.ui.component.ScrollPanel;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 可以点击表头排序的表格.
	 * 这个表格在点击表头后会回调 onHeadClick方法.请在该方法内实现
	 * 表格数据重新填充的逻辑.然后调用resetHeader()方法来重置表头
	 * 状态.详细参数参见resetHeader..
	 * 
	 * @author derek
	 */
	public class OrderTable extends Table
	{
		/**
		 * 表头单元格列
		 */
		private var _headerCellRef : Class;
		/**
		 * 箭头列表
		 */
		private var _arrows : Array;
		private var _selectedIndex : int;
		private var _arrowShow : Boolean;

		/**
		 * 构造函数
		 * 
		 * @param onHeadClick 表头被点击的CALLBACK
		 * @param headerCellRef 表头单元格CLASS.实例下有个name = _arrowMc的箭头MC. 箭头MC 1:下 2:上 3:下绿 4:上绿
		 * @param borderLeftColor 左边线颜色
		 * @param borderTopColor 上边线颜色
		 * @param borderBottomColor 下边线颜色
		 * @param borderRightColor 右边线颜色
		 * @param panel 滚动面板(表格体)
		 * @param height 表格高度
		 * @param cellTextNormalColor 表格文本默认颜色
		 * @param cellTextHotColor 表格文本鼠标移入颜色
		 * @param rowHeight 行高
		 * @param showLine 显示表格边线
		 * @param rowBgColor 单行背景颜色
		 * @param rowDoubleBgColor 双行背景颜色
		 * @param leftColor 单元格左边线颜色
		 * @param row2BgColor 行鼠标移入背景颜色
		 * @param rightColor 单元格右边线颜色
		 * @param topColor 单元格上边线颜色
		 * @param bottomColor 单元格下边线颜色
		 */
		public function OrderTable(onHeadClick : Function, headerCellRef : Class, borderLeftColor : int, borderTopColor : int, borderBottomColor : int, borderRightColor : int, panel : ScrollPanel, cellTextNormalColor : int, cellTextHotColor : int, rowHeight : int, showLine : Boolean, rowBgColor : int, rowDoubleBgColor : int, leftColor : int, row2BgColor : int, rightColor : int, topColor : int, bottomColor : int, selectedBg : Class, rowSelectedColor : int, itemMax : int, rowShowLine : Boolean = true, arrowShow : Boolean = true)
		{
			super(borderLeftColor, borderTopColor, borderBottomColor, borderRightColor, panel, cellTextNormalColor, cellTextHotColor, rowHeight, showLine, rowBgColor, rowDoubleBgColor, leftColor, row2BgColor, rightColor, topColor, bottomColor, selectedBg, rowSelectedColor, itemMax, rowShowLine);

			_headerCellRef = headerCellRef;

			_onHeadClick = onHeadClick;

			_arrows = [];

			_arrowShow = arrowShow;
		}

		/**
		 * 重置表头各列箭头/背景
		 * 
		 * @param currentIndex 当前选择列(从0开始)
		 * @param cols Array所有列状态(cols[i] is Boolean,true = ↓,false = ↑)
		 */
		public function resetHeader(currentIndex : int, cols : Array) : void
		{
			_selectedIndex = currentIndex;

			// 循环所有表头.进行设置
			var len : int = header.colNum;

			for (var i : int = 0; i < len; i++)
			{
				var cell : Cell = header.getCell(i);

				// 背景
				var cellBg : MovieClip = cell.getChildByName('_cellBg') as MovieClip;
				var bg : MovieClip = cellBg.getChildByName('_bg') as MovieClip;
				bg.gotoAndStop(currentIndex == i ? 3 : 1);

				// 如果没箭头.就直接return
				if (!_arrowShow)
					continue;

				// 箭头
				var arrowMc : MovieClip = cellBg.getChildByName('_arrowMc') as MovieClip;

				if (arrowMc != null)
				{
					var frame : int = cols[i] ? 1 : 2;

					if (currentIndex == i)
					{
						frame += 2;
					}

					arrowMc.gotoAndStop(frame);
				}
			}
		}

		/**
		 * 初始化表格头部
		 * 
		 * @param headerBg 表头的背景条(注意!是条.即横贯整个表头的图片..或其他什么东西)
		 * @param headerHeight 表头高度.当指定了headerBg的时候.本属性无效!!!
		 * @param cols 表头列信息(KeyValue数组.Key为该列的表头文本,Value为该列的宽度)
		 * @param size 字体大小
		 * @param bgColor 背景颜色
		 * @param color 文字颜色
		 * @param bold 是否粗体
		 * @param showLine 是否显示边线
		 * @param filters 文本特效(glow,light)等
		 * @param font 字体
		 * @param embed 是否为嵌入字体 
		 */
		override public function initHeader(headerBg : MovieClip, headerHeight : int, cols : Vector.<KeyValue>, size : int, bgColor : int, textColor : int, bold : Boolean = false, showLine : Boolean = false, filters : Array = null, font : String = null, embed : Boolean = false, drawBorder : Boolean = false, autoHeight : Boolean = false, targets : Array = null) : void
		{
			super.initHeader(headerBg, headerHeight, cols, size, bgColor, textColor, bold, showLine, filters, font, embed, drawBorder, autoHeight, targets);

			var setCell : Function = function(index : int) : void
			{
				var cell : Cell = header.getCell(index);

				var cellBg : MovieClip = new _headerCellRef();
				cellBg.gotoAndStop(1);
				cellBg.name = '_cellBg';
				cellBg.mouseChildren = cellBg.mouseEnabled = false;

				var bg : MovieClip = cellBg.getChildByName('_bg') as MovieClip;
				bg.width = cell.cWidth;
				bg.gotoAndStop(1);

				cell.addChildAt(cellBg, 0);
				cell.evts.addClick(function(event : MouseEvent) : void
				{
					var target : TextCell = event.target as TextCell;

					if (target == null)
						return;
					_onHeadClick(target.id);
				});
				cell.evts.mouseOver(function(event : Event) : void
				{
					if (event.target as TextCell == null)
						return;

					if (_selectedIndex == index)
						return;

					bg.gotoAndStop(2);
				});
				cell.evts.mouseOut(function(event : Event) : void
				{
					if (event.target as TextCell == null)
						return;

					if (_selectedIndex == index)
						return;

					bg.gotoAndStop(1);
				});

				var arrowMc : MovieClip = cellBg.getChildByName('_arrowMc') as MovieClip;

				if (arrowMc != null)
				{
					arrowMc.gotoAndStop(1);
					arrowMc.visible = _arrowShow;
				}
			};

			// 遍历cell.
			var len : int = header.colNum;

			for (var i : int = 0; i < len; i++)
			{
				setCell(i);
			}
		}

		public function setHeaderCellSelect(index : int) : void
		{
			var cell : Cell = header.getCell(index);
			cell.select();
		}

		/**
		 * 设置禁用点击的列index
		 * 
		 * @param cols index列表
		 */
		public function set disClickCols(cols : Array) : void
		{
			var len : int = header.colNum;

			for (var i : int = 0; i < len; i++)
			{
				// 提取一个CELL
				var cell : TextCell = header.getCell(i) as TextCell;

				// 如果没找到.那么就TRUE
				var show : Boolean = cols.indexOf(i) < 0;

				cell.setEnable(show);

				var arrowMc : MovieClip = (cell.getChildByName('_cellBg') as MovieClip).getChildByName('_arrowMc') as MovieClip;

				if (arrowMc != null)
				{
					arrowMc.visible = _arrowShow && show;
				}
			}
		}

		/**
		 * 当头部被点击.的CALLBACK
		 */
		private var _onHeadClick : Function;
	}
}
