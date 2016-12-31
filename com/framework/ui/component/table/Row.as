package com.framework.ui.component.table
{
	import com.framework.ui.basic.sprite.CSprite;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 表格行
	 * 
	 * @author derek
	 */
	public class Row extends CSprite
	{
		private var _colsNum : int;
		private var _cells : Vector.<Cell>;
		private var _max : int;
		/**
		 * 表格行ID
		 */
		public var id : String;
		private var _selectedBg : MovieClip;
		private var _rowSelectedColor : int;

		/**
		 * 构造函数
		 * 
		 * @param id id
		 * @param max 行最大列数
		 * @param bgColor 背景颜色
		 * @param hotColor 鼠标移入的颜色
		 * @param bgDo 背景do
		 * @param hot 是否允许显示鼠标移入颜色
		 */
		public function Row(id : String, max : int, bgColor : int, hotColor : int, bgDo : DisplayObject, hot : Boolean, selectedBg : MovieClip = null, rowSelectedColor : int = -1)
		{
			// 默认0大小
			super('', 0, 0);

			this.id = id;

			// 每行最大列数
			_max = max;
			// 当前列数
			_colsNum = 0;
			// 所有单元格
			_cells = new Vector.<Cell>();

			// 如果指定了背景.则使用背景
			// 否则使用背景颜色填充(背景颜色 > 0 .背景颜色 = -1则没有背景颜色)
			if (bgDo != null)
			{
				addChild(bgDo);
			}
			else if (bgColor >= 0)
			{
				bg.setStyle(bgColor);
			}

			// 被选择后的背景
			if (selectedBg != null)
			{
				_selectedBg = selectedBg;
				_rowSelectedColor = rowSelectedColor;
				addChild(selectedBg);
				selectedBg.visible = false;
			}

			// 如果不允许hotcolor,则直接返回
			if (!hot)
				return;

			evts.addEventListener(MouseEvent.ROLL_OUT, function(event : MouseEvent) : void
			{
				// 如果没有指定背景,则进行背景颜色的设置
				if (bgDo == null)
				{
					// 如果指定了背景颜色就使用该颜色.
					// 否则清除背景
					if (bgColor >= 0)
						bg.setStyle(bgColor);
					else
						bg.clear();
				}

				// 如果本行被选中.则不进行文本颜色的修改
				if (_selectedBg != null && _selectedBg.visible)
					return;

				// 设置所有textcell的状态
				for (var i : int = 0; i < _cells.length; i++)
				{
					if (_cells[i] is TextCell)
					{
						(_cells[i] as TextCell).normal();
					}
				}
			});

			evts.addEventListener(MouseEvent.ROLL_OVER, function(event : MouseEvent) : void
			{
				if (bgDo == null)
					bg.setStyle(hotColor);

				if (_selectedBg != null && _selectedBg.visible)
					return;

				for (var i : int = 0; i < _cells.length; i++)
				{
					if (_cells[i] is TextCell)
					{
						(_cells[i] as TextCell).hot();
					}
				}
			});
		}

		/**
		 * 被选择背景是否显示
		 */
		public function set select(val : Boolean) : void
		{
			if (_selectedBg != null)
			{
				_selectedBg.visible = val;

				for (var i : int = 0; i < _cells.length; i++)
				{
					if (_cells[i] is TextCell)
					{
						if (val)
							(_cells[i] as TextCell).select();
						else
							(_cells[i] as TextCell).normal();
					}
				}
			}
		}

		/**
		 * 列的数量
		 */
		public function get colNum() : int
		{
			return _cells.length;
		}

		/**
		 * 获取指定INDEX的单元格
		 * 
		 * @param index 
		 */
		public function getCell(index : int) : Cell
		{
			return _cells[index];
		}

		/**
		 * 增加一列
		 * 
		 * @param cell 单元格
		 */
		public function addCell(cell : Cell) : void
		{
			if (_colsNum >= _max)
			{
				throw new Error('已经不能添加列了');
				return;
			}

			addChildV(cell, cWidth);
			cWidth += cell.cWidth + 1;

			// 如果有被选择背景.则修改背景宽度
			if (_selectedBg != null)
				_selectedBg.width = cWidth;

			_cells.push(cell);
			_colsNum++;

			// 修改高度
			if (cell.cHeight > cHeight)
			{
				cHeight = cell.cHeight;

				if (_selectedBg != null)
					_selectedBg.height = cHeight;
			}

			// 修改所有控件的高度
			var len : int = _cells.length;

			for (var i : int = 0; i < len; i++)
			{
				_cells[i].y = (cHeight - _cells[i].cHeight) / 2;
			}
		}
	}
}
