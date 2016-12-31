package com.framework.ui.component.table
{
	import com.framework.ui.basic.sprite.CSprite;
	
	import flash.display.Sprite;

	/**
	 * 单元格
	 * 
	 * @author derek
	 */
	public class Cell extends com.framework.ui.basic.sprite.CSprite
	{
		private var _data : *;
		private var _selectMask : Sprite;

		/**
		 * 生成一个单元格
		 * 如果showLine = true
		 * 单元格的边线使用的是构造函数传入的参数
		 * 
		 * @param width 单元格宽度
		 * @param height 单元格高度
		 * @param showLine 是否显示边线
		 * @param leftColor 左边线颜色
		 * @param rightColor 右边线颜色
		 * @param topColor 上边线颜色
		 * @param bottomColor 下边线颜色
		 */
		public function Cell(width : int, height : int, showLine : Boolean, leftColor : int, rightColor : int = -1, topColor : int = -1, bottomColor : int = -1, rowShowLine : Boolean = true, selectColor : int = -1) : void
		{
			width--;
			height--;

			cWidth = width;
			cHeight = height;

			// 以透明色画一个背景
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();

			_selectMask = new Sprite();
			_selectMask.graphics.beginFill(selectColor, 1);
			_selectMask.graphics.drawRect(0, 0, width - 2, height - 2);
			_selectMask.graphics.endFill();
			_selectMask.visible = false;
			addChildEx(_selectMask, 1, 1);

			var alpha : int = 1;

			// 是否有边线
			if (!showLine)
			{
				// 使用alpha = 0来划线
				// 是为了解决如果不划线.莫名其妙的.这个各自会小 2像素...诡异啊诡异
				alpha = 0;
			}

			// 如果没有指定其他边颜色.则使用leftColor来画边
			if (rightColor == -1)
			{
				graphics.lineStyle(1, leftColor, alpha);
				graphics.drawRect(0, 0, width, height);
			}
			else
			{
				graphics.lineStyle(1, topColor, alpha);
				graphics.moveTo(0, 0);
				graphics.lineTo(width + 1, 0);

				graphics.lineStyle(1, bottomColor, alpha);
				graphics.moveTo(0, height);
				graphics.lineTo(width + 1, height);

				// 不显示两边线
				if (!rowShowLine)
					return;

				graphics.lineStyle(1, rightColor, alpha);
				graphics.moveTo(width, 0);
				graphics.lineTo(width, height);

				graphics.lineStyle(1, leftColor, alpha);
				graphics.moveTo(0, 0);
				graphics.lineTo(0, height);
			}
		}

		/**
		 * 设置为普通状态
		 */
		public function normal() : void
		{
			_selectMask.visible = false;
		}

		public function select() : void
		{
			_selectMask.visible = true;
		}

		/**
		 * 单元格中保存的数据
		 */
		public function get data() : *
		{
			return _data;
		}

		/**
		 * 单元格中保存的数据
		 */
		public function set data(value : *) : void
		{
			_data = value;
		}
	}
}
