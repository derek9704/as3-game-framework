package com.brickmice.view.solar
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.battle.Battle;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.framework.core.ViewManager;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.MovieClip;

	public class SolarWin extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "SolarWin";
		
		private var _mc:MovieClip;
		
		public function SolarWin(level:int, pid:int, pName:String, data:Object)
		{
			_mc = new ResSolarWinWindow;
			super(NAME, _mc);
			
			var pid2:int = pid;
			_mc._exp.text = data.dropExp;
			_mc._coins.text = data.dropCoins;
			if(data.dropCentrifuge){
				_mc._count.text = data.dropCentrifuge;
			}
			if(data.dropGolden){
				_mc._golden.text = data.dropGolden;
			}
			if(data.dropTalentStone){
				_mc._stone.text = data.dropTalentStone;
			}		
			if(data.dropEquip){
				_mc._equip.text = data.dropEquip.name;
				var equipImg:McImage = new McImage(data.dropEquip.img, function():void{
					equipImg.width = 44;
					equipImg.height = 44;	
				});
				addChildEx(equipImg, 106, 284);
				TipHelper.setTip(equipImg, Trans.transTips(data.dropEquip));
			}
			
			new BmButton(_mc._cancelBtn, function():void{
				(ViewManager.retrieveView(Battle.NAME) as Battle).closeWindow();
				closeWindow();
				(ViewManager.retrieveView(SolarRaid.NAME) as SolarRaid).closeWindow();
				//刷新新手
				NewbieController.refreshNewBieBtn(4, 12, false, true);
				NewbieController.refreshNewBieBtn(5, 9, false, true);
			});
			new BmButton(_mc._repeatBtn, function():void{
				(ViewManager.retrieveView(SolarRaid.NAME) as SolarRaid).setData(pid, pName);
				(ViewManager.retrieveView(Battle.NAME) as Battle).closeWindow();
				closeWindow();
			});
			//下一关
			if(level < 15) {
				level += 1;
			}
			else {
				if(pid % 10 == 0) {
					UiUtils.setButtonEnable(_mc._nextBtn, false);
				}
				else{
					level = 1;
					pid2 += 1;
				}
			}
			new BmButton(_mc._nextBtn, function():void{
				ModelManager.solarModel.getSolarLevelData(pid2, level, function():void
				{	
					var gid:int = Math.floor((pid2 - 1) / 10) + 1;
					var pName:String = Data.data.solar.galaxy[gid].planet[pid2].name;
					(ViewManager.retrieveView(SolarRaid.NAME) as SolarRaid).setData(pid2, pName);
					(ViewManager.retrieveView(Battle.NAME) as Battle).closeWindow();
					closeWindow();
				});
			});
			
			if(data.type != 1){
				_mc._repeatBtn.visible = false;
				_mc._nextBtn.visible = false;
			}
			//新手
			NewbieController.showNewBieBtn(4, 11, this, 460, 368, true, "离开关卡", true);
			NewbieController.showNewBieBtn(5, 8, this, 460, 368, true, "离开关卡", true);
		}

	}
}