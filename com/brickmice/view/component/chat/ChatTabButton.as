package com.brickmice.view.component.chat
{
	import com.framework.ui.component.TabPanel;
	import com.framework.utils.FilterUtils;
	
	import flash.text.TextFormat;
	
	/**
	 * 公共tabButton
	 * @author wuleiming
	 * 用addTab来添加按钮
	 */
	public class ChatTabButton extends TabPanel
	{
		public function ChatTabButton(callback:Function)
		{
			var format : TextFormat = new TextFormat();
			format.size = 12;
			format.color = 0x000000;
			 
			super(callback, ResChatTab, 3, true,0xe2cea9,0x950000,0xe2cea9, format, false, true, [FilterUtils.createGlow(0x000000, 500)]);
		}
	}
}