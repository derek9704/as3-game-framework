package com.brickmice.view.component.chat
{
	import com.framework.ui.component.DropDownList;
	import com.framework.utils.FilterUtils;
	
	/**
	 * @author derek
	 */
	public class ChatDropDownList extends DropDownList {
		/**
		 * 下拉列表框
		 * 
		 * @param items 下拉框的内容.KeyValue数组.
		 * @param w 下拉框的宽度
		 * @param index 默认选择项的index
		 * @param onChanged 当改变了选项时的回调函数 格式: onChanged(title:String):void{};. title为被选中项的title
		 * @param down 下拉列表是否向下显示
		 */
		public function ChatDropDownList(items:Array,w:uint,h:uint,index:int,onChanged:Function = null,down:Boolean = false) {
			super(null,12,w,h,items,index,onChanged,0x000000,0xF2EDC8,ResChatListHotBg,ResChatListBg,ResChatDropDownBtn,down, null, null, -1, null, [FilterUtils.createGlow(0xF2EDC8, 500)]);
		}
	}
}
