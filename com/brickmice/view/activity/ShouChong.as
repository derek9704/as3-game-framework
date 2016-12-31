package com.brickmice.view.activity
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McTip;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class ShouChong extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "ShouChong";
		
		private var _mc:MovieClip;
		
		public function ShouChong(data : Object)
		{
			_mc = new ResShouChongWindow;
			super(NAME, _mc);
			
			_mc._getBtn.buttonMode = true;
			_mc._getBtn.addEventListener(MouseEvent.CLICK, function():void{
				ModelManager.activityModel.getShouChongReward(closeWindow);
			});
			
			new BmButton(_mc._chargeBtn, function():void{
				navigateToURL(new URLRequest(Data.data.system.chargeUrl), "_blank");
			});
			TipHelper.setTip(_mc._chargeBtn, new McTip("是男人就来一发！"));
			
			var data:Object = Data.data.shouChong;
			_mc._getBtn.visible = data.flag == 1;
			_mc._chargeBtn.visible = data.flag == 0;
			
			var item:McItem = new McItem(data.reward[0].img, 0, data.reward[0].num);
			addChildEx(item, 227, 175);
			TipHelper.setTip(item, Trans.transTips(data.reward[0]));
			
			item = new McItem(data.reward[1].img, 0, data.reward[1].num);
			addChildEx(item, 312, 175);
			TipHelper.setTip(item, Trans.transTips(data.reward[1]));
			
			item = new McItem(data.reward[2].img, 0, data.reward[2].num);
			addChildEx(item, 398, 175);
			TipHelper.setTip(item, Trans.transTips(data.reward[2]));
			
			item = new McItem(data.reward[3].img, 0, data.reward[3].num);
			addChildEx(item, 270, 250);
			TipHelper.setTip(item, Trans.transTips(data.reward[3]));
			
			item = new McItem(data.reward[4].img, 0, data.reward[4].num);
			addChildEx(item, 356, 250);
			TipHelper.setTip(item, Trans.transTips(data.reward[4]));
		}
		
	}
}