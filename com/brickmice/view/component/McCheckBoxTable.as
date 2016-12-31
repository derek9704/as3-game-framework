package com.brickmice.view.component
{
	import com.framework.ui.component.table.CheckBoxTable;
	import com.framework.utils.KeyValue;
	

	/**
	 * @author derek
	 */
	public class McCheckBoxTable extends CheckBoxTable
	{
		/**
		 * 带checkbox.可以全选/部分选择的表格
		 * 
		 * @param leftAlign checkbox是否在最左边
		 * @param headerCheckbox 表头是否显示checkbox
		 * @param height 表格高度
		 * @param cols 列信息 KeyValue内容为 key = 列头文本; value = 列宽度
		 * @param onRowClick 当某行被单击后的回调函数.格式为 callback(id:String):void{}; id为事件触发行的id
		 * @param onRowMouseOver 当鼠标移入某行后的回调函数.格式为 callback(id:String):void{}; id为事件触发行的id
		 * @param onRowMouseOut 当鼠标移出某行后的回调函数.格式为 callback(id:String):void{}; id为事件触发行的id
		 */
		public function McCheckBoxTable(leftAlign : Boolean, headerCheckbox : Boolean, height : int, cols : Vector.<KeyValue>, onRowClick : Function = null, onRowMouseOver : Function = null, onRowMouseOut : Function = null, rowHeight : int = 24, showLine : Boolean = true, rowShowLine : Boolean = false, headerHeight : int = 24)
		{
			// 表格的总宽度
			var totalWidth : int = 0;
			// 遍历所有列信息.计算出表格宽度
			for (var i : int = 0; i < cols.length; i++)
			{
				totalWidth += cols[i].value;
			}

			var maxItem : int = height / rowHeight;

			// 构造之
			super(leftAlign, McCheckBox, headerCheckbox, BORDER_LEFT_COLOR, BORDER_LEFT_COLOR, BORDER_BOTTOM_COLOR, BORDER_BOTTOM_COLOR, new McPanel('', totalWidth, height), TEXT_NORMAL_COLOR, TEXT_HOT_COLOR, rowHeight, showLine, ROW_BG_COLOR, ROW_BG_COLOR2, CELL_LEFT_COLOR, ROW_OVER_BG_COLOR, CELL_RIGHT_COLOR, CELL_LEFT_COLOR, CELL_BOTTOM_COLOR,ResSelectedTableBg, ROW_SELECTED_COLOR, maxItem, rowShowLine);
			
			// 初始化事件
			initEvts(onRowClick, onRowMouseOver, onRowMouseOut);

			// 初始化表头
			initHeader(null, headerHeight, cols, 12, HEADER_COLOR, HEADER_TEXT_COLOR, false, false, null, null, false, false);
		}

		private static const BORDER_LEFT_COLOR : int = -1;
		private static const BORDER_BOTTOM_COLOR : int = -1;
		private static const TEXT_NORMAL_COLOR : int = -1;
		private static const TEXT_HOT_COLOR : int = -1;
		private static const ROW_BG_COLOR : int = -1;
		private static const ROW_BG_COLOR2 : int = -1;
		private static const CELL_LEFT_COLOR : int = -1;
		private static const CELL_RIGHT_COLOR : int = 0x000000;
		private static const ROW_OVER_BG_COLOR : int = -1;
		private static const ROW_SELECTED_COLOR : int = -1;
		private static const HEADER_COLOR : int = -1;
		private static const HEADER_TEXT_COLOR : int = -1;
		private static const CELL_BOTTOM_COLOR : int = 0x000000;
	}
}
