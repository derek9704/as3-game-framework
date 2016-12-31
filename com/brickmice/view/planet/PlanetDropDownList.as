package com.brickmice.view.planet
{
	import com.framework.ui.component.DropDownList;
	import com.framework.utils.FilterUtils;
	
	/**
	 * @author derek
	 */
	public class PlanetDropDownList extends DropDownList {
		/**
		 * 下拉列表框
		 * 
		 * @param items 下拉框的内容.KeyValue数组.
		 * @param w 下拉框的宽度
		 * @param index 默认选择项的index
		 * @param onChanged 当改变了选项时的回调函数 格式: onChanged(title:String):void{};. title为被选中项的title
		 * @param down 下拉列表是否向下显示
		 */
		public function PlanetDropDownList(items:Array,onChanged:Function = null) {
			super(new ResPlanetDropdownBtn,12,76,20,items,0,onChanged,0x8A0000,0xEBDCAD,ResPlanetListHotBg,ResPlanetListBg,ResPlanetDropdownBg,true, null, null, -1, null, [FilterUtils.createGlow(0xE5DAC5, 500)]);
		}
	}
}
