package com.brickmice.view.component.frame
{
	
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McTip;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.brickmice.view.institute.Institute;
	import com.brickmice.view.railway.Railway;
	import com.framework.core.Message;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.TipHelper;

	/**
	 * @author derek
	 */
	public class StateTrack extends CSprite
	{
		
		public static const NAME : String = "StateTrack";
		private var _window : ResStatePanel;
		
		public function StateTrack()
		{
			_window = new ResStatePanel();
			super(NAME, _window.width, _window.height);
			addChildEx(_window);
			
			new BmButton(_window._unitPointBtn, function():void{
				var data:Object = {};
				data.msg = "确认购买建筑点？";
				data.action = "client";
				data.args = function():void{
					ModelManager.userModel.buyUnitPoint();
				}
				ControllerManager.windowController.showWindow(new WindowData(ConfirmMessage, data, true, 0, 0, 0, false));
			});
			new BmButton(_window._smithyBtn, function():void{
				var data:Object = {};
				data.msg = "确认购买强化点？";
				data.action = "client";
				data.args = function():void{
					ModelManager.equipModel.buyEquipPoint();
				}
				ControllerManager.windowController.showWindow(new WindowData(ConfirmMessage, data, true, 0, 0, 0, false));
			});
			new BmButton(_window._trafficBtn, function():void{
				NewbieController.refreshNewBieBtn(22, 14);
				ControllerManager.railwayController.showRailway(Railway.TRAFFIC);
			});	
			new BmButton(_window._techIssueBtn, function():void{
				NewbieController.hideNewBieBtn();
				ControllerManager.instituteController.showInstitute(Institute.NEWLESSON);
			});	
			new BmButton(_window._armIssueBtn, function():void{
				ControllerManager.instituteController.showInstitute(Institute.NEWPAPER);
			});			
		}	
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_UNITPOINT, ViewMessage.REFRESH_EQUIPPOINT, ViewMessage.REFRESH_RAILWAY, 
				ViewMessage.REFRESH_MATERIAL, ViewMessage.REFRESH_INSTITUTE, ViewMessage.REFRESH_NEWBIE];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_UNITPOINT:
					_window._unitPoint.text = Data.data.unit.point + " / " + Data.data.unit.maxPoint;
					var tip:String = '建筑点会随荣誉等级提升<br>';
					tip += "恢复间隔：" + Data.data.unit.recoverPointInterval + "秒<br>";
					tip += "每天0点恢复" + Data.data.unit.dailyRecoverPoint + "点<br>";
					tip += "花费" + Data.data.unit.buyPointCost + "宇宙钻购买" + Data.data.unit.buyPointCount + "建筑点";
					TipHelper.setTip(_window._unitPointBtn, new McTip(tip));
					break;
				case ViewMessage.REFRESH_EQUIPPOINT:
					_window._smithyCooldown.text = Data.data.equip.point + " / " + Data.data.equip.maxPoint;
					var tip2:String = '强化点会随荣誉等级提升<br>';
					tip2 += "恢复间隔：" + Data.data.equip.recoverPointInterval + "秒<br>";
					tip2 += "每天0点恢复" + Data.data.equip.dailyRecoverPoint + "点<br>";
					tip2 += "花费" + Data.data.equip.buyPointCost + "宇宙钻购买" + Data.data.equip.buyPointCount + "强化点";
					TipHelper.setTip(_window._smithyBtn, new McTip(tip2));
					break;
				case ViewMessage.REFRESH_RAILWAY:
					var trains:Array = Data.data.railway.trains;
					var trainCount:int = trains.length;
					var runTrainCount:int = 0;
					for each (var train:Object in trains) 
					{
						if(train['status'] == 'run') runTrainCount++;
					}
					_window._trainNum.text = runTrainCount.toString() + " / " + trainCount.toString();
					break;
				case ViewMessage.REFRESH_MATERIAL:
					_window._iron.text = Data.data.storage.material.items[Consts.ID_IRON].num;
					_window._moonStone.text = Data.data.storage.material.items[Consts.ID_MOONSTONE].num;
					_window._nightStone.text = Data.data.storage.material.items[Consts.ID_NIGHTSTONE].num;
					_window._lifeStone.text = Data.data.storage.material.items[Consts.ID_LIFESTONE].num;
					break;
				case ViewMessage.REFRESH_INSTITUTE:
					//课题
					var lessones:Object = Data.data.institute.lesson;
					var lessonCount:int = 0;
					for each(var one3:Object in lessones) {
						if(one3.learned == 1) continue;
						//前置判断
						if(one3.ticket1 && one3.ticket1 != 0){
							if(!Data.data.institute.lesson[one3.ticket1] || Data.data.institute.lesson[one3.ticket1].learned == 0){
								continue;
							}
						}
						if(one3.ticket2 && one3.ticket2 != 0){
							if(!Data.data.institute.lesson[one3.ticket2] || Data.data.institute.lesson[one3.ticket2].learned == 0){
								continue;
							}
						}
						lessonCount++;
					}
					_window._techIssueNum.text = lessonCount.toString();
					//图纸
					var paperes:Object = Data.data.institute.paper;
					var paperCount:int = 0;
					for each(var one2:Object in paperes) {
						if(one2.learned == 1) continue;
						paperCount++;
					}
					_window._armIssueNum.text = paperCount.toString();		
					break;
				case ViewMessage.REFRESH_NEWBIE:
					NewbieController.showNewBieBtn(22, 13, this, 185, 117, false, "直接进入交通信息页面", false, true);
					NewbieController.showNewBieBtn(24, 1, this, 185, 136, false, "直接进入新课题页面", false, true);
					break;
				default:
			}
		}		
	}
}
