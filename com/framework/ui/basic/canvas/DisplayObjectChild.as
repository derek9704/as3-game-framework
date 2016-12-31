package com.framework.ui.basic.canvas
{
	import flash.display.*;

	/**
	 * 随着stage自动修改位置的displayobject对象
	 * @author derek
	 */
	public class DisplayObjectChild
	{
		// x方向偏移量
		public var xOffset:int;
		// y方向偏移量
		public var yOffset:int;
		public var object:*;
		public var xCenter:Boolean;
		public var yCenter:Boolean;
		public var align:int;

		public function DisplayObjectChild(o:DisplayObject, x:int, y:int, xCenter:Boolean = false, yCenter:Boolean = false, align:int = -1)
		{
			this.object = o;
			this.xOffset = x;
			this.yOffset = y;
			this.xCenter = xCenter;
			this.yCenter = yCenter;
			if(align == -1) align = CCanvas.lt;
			this.align = align;
		}
	}
}
