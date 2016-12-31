package com.brickmice.view.solar
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.framework.core.ViewManager;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.MovieClip;

	public class SolarProxyWin extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "SolarProxyWin";
		
		private var _mc:MovieClip;
		
		public function SolarProxyWin(data:Object)
		{
			_mc = new ResSolarProxyWinWindow;
			super(NAME, _mc);
			
			_mc._exp.text = data.dropExp;
			_mc._coins.text = data.dropCoins;
			if(data.dropCentrifuge){
				_mc._count.text = data.dropCentrifuge;
			}else{
				_mc._count.text = '0';
			}
			if(data.dropTalentStone){
				_mc._stone.text = data.dropTalentStone;
			}else{
				_mc._stone.text = '0';
			}
			if(data.dropGolden){
				_mc._golden.text = data.dropGolden;
			}else{
				_mc._golden.text = '0';
			}
			
			new BmButton(_mc._yesBtn, function():void{
				closeWindow();
			});
			
			_mc._itemCount1.text = '';
			_mc._itemCount2.text = '';
			_mc._itemCount3.text = '';
			var i:int = 1;
			var equipImg:McImage;
			for each (var o:Object in data.dropEquip) 
			{
				_mc['_equip' + i].text = o.name;
				_mc['_itemCount' + i].text = o.num;
				equipImg = new McImage(o.img);
				if(i == 1){
					addChildEx(equipImg, 86, 135);
				}else if(i == 2){
					addChildEx(equipImg, 285, 135);
				}else{
					addChildEx(equipImg, 86, 232);
				}
				TipHelper.setTip(equipImg, Trans.transTips(o));
				i++;
			}
		}

	}
}