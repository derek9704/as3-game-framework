package com.brickmice.view.component
{
	import com.framework.ui.component.DropDownList;
	
	/**
	 * @author derek
	 */
	public class McDropDownList extends DropDownList {
		/**
		 * 下拉列表框
		 * 
		 * @param items 下拉框的内容.KeyValue数组.
		 * @param w 下拉框的宽度
		 * @param index 默认选择项的index
		 * @param onChanged 当改变了选项时的回调函数 格式: onChanged(title:String):void{};. title为被选中项的title
		 */
		public function McDropDownList(items:Array,w:uint = 170, h:uint =17, index:int = 0,onChanged:Function = null) {
			super(new ResDropdownBtn,12,w, h, items,index,onChanged,0xF8EED5,0xFF0000,ResDropdownBg,ResDropdownBg,ResDropdownBg,true);
		}
	}
}
