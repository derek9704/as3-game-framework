package com.brickmice.view.gift
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McItem;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;

	public class ChargePackage
	{
		private var _getBtn1:BmButton;
		private var _getBtn2:BmButton;
		private var _item1:McItem;
		private var _item2:McItem;
		private var _item3:McItem;
		private var _item4:McItem;
		private var _item5:McItem;
		private var _expWidth:int;
		
		public function ChargePackage(_package:MovieClip)
		{
			_getBtn1 = new BmButton(_package._getBtn1, function():void{
				ModelManager.activityModel.getDailyChargeReward(1, function():void{
					_getBtn1.enable = false;
				});
			});
			
			_getBtn2 = new BmButton(_package._getBtn2, function():void{
				ModelManager.activityModel.getDailyChargeReward(2, function():void{
					_getBtn2.enable = false;
				});
			});

			var data:Object = Data.data.dailyGift;
			
			_item1 = new McItem(data['reward1'][0]['img'], 0, data['reward1'][0]['num']);
			TipHelper.setTip(_item1, Trans.transTips(data['reward1'][0]));
			_item1.x = 55;
			_item1.y = 42;
			
			_item2 = new McItem(data['reward1'][1]['img'], 0, data['reward1'][1]['num']);
			TipHelper.setTip(_item2, Trans.transTips(data['reward1'][1]));
			_item2.x = 145;
			_item2.y = 42;
			
			_item3 = new McItem(data['reward2'][0]['img'], 0, data['reward2'][0]['num']);
			TipHelper.setTip(_item3, Trans.transTips(data['reward2'][0]));
			_item3.x = 55;
			_item3.y = 172;
			
			_item4 = new McItem(data['reward2'][1]['img'], 0, data['reward2'][1]['num']);
			TipHelper.setTip(_item4, Trans.transTips(data['reward2'][1]));
			_item4.x = 145;
			_item4.y = 172;
			
			_item5 = new McItem(data['reward2'][2]['img'], 0, data['reward2'][2]['num']);
			TipHelper.setTip(_item5, Trans.transTips(data['reward2'][2]));
			_item5.x = 236;
			_item5.y = 172;
			
			_package.addChild(_item1);
			_package.addChild(_item2);
			_package.addChild(_item3);
			_package.addChild(_item4);
			_package.addChild(_item5);
			
			_expWidth = _package._exp2.width;
			
			if(data.dailyCharge == null) data.dailyCharge = 0;
			_getBtn1.enable = data.dailyChargeReward1Got == 0 && data.dailyCharge > 0;
			_getBtn2.enable = data.dailyChargeReward2Got == 0 && data.dailyCharge >= 1000;
			_package._exp1.visible = data.dailyCharge > 0;
			
			var rate:Number = data.dailyCharge / 1000;
			if(rate > 1) rate = 1;
			_package._exp2.width = _expWidth * rate;
			_package._expDetailed2.text = data.dailyCharge + ' / 1000  (' + (int(data.dailyCharge) * 100 / 1000).toFixed(2).toString()  + '%)';
		}
	}
}