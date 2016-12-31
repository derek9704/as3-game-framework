package com.framework.ui.component.table
{
	import com.framework.ui.component.RadioButton;
	import com.framework.ui.component.ScrollPanel;
	import com.framework.ui.sprites.CTip;
	import com.framework.utils.KeyValue;
	
	import flash.display.MovieClip;

	/**
	 * 带checkbox的表格.在构造函数中指定checkbox的位置(第一列/最后一列)
	 * 
	 * @author derek
	 */
	public class CheckBoxTable extends Table
	{
		private var _checkbox : Class;
		private var _left : Boolean;
		private var _checkboxs : Vector.<RadioButton>;
		private var _headerCheckbox : Boolean;

		/**
		 * 构造函数
		 * 
		 * @param left checkbox位置.是否在左边
		 * @param checkboxClass checkbox控件的类.
		 * @param headerCheckbox 表头是否有.checkbox.
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
		public function CheckBoxTable(left : Boolean, checkboxClass : Class, headerCheckbox : Boolean, borderLeftColor : int, borderTopColor : int, borderBottomColor : int, borderRightColor : int, panel : ScrollPanel, cellTextNormalColor : int, cellTextHotColor : int, rowHeight : int, showLine : Boolean, rowBgColor : int, rowDoubleBgColor : int, leftColor : int, row2BgColor : int, rightColor : int, topColor : int, bottomColor : int, selectedBg : Class, rowSelectedColor : int, itemMax : int, rowShowLine : Boolean = true)
		{
			super(borderLeftColor, borderTopColor, borderBottomColor, borderRightColor, panel, cellTextNormalColor, cellTextHotColor, rowHeight, showLine, rowBgColor, rowDoubleBgColor, leftColor, row2BgColor, rightColor, topColor, bottomColor, selectedBg, rowSelectedColor, itemMax, rowShowLine);

			_left = left;
			_checkbox = checkboxClass;
			_headerCheckbox = headerCheckbox;

			_checkboxs = new Vector.<RadioButton>();
		}

		/**
		 * 选择所有行/取消选择所有行
		 * 
		 * @param value 是否选择全部行
		 */
		public function selectAll(value : Boolean) : void
		{
			for each (var checkbox : RadioButton in _checkboxs)
			{
				checkbox.select = value;
			}
		}
		
		/**
		 * 选择/取消指定行
		 * @param id
		 * @param value 是否选择
		 */
		public function selectRow(id:String, value : Boolean) : void
		{
			for each (var checkbox : RadioButton in _checkboxs)
			{
				if(id == checkbox.id)
					checkbox.select = value;
			}
		}

		/**
		 * 获取所有已经被选择行的id
		 */
		public function selectedRow() : Vector.<String>
		{
			var result : Vector.<String> = new Vector.<String>();

			for each (var checkbox : RadioButton in _checkboxs)
			{
				if (checkbox.select)
					result.push(checkbox.id);
			}

			return result;
		}

		/**
		 * 清除所有行
		 */
		override public function removeAll() : void
		{
			_checkboxs = new Vector.<RadioButton>();
			super.removeAll();
		}

		/**
		 * 加入新行
		 * 
		 * @param id 行id
		 * @param data 行数据(注意!不要有checkbox列.如checkbox在第一列.则data数据为第二列-最后一列的数据
		 * 				如果checkbox在最后一列.则data数据为第一列到 倒数第二列的数据).
		 * @param disClickIndex 本参数仅为override使用.无任何意义
		 */
		override public function addRow(id : String, data : Array, disClickIndex : int = -1, left : Array = null, margin : int = 0, selected : Boolean = false, tip : com.framework.ui.sprites.CTip = null, setRowHeight : Number = -1, cellSeletc : int = -1) : void
		{
			var checkbox : RadioButton = new _checkbox('', null, false, id);

			_checkboxs.push(checkbox);

			if (_left)
			{
				data.unshift(checkbox);
				disClickIndex = 0;
			}
			else
			{
				data.push(checkbox);
				disClickIndex = data.length - 1;
			}

			super.addRow(id, data, disClickIndex, [disClickIndex], 8, selected, tip, setRowHeight, cellSeletc);
		}

		override public function addNullRows() : void
		{
			// 行数
			var len : int = _itemMax - rows.length;

			var row : Array = new Array(_cols.length);

			for (var i : int = 0 ; i < len ; i++)
			{
				super.addRow(Math.random().toString(), row, -1, null, 8, false);
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
		override public function initHeader(headerBg : MovieClip, headerHeight : int, cols : Vector.<KeyValue>, size : int, bgColor : int, textColor : int, bold : Boolean = false, showLine : Boolean = false, filters : Array = null, font : String = null, embed : Boolean = false, drawBorder : Boolean = true, autoHeight : Boolean = false, targets : Array = null) : void
		{
			super.initHeader(headerBg, headerHeight, cols, size, bgColor, textColor, bold, showLine, filters, font, embed, drawBorder, autoHeight, targets);

			if (!_headerCheckbox)
				return;

			var checkbox : RadioButton = new _checkbox('', function(select : Boolean) : void
			{
				selectAll(select);
			}, false);

			var index : int = _left ? 0 : header.colNum - 1;

			// 加入checkbox
			header.getCell(index).addChildV(checkbox, 8);
		}
	}
}
