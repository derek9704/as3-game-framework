package com.brickmice.view.component.extramoney
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.ViewManager;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class ExtraMoney extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "ExtraMoney";
		
		private var _mc:MovieClip;
		
		public function ExtraMoney(data : Object)
		{
			_mc = new ResExtraMoneyWindow;
			super(NAME, _mc);
			
			new BmButton(_mc._Btn, function() : void
			{
				ModelManager.activityModel.finishExtraMoney(1, setData);
			});
			
//			new BmButton(_mc._Btn2, function() : void
//			{
//				if (ViewManager.hasView(BatchExtraMoney.NAME)) return;
//				var batchExtraMoneyWin:BmWindow = new BatchExtraMoney(setData);
//				addChildCenter(batchExtraMoneyWin);
//			});
			_mc._Btn2.visible = false;
			
			setData();
			
			//新手指引
//			NewbieController.showNewBieBtn(41, 2, this, 412, 189, false, "花费宇宙钻赚取外快");
		}
		
		public function setData() : void
		{
			var data:Object = Data.data.extraMoney;
			_mc._cost.text = data['cost'];
			_mc._coins.text = data['gainCoins'];
			_mc._chance.text = data['maxCount'] - data['usedCount'];
		}
	}
}