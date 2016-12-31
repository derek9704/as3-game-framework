package com.brickmice.view.gift
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McItem;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;

	public class ConsumePackage
	{
		private var _getBtn1:BmButton;
		private var _getBtn2:BmButton;
		private var _item1:McItem;
		private var _item2:McItem;
		private var _item3:McItem;
		private var _item4:McItem;
		private var _item5:McItem;
		private var _expWidth:int;
		
		public function ConsumePackage(_package:MovieClip)
		{
			_getBtn1 = new BmButton(_package._getBtn1, function():void{
				ModelManager.activityModel.getDailyConsumeReward(1, function():void{
					_getBtn1.enable = false;
				});
			});
			
			_getBtn2 = new BmButton(_package._getBtn2, function():void{
				ModelManager.activityModel.getDailyConsumeReward(2, function():void{
					_getBtn2.enable = false;
				});
			});

			var data:Object = Data.data.dailyGift;
			
			_item1 = new McItem(data['reward3'][0]['img'], 0, data['reward3'][0]['num']);
			TipHelper.setTip(_item1, Trans.transTips(data['reward3'][0]));
			_item1.x = 55;
			_item1.y = 42;
			
			_item2 = new McItem(data['reward3'][1]['img'], 0, data['reward3'][1]['num']);
			TipHelper.setTip(_item2, Trans.transTips(data['reward3'][1]));
			_item2.x = 145;
			_item2.y = 42;
			
			_item3 = new McItem(data['reward4'][0]['img'], 0, data['reward4'][0]['num']);
			TipHelper.setTip(_item3, Trans.transTips(data['reward4'][0]));
			_item3.x = 55;
			_item3.y = 172;
			
			_item4 = new McItem(data['reward4'][1]['img'], 0, data['reward4'][1]['num']);
			TipHelper.setTip(_item4, Trans.transTips(data['reward4'][1]));
			_item4.x = 145;
			_item4.y = 172;
			
			_item5 = new McItem(data['reward4'][2]['img'], 0, data['reward4'][2]['num']);
			TipHelper.setTip(_item5, Trans.transTips(data['reward4'][2]));
			_item5.x = 236;
			_item5.y = 172;
			
			_package.addChild(_item1);
			_package.addChild(_item2);
			_package.addChild(_item3);
			_package.addChild(_item4);
			_package.addChild(_item5);
			
			_expWidth = _package._exp2.width;
			
			if(data.dailyConsume == null) data.dailyConsume = 0;
			_getBtn1.enable = (data.dailyConsumeReward1Got == 0 || data.dailyConsumeReward1Got == null) && data.dailyConsume > 0;
			_getBtn2.enable = (data.dailyConsumeReward2Got == 0 || data.dailyConsumeReward2Got == null) && data.dailyConsume >= 500;
			_package._exp1.visible = data.dailyConsume > 0;
			
			var rate:Number = data.dailyConsume / 500;
			if(rate > 1) rate = 1;
			_package._exp2.width = _expWidth * rate;
			_package._expDetailed2.text = data.dailyConsume + ' / 500  (' + (int(data.dailyConsume) * 100 / 500).toFixed(2).toString()  + '%)';
		}
	}
}