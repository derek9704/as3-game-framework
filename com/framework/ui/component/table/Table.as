package com.framework.ui.component.table
{
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.KeyValue;
	import com.framework.ui.component.ScrollPanel;

	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import com.framework.utils.TipHelper;
	import com.framework.ui.sprites.CTip;

	/**
	 * 表格基类
	 * 
     * @author derek
     */
	public class Table extends CSprite
	{
		private var _panel : ScrollPanel;
		private var _headerHeight : int;
		private var _rowHeight : int;
		private var _rowBgColor : int;
		private var _row2BgColor : int;
		private var _leftColor : int;
		private var _rightColor : int;
		private var _topColor : int;
		private var _bottomColor : int;
		private var _showLine : Boolean;
		private var _cellTextNormalColor : int;
		private var _cellTextHotColor : int;
		private var _initEvts : Boolean;
		private var _initHeader : Boolean;
		private var _borderLeftColor : uint;
		private var _borderTopColor : uint;
		private var _borderBottomColor : uint;
		private var _borderRightColor : uint;
		private var _rowDoubleBgColor : int;
		private var _yOffset : int;
		private var _header : Row;
		private var _rowSelectedBg : Class;
		private var _rowSelectedColor : int;
		private var _selectId : String;
		/**
		 * 表格最大显示个数
		 */
		protected var _itemMax : int;
		private var _rowShowLine : Boolean;

		/**
		 * 构造函数
		 * 
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
		 * @param rowOverBgColor 行鼠标移入背景颜色
		 * @param rightColor 单元格右边线颜色
		 * @param topColor 单元格上边线颜色
		 * @param bottomColor 单元格下边线颜色
		 */
		public function Table(borderLeftColor : int, borderTopColor : int, borderBottomColor : int, borderRightColor : int, panel : ScrollPanel, cellTextNormalColor : int, cellTextHotColor : int, rowHeight : int, showLine : Boolean, rowBgColor : int, rowDoubleBgColor : int, leftColor : int, rowOverBgColor : int, rightColor : int, topColor : int, bottomColor : int, rowSelectedBg : Class, rowSelectedColor : int, itemMax : int, rowShowLine : Boolean = true)
		{
			_panel = panel;
			_panel.panel.cHeight = 0;
			_panel.resize();
			cHeight = rowHeight * itemMax;
			addChildEx(_panel);
			_borderBottomColor = borderBottomColor;
			_borderLeftColor = borderLeftColor;
			_borderRightColor = borderRightColor;
			_borderTopColor = borderTopColor;

			_cellTextNormalColor = cellTextNormalColor;
			_cellTextHotColor = cellTextHotColor;
			_showLine = showLine;
			_rowBgColor = rowBgColor;
			_row2BgColor = rowOverBgColor;
			_rowDoubleBgColor = rowDoubleBgColor;
			_rowSelectedColor = rowSelectedColor;

			_leftColor = leftColor;
			_rightColor = rightColor;
			_topColor = topColor;
			_bottomColor = bottomColor;
			_rowSelectedBg = rowSelectedBg;
			_rowHeight = rowHeight;
			_yOffset = 0;
			_cols = new Vector.<int>();
			_rows = new Vector.<Row>();

			_itemMax = itemMax;

			// 是否显示..表格竖线
			_rowShowLine = rowShowLine;
		}

		public function get maxItemNum() : int
		{
			return _itemMax;
		}

		/**
		 * 初始化事件
		 * 所有回调函数格式应该为 callback(id:String):void; id=当前行的ID
		 * 
		 * @param onClick 单击行
		 * @param onMouseOver 鼠标移动到行上
		 * @param onMouseOut 鼠标移出行
		 */
		public function initEvts(onClick : Function = null, onMouseOver : Function = null, onMouseOut : Function = null) : void
		{
			_initEvts = true;
			_onRowClick = onClick;
			_onRowMouseOut = onMouseOut;
			_onRowMouseOver = onMouseOver;
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
		public function initHeader(headerBg : MovieClip, headerHeight : int, cols : Vector.<KeyValue>, size : int, bgColor : int, textColor : int, bold : Boolean = false, showLine : Boolean = false, filters : Array = null, font : String = null, embed : Boolean = false, drawBorder : Boolean = true, autoHeight : Boolean = false, targets : Array = null) : void
		{
			_initHeader = true;

			// 表头高度.如果传入了背景图片.则忽略掉.headerHeight设定的值

			_headerHeight = headerBg == null ? headerHeight : headerBg.height;

			_header = new Row('', cols.length, bgColor, -1, headerBg, false);
			// 遍历传入的列信息
			for (var i : int = 0;i < cols.length;i++)
			{
				var col : KeyValue = cols[i];

				// 记录列宽
				_cols.push(col.value);
				//				//  生成文本单元格

				// var cell : TextCell = new TextCell(col.key, col.value, _headerHeight, size, textColor, textColor, _rowSelectedColor, bold, _leftColor, _rightColor, _topColor, _bottomColor, showLine, filters, font, embed);
				// cell.id = i;
				//
				//				//  加入单元格
				// _header.addCell(cell);
				// //////////////////////////////////////////////////////
				var cell : Cell;

				// 如果传入的是空.则生成一个空的cell(占位用)
				if (targets == null)
				{
					cell = new TextCell(col.key, col.value, _headerHeight, size, textColor, textColor, _rowSelectedColor, bold, _leftColor, _rightColor, _topColor, _bottomColor, showLine, filters, font, embed);
					(cell as TextCell).id = i;
				}
				else
				{
					var target : * = targets[i];
					// 其他对象.则生成单元格后.加入该对象
					cell = new Cell(col.value, _headerHeight, _showLine, _leftColor, _rightColor, _topColor, _bottomColor, _rowShowLine, _rowSelectedColor);

					cell.addChildCenter(target);

					// 保存数据
					cell.data = target;
				}

				// 加入单元格
				_header.addCell(cell);
			}

			addChildEx(_header);
			cHeight = cHeight + _header.cHeight;
			cWidth = _header.cWidth;
			_panel.y = _header.cHeight + _header.y;
			if (!autoHeight)
				_panel.cHeight = cHeight - _header.cHeight;
			else
				_panel.cHeight = 0;

			// 设置边线
			if (drawBorder)
			{
				var shape : Shape = new Shape();
				var width : int = cWidth;
				var height : int = cHeight - 1;

				shape.graphics.lineStyle(1, _borderRightColor, alpha);
				shape.graphics.moveTo(width, 0);
				shape.graphics.lineTo(width, height);

				shape.graphics.lineStyle(1, _borderTopColor, alpha);
				shape.graphics.moveTo(0, 0);
				shape.graphics.lineTo(width, 0);

				shape.graphics.lineStyle(1, _borderBottomColor, alpha);
				shape.graphics.moveTo(0, height + 1);
				shape.graphics.lineTo(width, height + 1);

				shape.graphics.lineStyle(1, _borderLeftColor, alpha);
				shape.graphics.moveTo(0, 0);
				shape.graphics.lineTo(0, height);
				addChild(shape);
			}
		}

		/**
		 * 加入空行.填满表格
		 */
		public function addNullRows() : void
		{
			// 行数
			var len : int = _itemMax - _rows.length;

			var row : Array = new Array(_cols.length);

			for (var i : int = 0 ; i < len ; i++)
			{
				addRow(Math.random().toString(), row, -1, null, 8, false);
			}
		}

		public function set head(show : Boolean) : void
		{
			_header.visible = show;
		}

		public function get head() : Boolean
		{
			return _header.visible;
		}

		/**
    	 * 增加一行
    	 * 
		 * @param id 行id
    	 * @param data 一行数据.内容为DisplayObject
		 * @param disClickIndex 禁用鼠标事件的列index(某一列禁用click事件)
		 * @param leftCols 左对齐的列index列表.从0开始
		 * @param margin 左对齐的间隔
    	 */
		public function addRow(id : String, data : Array, disClickIndex : int = -1, leftCols : Array = null, margin : int = 8, selected : Boolean = true, tip : CTip = null, setRowHeight : Number = -1, cellSelect : int = -1) : void
		{
			if (!_initEvts || !_initHeader)
			{
				throw new Error('表格没有完全初始化.请检查是否已经调用了initEvts和initHeader函数');
				return;
			}
			var bgColor : int = int(_rows.length % 2) == 0 ? _rowBgColor : _rowDoubleBgColor;
			var row : Row = new Row(id, _cols.length, bgColor, _row2BgColor, null, _row2BgColor >= 0, new _rowSelectedBg(), _rowSelectedColor);
			// 设定事件响应
			// 单击事件..
			if (selected && (_onRowClick != null || _rowSelectedBg != null))
			{
				row.evts.addClick(function(event : MouseEvent) : void
				{
					if (_onRowClick != null)
						_onRowClick(id);

					setRowSelect(id);

					event.stopImmediatePropagation();
					event.stopPropagation();
				});
			}
			if (_onRowMouseOut != null)
			{
				row.evts.mouseOut(function(event : MouseEvent) : void
				{
					_onRowMouseOut(id);
				});
			}
			if (_onRowMouseOver != null)
			{
				row.evts.mouseOver(function(event : MouseEvent) : void
				{
					_onRowMouseOver(id);
				});
			}
			// 遍历列.

			for (var i : int = 0;i < _cols.length;i++)
			{
				var col : int = _cols[i];
				var cell : Cell;
				var target : * = data[i];

				// 如果传入的是空.则生成一个空的cell(占位用)
				if (target == null)
				{
					cell = new Cell(col, _rowHeight, _showLine, _leftColor, _rightColor, _topColor, _bottomColor, _rowShowLine, _rowSelectedColor);
				}
				else if (target is MuiltTextInfo)
				{
					// 如果传入的是.文本/颜色1/颜色2 信息.则按照信息生成单元格
					var info : MuiltTextInfo = target;
					cell = new TextCell(info.title, col, _rowHeight, 12, info.normalColor, info.hotColor, info.selectColor, false, _leftColor, _rightColor, _topColor, _bottomColor, _showLine, info.filter, info.font, info.embed, _rowShowLine);
				}
				else if (target is String || data[i] is Number)
				{
					// 如果传入的是字符串/数字.则按照默认颜色生成单元格
					cell = new TextCell(target.toString(), col, _rowHeight, 12, _cellTextNormalColor, _cellTextHotColor, _rowSelectedColor, false, _leftColor, _rightColor, _topColor, _bottomColor, _showLine, null, null, false, _rowShowLine);
				}
				else
				{
					var cellRowHeight : Number = setRowHeight != -1 ? setRowHeight : _rowHeight;
					// 其他对象.则生成单元格后.加入该对象

					cell = new Cell(col, cellRowHeight, _showLine, _leftColor, _rightColor, _topColor, _bottomColor, _rowShowLine, _rowSelectedColor);

					cell.addChildCenter(target);

					// 保存数据
					cell.data = target;
				}

				// 判断是否是左对齐的列
				if (leftCols != null && leftCols.indexOf(i) >= 0 && cell.data != null)
				{
					if (cell.data != null)
					{
						cell.data.x = margin;
					}
				}

				// 禁用鼠标事件
				if (disClickIndex == i)
				{
					cell.evts.addClick(function(event : MouseEvent) : void
					{
						event.stopPropagation();
					});
				}

				if (cellSelect == i)
				{
					cell.select();
				}

				// 加入单元格

				row.addCell(cell);
			}
			_rows.push(row);
			_panel.addItem(row, 0, _yOffset);
			if (setRowHeight > -1)
			{
				// var lastChild:Row = _panel.panel.getChildAt(_panel.panel.numChildren-1) as Row;
				// _panel.panel.cHeight += lastChild.height;
				_panel.cHeight += setRowHeight;
				// cHeight = _panel.panel.cHeight;
				cHeight = _panel.cHeight + _header.cHeight;
				// _panel.cHeight = cHeight - _header.cHeight;
			}
			_yOffset += row.cHeight + 1;

			// 设置tip
			if (tip != null)
				TipHelper.setTip(row, tip);
		}

		public function get rowCount() : int
		{
			return _rows.length;
		}

		/**
		 * 设置某行被选择了
		 * 
		 * @param id 某行的id
		 */
		private function setRowSelect(id : String) : void
		{
			// 所有行的个数

			var len : int = _rows.length;

			var selected : Boolean = false;

			// 遍历之
			for (var i : int = 0; i < len; i++)
			{
				// 某行

				var row : Row = _rows[i];
				// 选择状态

				row.select = row.id == id;

				// 找到相关行.设定flag
				if (row.id == id)
				{
					selected = true;
				}
			}

			if (selected)
				_selectId = id;
		}

		public function setSelect(id : String, callback : Boolean = true) : void
		{
			setRowSelect(id);

			if (callback)
				_onRowClick(id);
		}

		public function get selectedId() : String
		{
			return _selectId;
		}

		/**
    	 * 清除所有行
    	 */
		public function removeAll() : void
		{
			for each (var row : Row in _rows)
			{
				row.removeSelf();
			}
			_yOffset = 0;
			_panel.panel.cHeight = 0;
			_panel.resize();
			_rows = new Vector.<Row>();
			_selectId = null;
		}

		/**
		 * 移除指定行
		 * 
		 * @param rowId 行id
		 */
		public function remove(rowId : String) : void
		{
			var len : int = _rows.length;
			for (var i : int = 0 ;i < len;i++)
			{
				var row : Row = _rows[i];
				if (row.id == rowId)
				{
					_yOffset -= row.cHeight;
					row.removeSelf();
					_rows.splice(i, 1);
					_panel.resize();
					break;
				}
			}
		}

		public function get header() : Row
		{
			return _header;
		}

		/**
		 * 行列表
		 */
		public function get rows() : Vector.<Row>
		{
			return _rows;
		}

		/**
		 * 获取指定行(通过index)
		 * 
		 * @param index index
		 */
		public function getRow(index : int) : Row
		{
			if (index < 0 || index > _rows.length)
				return null;
			return _rows[index];
		}

		/**
		 * 获取指定行(通过id)
		 * 
		 * @param id id
		 */
		public function getRowById(id : String) : Row
		{
			for (var i : int = 0; i < _rows.length; i++)
			{
				if ((_rows[i] as Row).id == id) return _rows[i];
			}

			return null;
		}

		public function get headerHeight() : int
		{
			return _headerHeight;
		}

		private var _onRowClick : Function;
		private var _onRowMouseOver : Function;
		private var _onRowMouseOut : Function;
		// 表格的列信息

		protected var _cols : Vector.<int>;
		// 行信息.

		private var _rows : Vector.<Row>;
	}
}
