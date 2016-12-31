package com.brickmice.view.component.prompt
{
	import com.brickmice.Main;
	import com.brickmice.view.component.McLabel;
	import com.framework.utils.FilterUtils;
	import com.framework.utils.greensock.TweenLite;

	/**
	 * 
	 * @author derek
	 */
	public class TextMessage
	{
		private static var _label1:McLabel = null;
		private static var _label2:McLabel = null;
		
		/**
		 * 显示飘飘字
		 * @param txt
		 * @param type  1：增益绿色，2：减益红色
		 */
		public static function showEffect(txt : String, type : int) : void
		{
			if(txt == '') return;
			
			var label:McLabel;
			if(type == 1){
				if(!_label1){
					_label1 = new McLabel(txt, 0x73c755, "center", 500, 50, 20, false, [FilterUtils.createGlow(0x000000, 8)]);
				}
				label = _label1
			}else if(type == 2){
				if(!_label2){
					_label2 = new McLabel(txt, 0xde1a18, "center", 500, 50, 20, false, [FilterUtils.createGlow(0x000000, 8)]);
				}
				label = _label2
			}
			
			label.htmlText = "<b>" + txt + "</b>";
			if (label.parent != null){
				Main.self.tipLayer.removeChild(label);
				TweenLite.killTweensOf(label);
			}
			
			Main.self.tipLayer.addChildCenter(label);

			var moveOut : Function = function() : void
			{
				TweenLite.to(label, 2, {y:label.y - 100, onComplete:function() : void
				{
					if (label.parent != null)
						Main.self.tipLayer.removeChild(label);
				}});
			};

			moveOut();
		}
	}
}