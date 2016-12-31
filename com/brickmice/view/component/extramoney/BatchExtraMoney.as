package com.brickmice.view.component.extramoney
{
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmInputBox;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McTip;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;

	public class BatchExtraMoney extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "BatchExtraMoney";
		
		private var _mc:MovieClip;
		
		public function BatchExtraMoney(callback:Function)
		{
			_mc = new ResExtraMoneyMoreWindow;
			super(NAME, _mc);
			
			var data:Object = Data.data.extraMoney;
			var count:int = data['maxCount'] - data['usedCount'];
			var iniCount:int = count > 10 ? 10 : count;
			
			var input:BmInputBox = new BmInputBox(_mc._count, iniCount.toString(), -1, true, count, 1);
			input.onNumChange = function(num:int):void{
				setCount(num);
			};
			Main.self.stage.focus = _mc._count;
			_mc._count.setSelection(iniCount.toString().length, iniCount.toString().length);	
			
			setCount(iniCount);
			
			TipHelper.setTip(_mc._count, new McTip('10次批量外快会获得10%的加成'));
			
			new BmButton(_mc._yes, function() : void
			{
				if(_mc._count.text == 0) closeWindow();
				else
				ModelManager.activityModel.finishExtraMoney(int(_mc._count.text), function():void{
					callback();
					closeWindow();
				});
			});
			
			new BmButton(_mc._minusBtn, function() : void
			{
				var num:int = int(_mc._count.text);
				num --;
				setCount(num);
			});
			
			new BmButton(_mc._addBtn, function() : void
			{
				var num:int = int(_mc._count.text);
				num ++;
				setCount(num);
			});
		}
		
		private function formula(count:int):int
		{
			if(count < 10) return count * 2;
			if(count >= 10 && count < 30) return 20;
			if(count >= 30 && count < 50) return 50;
			if(count >= 50 && count < 100) return 100;
			if(count >= 100 && count < 500) return 200;
			else return 1; //你赢了！
		}
		
		private function setCount(count:int):void
		{
			var data:Object = Data.data.extraMoney;
			var gainCoins:int = data['gainCoins'];
			var maxCount:int = data['maxCount'] - data['usedCount'];
			
			if(count < 1) count = 1;
			if(count > maxCount) count = maxCount;
			
			_mc._count.text = count.toString();
			
			var getCoins:int = count * gainCoins;
			if(count >= 10) getCoins = Math.floor(getCoins * 1.1);
			_mc._coins.text = getCoins.toString();
			
			var golden:int = 0;
			for (var i:int = data['usedCount'] + 1; i < count + data['usedCount'] + 1; i++) 
			{
				golden += formula(i);	
			}
			_mc._Golden.text = golden.toString();
		}
	}
}