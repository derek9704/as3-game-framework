package com.brickmice.view.vip
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McPanel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class Vip extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Vip";
		
		private var _mc:MovieClip;
		
		private var _panel : McPanel;
		
		public function Vip(data : Object)
		{
			_mc = new ResVipWindow;
			super(NAME, _mc);
			
			new BmButton(_mc._payBtn, function():void{
				ControllerManager.blueSunController.showBlueSun('gift');
			});
			
			_mc._vip.gotoAndStop(int(Data.data.user.vip) + 1);
			
			//经验条
			var upgradeVipExp:int = Data.data.user.upgradeVipExp * 10;
			var vipExp:int = Data.data.user.vipExp * 10;
			_mc._goldenLevel.width = vipExp / upgradeVipExp * _mc._goldenLevel.width;
			var msg:String = vipExp + ' / ' + upgradeVipExp;
			_mc._goldenLevelNum.text = msg;
			
			_mc._golden.text = upgradeVipExp;
			_mc._vipLvl.text = Data.data.user.vip + (Data.data.user.vip == 12 ? 0 : 1);
			
			setData();
		}
		
		public function setData() : void
		{
			// 面板
			_panel = new McPanel('', 756, 260);
			addChildEx(_panel, 26, 99);
			_panel.addItem(new ResVipDetailed, 0, 0);
		}
	}
}