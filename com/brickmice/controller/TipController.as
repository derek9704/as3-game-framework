package com.brickmice.controller
{
	import com.brickmice.Main;
	import com.brickmice.view.component.layer.TipLayer;
	import com.framework.ui.sprites.CTip;

	/**
	 * tip显示相关逻辑
	 *
	 * @author derek
	 */
	public class TipController
	{
		// 显示tip
		public function showTip(tip:CTip):void
		{
			var tipLayer:TipLayer = Main.self.tipLayer;
			// 获取数据
			tip.getData();
			// 定位
			var x:int = tipLayer.mouseX + 10;
			var y:int = tipLayer.mouseY + 10;
			// 位置偏移
			if (x + tip.cWidth > tipLayer.cWidth)
				x -= tip.cWidth;
			if (y + tip.cHeight > tipLayer.cHeight)
				y = tipLayer.cHeight - tip.cHeight - 20;
			tipLayer.addChildEx(tip, x, y);
		}

		// 隐藏tip
		public function hideTip(tip:CTip):void
		{
			var tipLayer:TipLayer = Main.self.tipLayer;
			tipLayer.removeChild(tip);
		}

		// 清空所有tip
		public function clear():void
		{
			var tipLayer:TipLayer = Main.self.tipLayer;
			tipLayer.removeAllChildren();
		}
	}
}
