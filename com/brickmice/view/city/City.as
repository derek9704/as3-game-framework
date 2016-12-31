package com.brickmice.view.city
{
	import com.brickmice.ControllerManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.institute.Institute;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.CMap;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 城市
	 *
	 * @author derek
	 */
	public class City extends CMap
	{

		private var _window:ResMoonCity;

		/**
		 * 城市名字
		 */
		public static const NAME:String = 'City';

		public function City()
		{
			// 初始化并加入资源
			_window = new ResMoonCity();
			super(NAME, 1662, 930);
			addChildEx(_window);
			// 初始化内城建筑物
			init();
			//初始化行进中的小火车
			_window._train.buttonMode = true;
			_window._train.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				_window._train.stop();
			});
			_window._train.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				_window._train.play();
			});
			_window._train.addEventListener(MouseEvent.CLICK, function():void{
				var msg:Array = [
					"只有橙色噩梦鼠和科学美人才能获得特级天赋",
					"星际探索是获得高级兵器设计图和课题的唯一途径",
					"完成课题攻关后，记得把相应的技能给科学美人装备起来",
					"每次在太阳试炼中战斗成功后，噩梦鼠都有几率领悟新天赋",
					"只有偏执狂才能生存？听说有人在一天内点了50次宇宙外快之后…",
					"你可以直接加入那些设置为免审的星际联盟，无需等待批准！",
					"两件相同强化等级的装备成功分子重组后，新装备将额外+5强化等级！",
					"相信我，铁道和列车等级比你想象的更重要",
					"陷入困境的时候不要忘了蓝色太阳教可以随时提供各种援助",
					"心电图是课题攻关的关键，这其实是个技术活",
					"星际战争中，你可以和盟友制定开战时间，到时自动开战",
					"噩梦鼠在战争中阵亡后需要在教堂中复活",
					"你的科技美人将会成为噩梦鼠的坚强后盾，所以要用心培养哦！",
					"谁在支配美人和噩梦鼠？你啊，而你是谁？大概是…上帝吧…",
					"太阳试炼和课题攻关不顺利？提升等级吧，效果非常理想！"
				];
				var num:int = Math.round(Math.random() * (msg.length - 1));
				ControllerManager.yahuanController.showYahuan(msg[num], 2);
			});
			//初始化BUBBLE
			if(Data.data.institute.study.leftTime || !_window._instituteLabel.visible){
				_window._instituteBubble.visible = false;
				_window._instituteBubble.stop();
			}else{
				_window._instituteBubble.visible = true;
				_window._instituteBubble.play();
			}
			_window._brainBubble.visible = false;
			_window._brainBubble.stop();
			if((!Data.data.brain.call[1].leftTime || !Data.data.brain.call[2].leftTime || !Data.data.brain.call[3].leftTime || !Data.data.brain.call[4].leftTime) && _window._brainLabel.visible && Data.data.user.techLevel >= 10){
				_window._brainBubble.visible = true;
				_window._brainBubble.play();
			}else{
				_window._brainBubble.visible = false;
				_window._brainBubble.stop();
			}
			if(Data.data.school.slots[1].id || Data.data.school.slots[2].id || Data.data.school.slots[3].id || !_window._schoolLabel.visible){
				_window._schoolBubble.visible = false;
				_window._schoolBubble.stop();
			}else{
				_window._schoolBubble.visible = true;
				_window._schoolBubble.play();
			}
			
			if(Data.data.storage.cheese.volume > Data.data.storage.cheese.currentVolume || !_window._cheeseStorageLabel.visible){
				_window._cheeseStorageBubble.visible = false;
				_window._cheeseStorageBubble.stop();
			}else{
				_window._cheeseStorageBubble.visible = true;
				_window._cheeseStorageBubble.play();
			}
			if(Data.data.storage.arm.volume > Data.data.storage.arm.currentVolume || !_window._armStorageLabel.visible){
				_window._armStorageBubble.visible = false;
				_window._armStorageBubble.stop();
			}else{
				_window._armStorageBubble.visible = true;
				_window._armStorageBubble.play();
			}
			if(Data.data.storage.mouse.volume > Data.data.storage.mouse.currentVolume || !_window._mouseStorageLabel.visible){
				_window._mouseStorageBubble.visible = false;
				_window._mouseStorageBubble.stop();
			}else{
				_window._mouseStorageBubble.visible = true;
				_window._mouseStorageBubble.play();
			}
			//material
			var flag:Boolean = false;
			for each(var k:Object in Data.data.storage.material.items) {
				if(k.totalWeight >= Data.data.storage.material.volume) flag = true;
			}
			if(!flag || !_window._materialStorageLabel.visible){
				_window._materialStorageBubble.visible = false;
				_window._materialStorageBubble.stop();
			}else{
				_window._materialStorageBubble.visible = true;
				_window._materialStorageBubble.play();
			}
			
			//新手引导
			newbieHandler();
		}
		
		private function newbieHandler():void
		{	
			NewbieController.showNewBieBtn(1, 1, this, 655, 555, true, "打开大脑接收器", false, true);
			NewbieController.showNewBieBtn(9, 1, this, 655, 555, true, "打开大脑接收器", false, true);
			NewbieController.showNewBieBtn(20, 1, this, 655, 555, true, "打开大脑接收器", false, true);
			NewbieController.showNewBieBtn(10, 1, this, 533, 607, true, "打开研究所", false, true);
			NewbieController.showNewBieBtn(13, 1, this, 533, 607, true, "打开研究所", false, true);
			NewbieController.showNewBieBtn(14, 1, this, 533, 607, true, "打开研究所", false, true);
			NewbieController.showNewBieBtn(18, 1, this, 533, 607, true, "打开研究所", false, true);
			if(!ViewManager.hasView(Institute.NAME)) NewbieController.showNewBieBtn(11, 1, this, 533, 607, true, "打开研究所", false, true);
			NewbieController.showNewBieBtn(16, 1, this, 821, 337, true, "打开稀铁矿", false, true);
////			NewbieController.showNewBieBtn(5, 1, this, 533, 607, true, "打开研究所");
			NewbieController.showNewBieBtn(18, 1, this, 720, 486, true, "打开奶酪原浆矿", false, true);
////			NewbieController.showNewBieBtn(7, 1, this, 533, 607, true, "打开研究所");
			NewbieController.showNewBieBtn(17, 1, this, 741, 377, true, "打开宝石矿", false, true);
			NewbieController.showNewBieBtn(25, 1, this, 1408, 660, true, "打开奶酪工厂", false, true);
			NewbieController.showNewBieBtn(21, 1, this, 722, 720, true, "打开铁道部", false, true);
//			NewbieController.showNewBieBtn(18, 2, this, 1405, 667, true, "打开奶酪工厂");
//			NewbieController.showNewBieBtn(19, 1, this, 655, 555, true, "打开大脑接收器");
			NewbieController.showNewBieBtn(15, 1, this, 1328, 626, true, "打开发条鼠工厂", false, true);
//			NewbieController.showNewBieBtn(23, 1, this, 818, 452, true, "打开噩梦军校");
//			NewbieController.showNewBieBtn(19, 1, this, 655, 555, true, "打开大脑接收器");
//			NewbieController.showNewBieBtn(26, 1, this, 722, 720, true, "打开铁道部", false, true);
//			NewbieController.showNewBieBtn(30, 2, this, 904, 388, true, "打开原料仓库");
//			NewbieController.showNewBieBtn(31, 1, this, 1328, 626, true, "打开发条鼠工厂");
////			NewbieController.showNewBieBtn(32, 1, this, 722, 720, true, "打开铁道部");
//			NewbieController.showNewBieBtn(39, 1, this, 818, 452, true, "打开噩梦军校");
//			NewbieController.showNewBieBtn(42, 1, this, 470, 487, true, "打开物资交易中心");
//			NewbieController.showNewBieBtn(43, 1, this, 533, 607, true, "打开研究所");
//			NewbieController.showNewBieBtn(44, 1, this, 1229, 670, true, "打开军需工厂");
			NewbieController.showNewBieBtn(7, 1, this, 1049, 717, true, "打开强化中心", false, true);
		}

		/**
		 * 消息监听
		 */
		override public function listenerMessage():Array
		{
			return [
				ViewMessage.UPGRADE_MINE, ViewMessage.UPGRADE_INSTITUTE, ViewMessage.UPGRADE_STORAGE, 
				ViewMessage.UPGRADE_FACTORY, ViewMessage.UPGRADE_SCHOOL, ViewMessage.UPGRADE_RAILWAY,
				ViewMessage.REFRESH_FACTORY, ViewMessage.UPGRADE_CHURCH, ViewMessage.REFRESH_NEWBIE,
				ViewMessage.UPDATE_UNIT_STATUS,ViewMessage.REFRESH_INSTITUTE, ViewMessage.REFRESH_BRAIN,
				ViewMessage.REFRESH_SCHOOL, ViewMessage.REFRESH_STORAGE
			];
		}
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message:Message):void
		{
			var level:int = 0;
			var type:String = "";
			switch(message.type)
			{
				case ViewMessage.REFRESH_NEWBIE:
					newbieHandler();
					break;
				case ViewMessage.UPGRADE_MINE:
					type = message.data;
					level = Data.data.mine[type].level;
					switch(type)
					{
						case "puree":
						{
							_window._pureeMineLabel._lvl.text = level;
							_window._buildingPureeMine.gotoAndStop(Math.floor(level/20) * 2 + 1);
							break;
						}
						case "iron":
						{
							_window._ironMineLabel._lvl.text = level;
							_window._budingIronMine.gotoAndStop(Math.floor(level/20) * 2 + 1);
							break;
						}
						case "gem":
						{
							_window._gemMineLabel._lvl.text = level;
							_window._buildingGemMine.gotoAndStop(Math.floor(level/20) * 2 + 1);
							break;
						}
					}
					break;
				case ViewMessage.UPGRADE_STORAGE:
					type = message.data;
					level = Data.data.storage[type].level;
					switch(type)
					{
						case "mouse":
						{
							_window._mouseStorageLabel._lvl.text = level;
							_window._buildingMouseStorage.gotoAndStop(Math.floor(level/20) * 2 + 1);
							break;
						}
						case "arm":
						{
							_window._armStorageLabel._lvl.text = level;
							_window._buildingArmStorage.gotoAndStop(Math.floor(level/20) * 2 + 1);
							break;
						}
						case "cheese":
						{
							_window._cheeseStorageLabel._lvl.text = level;
							_window._buildingCheeseStorage.gotoAndStop(Math.floor(level/20) * 2 + 1);
							break;
						}
						case "material":
						{
							_window._materialStorageLabel._lvl.text = level;
							_window._buildingMaterialStorage.gotoAndStop(Math.floor(level/20) * 2 + 1);
							break;
						}
					}
					break;
				case ViewMessage.UPGRADE_FACTORY:
					type = message.data;
					level = Data.data.factory[type].level;
					switch(type)
					{
						case "mouse":
						{
							_window._mouseFactoryLabel._lvl.text = level;
							_window._buildingMouseFactory.gotoAndStop(Math.floor(level/20) * 2 + 1);
							if(_window._buildingMouseFactory._unit)  {
								if(Data.data.factory.mouse.produceInfo is Array){
									_window._buildingMouseFactory._unit.gotoAndStop(1);
									_window._mouseFactoryBubble.visible = true;	
									_window._mouseFactoryBubble.play();
								}
								else{
									_window._buildingMouseFactory._unit.gotoAndPlay(1);
									_window._mouseFactoryBubble.visible = false;	
									_window._mouseFactoryBubble.stop();
								}
							}
							break;
						}
						case "arm":
						{
							_window._armFactoryLabel._lvl.text = level;
							_window._buildingArmFactory.gotoAndStop(Math.floor(level/20) * 2 + 1);
							if(_window._buildingArmFactory._unit)  {
								if(Data.data.factory.arm.produceInfo is Array){
									_window._buildingArmFactory._unit.gotoAndStop(1);
									_window._armFactoryBubble.visible = true;
									_window._armFactoryBubble.play();
								}
								else{
									_window._buildingArmFactory._unit.gotoAndPlay(1);
									_window._armFactoryBubble.visible = false;
									_window._armFactoryBubble.stop();
								}
							}
							break;
						}
						case "cheese":
						{
							_window._cheeseFactoryLabel._lvl.text = level;
							_window._buildingCheeseFactory.gotoAndStop(Math.floor(level/20) * 2 + 1);
							if(_window._buildingCheeseFactory._unit)  {
								if(Data.data.factory.cheese.produceInfo is Array){
									_window._buildingCheeseFactory._unit.gotoAndStop(1);
									_window._cheeseFactoryBubble.visible = true;	
									_window._cheeseFactoryBubble.play();
								}
								else{
									_window._buildingCheeseFactory._unit.gotoAndPlay(1);
									_window._cheeseFactoryBubble.visible = false;	
									_window._cheeseFactoryBubble.stop();
								}
							}
							break;
						}
					}
					break;
				case ViewMessage.UPGRADE_INSTITUTE:
					level = Data.data.institute.level;
					_window._buildingInstitute.gotoAndStop(Math.floor(level/20) * 2 + 1);
					if(_window._smithyLabel.visible)
						_window._buildingSmithy.gotoAndStop(Math.floor(level/20) * 2 + 1);
					if(_window._stockLabel.visible)
						_window._buildingStock.gotoAndStop(Math.floor(level/20) * 2 + 1);
					break;
				case ViewMessage.UPGRADE_CHURCH:
					level = Data.data.church.level;
					_window._churchLabel._lvl.text = level;
					_window._buildingChurch.gotoAndStop(Math.floor(level/20) * 2 + 1);
					break;
				case ViewMessage.UPGRADE_SCHOOL:
					level = Data.data.school.level;
					_window._schoolLabel._lvl.text = level;
					_window._buildingSchool.gotoAndStop(Math.floor(level/20) * 2 + 1);
					break;
				case ViewMessage.UPGRADE_RAILWAY:
					level = Data.data.railway.level;
					_window._railway1Label._lvl.text = level;
					_window._railway2Label._lvl.text = level;
					var frame:int = Math.floor(level/20) * 2 + 1;
					_window._buildingRailway1.gotoAndStop(frame);
					_window._buildingRailway1s.gotoAndStop(frame);
					_window._buildingRailway2.gotoAndStop(frame);
					_window._buildingRailway2s.gotoAndStop(frame);
					break;
				case ViewMessage.REFRESH_FACTORY:
					if(_window._buildingMouseFactory._unit)  {
						if(Data.data.factory.mouse.produceInfo is Array){
							_window._buildingMouseFactory._unit.gotoAndStop(1);
							_window._mouseFactoryBubble.visible = true;	
							_window._mouseFactoryBubble.play();
						}
						else{
							_window._buildingMouseFactory._unit.gotoAndPlay(1);
							_window._mouseFactoryBubble.visible = false;	
							_window._mouseFactoryBubble.stop();
						}
					}
					if(_window._buildingCheeseFactory._unit)  {
						if(Data.data.factory.cheese.produceInfo is Array){
							_window._buildingCheeseFactory._unit.gotoAndStop(1);
							_window._cheeseFactoryBubble.visible = true;	
							_window._cheeseFactoryBubble.play();
						}
						else{
							_window._buildingCheeseFactory._unit.gotoAndPlay(1);
							_window._cheeseFactoryBubble.visible = false;	
							_window._cheeseFactoryBubble.stop();
						}
					}
					if(_window._buildingArmFactory._unit)  {
						if(Data.data.factory.arm.produceInfo is Array){
							_window._buildingArmFactory._unit.gotoAndStop(1);
							_window._armFactoryBubble.visible = true;
							_window._armFactoryBubble.play();
						}
						else{
							_window._buildingArmFactory._unit.gotoAndPlay(1);
							_window._armFactoryBubble.visible = false;
							_window._armFactoryBubble.stop();
						}
					}
					break;
				case ViewMessage.UPDATE_UNIT_STATUS:
					updateUnitStatus();
					break;
				case ViewMessage.REFRESH_INSTITUTE:
					if(Data.data.institute.study.leftTime || !_window._instituteLabel.visible){
						_window._instituteBubble.visible = false;
						_window._instituteBubble.stop();
					}else{
						_window._instituteBubble.visible = true;
						_window._instituteBubble.play();
					}
					break;
				case ViewMessage.REFRESH_BRAIN:
					_window._brainBubble.visible = false;
					_window._brainBubble.stop();
					if((!Data.data.brain.call[1].leftTime || !Data.data.brain.call[2].leftTime || !Data.data.brain.call[3].leftTime || !Data.data.brain.call[4].leftTime) && _window._brainLabel.visible && Data.data.user.techLevel >= 10){
						_window._brainBubble.visible = true;
						_window._brainBubble.play();
					}else{
						_window._brainBubble.visible = false;
						_window._brainBubble.stop();
					}
					break;
				case ViewMessage.REFRESH_SCHOOL:
					if(Data.data.school.slots[1].id || Data.data.school.slots[2].id || Data.data.school.slots[3].id || !_window._schoolLabel.visible){
						_window._schoolBubble.visible = false;
						_window._schoolBubble.stop();
					}else{
						_window._schoolBubble.visible = true;
						_window._schoolBubble.play();
					}
					break;
				case ViewMessage.REFRESH_STORAGE:
					if(Data.data.storage.cheese.volume > Data.data.storage.cheese.currentVolume || !_window._cheeseStorageLabel.visible){
						_window._cheeseStorageBubble.visible = false;
						_window._cheeseStorageBubble.stop();
					}else{
						_window._cheeseStorageBubble.visible = true;
						_window._cheeseStorageBubble.play();
					}
					if(Data.data.storage.arm.volume > Data.data.storage.arm.currentVolume || !_window._armStorageLabel.visible){
						_window._armStorageBubble.visible = false;
						_window._armStorageBubble.stop();
					}else{
						_window._armStorageBubble.visible = true;
						_window._armStorageBubble.play();
					}
					if(Data.data.storage.mouse.volume > Data.data.storage.mouse.currentVolume || !_window._mouseStorageLabel.visible){
						_window._mouseStorageBubble.visible = false;
						_window._mouseStorageBubble.stop();
					}else{
						_window._mouseStorageBubble.visible = true;
						_window._mouseStorageBubble.play();
					}
					//material
					var flag:Boolean = false;
					for each(var k:Object in Data.data.storage.material.items) {
						if(k.totalWeight >= Data.data.storage.material.volume) flag = true;
					}
					if(!flag || !_window._materialStorageLabel.visible){
						_window._materialStorageBubble.visible = false;
						_window._materialStorageBubble.stop();
					}else{
						_window._materialStorageBubble.visible = true;
						_window._materialStorageBubble.play();
					}
					break;
			}
		}
		
		/**
		 * 更新建筑开启 
		 * 
		 */
		private function updateUnitStatus():void
		{
			var level:int = 0; 
			var finishedTask:Array = Data.data.finishedTask;
			var index:int = finishedTask.indexOf(9);
			if (index >= 0){
				level = Data.data.institute.level;
				_window._buildingInstitute.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._instituteLabel.visible = true;
				_window._buildingInstitute.mouseEnabled = _window._buildingInstitute.mouseChildren = true;
			}
			index = finishedTask.indexOf(202);
			if(index >= 0){
				level = Data.data.mine.iron.level;
				_window._budingIronMine.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._ironMineLabel.visible = true;
				_window._budingIronMine.mouseEnabled = _window._budingIronMine.mouseChildren = true;
			}
			index = finishedTask.indexOf(206);
			if(index >= 0){
				level = Data.data.mine.puree.level;
				_window._buildingPureeMine.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._pureeMineLabel.visible = true;
				_window._buildingPureeMine.mouseEnabled = _window._buildingPureeMine.mouseChildren = true;
			}
			index = finishedTask.indexOf(203);
			if(index >= 0){
				level = Data.data.mine.gem.level;
				_window._buildingGemMine.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._gemMineLabel.visible = true;
				_window._buildingGemMine.mouseEnabled = _window._buildingGemMine.mouseChildren = true;
			}
			index = finishedTask.indexOf(207);
			if(index >= 0){
				level = Data.data.factory.cheese.level;
				_window._buildingCheeseFactory.gotoAndStop(Math.floor(level/20) * 2 + 1);
				if(_window._buildingCheeseFactory._unit)  {
					if(Data.data.factory.cheese.produceInfo is Array){
						_window._buildingCheeseFactory._unit.gotoAndStop(1);
						_window._cheeseFactoryBubble.visible = true;	
						_window._cheeseFactoryBubble.play();
					}
					else{
						_window._buildingCheeseFactory._unit.gotoAndPlay(1);
						_window._cheeseFactoryBubble.visible = false;	
						_window._cheeseFactoryBubble.stop();
					}
				}
				_window._cheeseFactoryLabel.visible = true;
				_window._buildingCheeseFactory.mouseEnabled = _window._buildingCheeseFactory.mouseChildren = true;	
			}
			index = finishedTask.indexOf(207);
			if(index >= 0){
				level = Data.data.storage.cheese.level;
				_window._buildingCheeseStorage.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._cheeseStorageLabel.visible = true;
				_window._buildingCheeseStorage.mouseEnabled = _window._buildingCheeseStorage.mouseChildren = true;	
			}
			index = finishedTask.indexOf(202);
			if(index >= 0){
				level = Data.data.storage.material.level;
				_window._buildingMaterialStorage.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._materialStorageLabel.visible = true;
				_window._buildingMaterialStorage.mouseEnabled = _window._buildingMaterialStorage.mouseChildren = true;	
			}			
			index = finishedTask.indexOf(204);
			if(index >= 0){
				level = Data.data.factory.mouse.level;
				_window._buildingMouseFactory.gotoAndStop(Math.floor(level/20) * 2 + 1);
				if(_window._buildingMouseFactory._unit)  {
					if(Data.data.factory.mouse.produceInfo is Array){
						_window._buildingMouseFactory._unit.gotoAndStop(1);
						_window._mouseFactoryBubble.visible = true;	
						_window._mouseFactoryBubble.play();
					}
					else{
						_window._buildingMouseFactory._unit.gotoAndPlay(1);
						_window._mouseFactoryBubble.visible = false;	
						_window._mouseFactoryBubble.stop();
					}
				}
				_window._mouseFactoryLabel.visible = true;
				_window._buildingMouseFactory.mouseEnabled = _window._buildingMouseFactory.mouseChildren = true;	
			}	
			index = finishedTask.indexOf(204);
			if(index >= 0){
				level = Data.data.storage.mouse.level;
				_window._buildingMouseStorage.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._mouseStorageLabel.visible = true;
				_window._buildingMouseStorage.mouseEnabled = _window._buildingMouseStorage.mouseChildren = true;	
			}	
			index = finishedTask.indexOf(208);
			if(index >= 0){
				level = Data.data.railway.level;
				var frame:int = Math.floor(level/20) * 2 + 1;
				_window._buildingRailway1.gotoAndStop(frame);
				_window._buildingRailway1s.gotoAndStop(frame);
				_window._buildingRailway2.gotoAndStop(frame);
				_window._buildingRailway2s.gotoAndStop(frame);
				_window._railway1Label.visible = true;
				_window._buildingRailway1.mouseEnabled = _window._buildingRailway1.mouseChildren = true;		
				_window._railway2Label.visible = true;
				_window._buildingRailway2.mouseEnabled = _window._buildingRailway2.mouseChildren = true;
			}	
			index = finishedTask.indexOf(21);
			if(index >= 0){
				_window._train.visible = true;
			}	
			index = finishedTask.indexOf(217);
			if(index >= 0){
				level = Data.data.school.level;
				_window._buildingSchool.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._schoolLabel.visible = true;
				_window._buildingSchool.mouseEnabled = _window._buildingSchool.mouseChildren = true;	
			}
			index = finishedTask.indexOf(211);
			if(index >= 0){
				level = Data.data.church.level;
				_window._buildingChurch.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._churchLabel.visible = true;
				_window._buildingChurch.mouseEnabled = _window._buildingChurch.mouseChildren = true;
			}
			index = finishedTask.indexOf(215);
			if(index >= 0){
				level = Data.data.storage.arm.level;
				_window._buildingArmStorage.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._armStorageLabel.visible = true;
				_window._buildingArmStorage.mouseEnabled = _window._buildingArmStorage.mouseChildren = true;	
			}		
			index = finishedTask.indexOf(221);
			if(index >= 0){
				level = Data.data.institute.level;
				_window._buildingStock.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._stockLabel.visible = true;
				_window._buildingStock.mouseEnabled = _window._buildingStock.mouseChildren = true;	
			}		
			index = finishedTask.indexOf(215);
			if(index >= 0){
				level = Data.data.factory.arm.level;
				_window._buildingArmFactory.gotoAndStop(Math.floor(level/20) * 2 + 1);
				if(_window._buildingArmFactory._unit)  {
					if(Data.data.factory.arm.produceInfo is Array){
						_window._buildingArmFactory._unit.gotoAndStop(1);
						_window._armFactoryBubble.visible = true;
						_window._armFactoryBubble.play();
					}
					else{
						_window._buildingArmFactory._unit.gotoAndPlay(1);
						_window._armFactoryBubble.visible = false;
						_window._armFactoryBubble.stop();
					}
				}
				_window._armFactoryLabel.visible = true;
				_window._buildingArmFactory.mouseEnabled = _window._buildingArmFactory.mouseChildren = true;	
			}	
			index = finishedTask.indexOf(6);
			if(index >= 0){
				level = Data.data.institute.level;
				_window._buildingSmithy.gotoAndStop(Math.floor(level/20) * 2 + 1);
				_window._smithyLabel.visible = true;
				_window._buildingSmithy.mouseEnabled = _window._buildingSmithy.mouseChildren = true;	
			}
		}

		/**
		 * 初始化内城建筑物
		 */
		public function init():void
		{
			if(Data.data.user.techLevel >= 50)
				_window.gotoAndStop(2);
			else
				_window.gotoAndStop(1);
			
			_window._armFactoryBubble.visible = false;
			_window._armFactoryBubble.stop();
			
			_window._mouseFactoryBubble.visible = false;
			_window._mouseFactoryBubble.stop();
			
			_window._cheeseFactoryBubble.visible = false;
			_window._cheeseFactoryBubble.stop();
			
			//研究所
			initBuilding(_window._buildingInstitute, function() : void
			{	
				NewbieController.hideNewBieBtn();
				NewbieController.refreshNewBieBtn(10, 2);
//				NewbieController.refreshNewBieBtn(11, 2);
//				NewbieController.refreshNewBieBtn(5, 2);
//				NewbieController.refreshNewBieBtn(7, 2);
//				NewbieController.refreshNewBieBtn(43, 2);
				ControllerManager.instituteController.showInstitute();
			}, Data.data.institute.level);
			_window._buildingInstitute.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingInstitute.gotoAndStop(Math.floor(Data.data.institute.level/20) * 2 + 2);
			});
			_window._buildingInstitute.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingInstitute.gotoAndStop(Math.floor(Data.data.institute.level/20) * 2 + 1);
			});
			
			_window._buildingInstitute.gotoAndStop(23);
			_window._instituteLabel.visible = false;
			_window._buildingInstitute.mouseEnabled = _window._buildingInstitute.mouseChildren = false;
			
			//大脑接收器
			initBuilding(_window._buildingBrain, function() : void
			{	
				NewbieController.refreshNewBieBtn(1, 2);
				NewbieController.refreshNewBieBtn(9, 2);
//				NewbieController.refreshNewBieBtn(19, 2);
				NewbieController.refreshNewBieBtn(20, 2);
				ControllerManager.brainController.showBrain();
			});
			_window._buildingBrain.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingBrain.gotoAndStop(2);
			});
			_window._buildingBrain.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingBrain.gotoAndStop(1);
			});
			
			//教堂
			initBuilding(_window._buildingChurch, function() : void
			{	
				ControllerManager.churchController.showChurch();
			}, Data.data.church.level, _window._churchLabel);
			_window._buildingChurch.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingChurch.gotoAndStop(Math.floor(Data.data.church.level/20) * 2 + 2);
			});
			_window._buildingChurch.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingChurch.gotoAndStop(Math.floor(Data.data.church.level/20) * 2 + 1);
			});
			
			_window._buildingChurch.gotoAndStop(23);
			_window._churchLabel.visible = false;
			_window._buildingChurch.mouseEnabled = _window._buildingChurch.mouseChildren = false;
			
			//原浆矿
			initBuilding(_window._buildingPureeMine, function() : void
			{	
				NewbieController.refreshNewBieBtn(18, 2);
				ControllerManager.mineController.showMine("puree");
			}, Data.data.mine.puree.level, _window._pureeMineLabel);
			_window._buildingPureeMine.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingPureeMine.gotoAndStop(Math.floor(Data.data.mine.puree.level/20) * 2 + 2);
			});
			_window._buildingPureeMine.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingPureeMine.gotoAndStop(Math.floor(Data.data.mine.puree.level/20) * 2 + 1);
			});
			
			_window._buildingPureeMine.gotoAndStop(23);
			_window._pureeMineLabel.visible = false;
			_window._buildingPureeMine.mouseEnabled = _window._buildingPureeMine.mouseChildren = false;
			
			//宝石矿
			initBuilding(_window._buildingGemMine, function() : void
			{	
				NewbieController.refreshNewBieBtn(17, 2);
				ControllerManager.mineController.showMine("gem");
			}, Data.data.mine.gem.level, _window._gemMineLabel);
			_window._buildingGemMine.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingGemMine.gotoAndStop(Math.floor(Data.data.mine.gem.level/20) * 2 + 2);
			});
			_window._buildingGemMine.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingGemMine.gotoAndStop(Math.floor(Data.data.mine.gem.level/20) * 2 + 1);
			});
			
			_window._buildingGemMine.gotoAndStop(23);
			_window._gemMineLabel.visible = false;
			_window._buildingGemMine.mouseEnabled = _window._buildingGemMine.mouseChildren = false;
			
			//稀铁矿
			initBuilding(_window._budingIronMine, function() : void
			{	
				NewbieController.refreshNewBieBtn(16, 2);
				ControllerManager.mineController.showMine("iron");
			}, Data.data.mine.iron.level, _window._ironMineLabel);
			_window._budingIronMine.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._budingIronMine.gotoAndStop(Math.floor(Data.data.mine.iron.level/20) * 2 + 2);
			});
			_window._budingIronMine.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._budingIronMine.gotoAndStop(Math.floor(Data.data.mine.iron.level/20) * 2 + 1);
			});
			
			_window._budingIronMine.gotoAndStop(23);
			_window._ironMineLabel.visible = false;
			_window._budingIronMine.mouseEnabled = _window._budingIronMine.mouseChildren = false;
			
			//学校
			initBuilding(_window._buildingSchool, function() : void
			{	
//				NewbieController.refreshNewBieBtn(23, 2);
//				NewbieController.refreshNewBieBtn(39, 2);
				ControllerManager.schoolController.showSchool();
			}, Data.data.school.level, _window._schoolLabel);
			_window._buildingSchool.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingSchool.gotoAndStop(Math.floor(Data.data.school.level/20) * 2 + 2);
			});
			_window._buildingSchool.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingSchool.gotoAndStop(Math.floor(Data.data.school.level/20) * 2 + 1);
			});
			
			_window._buildingSchool.gotoAndStop(23);
			_window._schoolLabel.visible = false;
			_window._buildingSchool.mouseEnabled = _window._buildingSchool.mouseChildren = false;	
			
			//发条鼠军营
			initBuilding(_window._buildingMouseStorage, function() : void
			{	
				ControllerManager.storageController.showStorage("mouse");
			}, Data.data.storage.mouse.level, _window._mouseStorageLabel);
			_window._buildingMouseStorage.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingMouseStorage.gotoAndStop(Math.floor(Data.data.storage.mouse.level/20) * 2 + 2);
			});
			_window._buildingMouseStorage.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingMouseStorage.gotoAndStop(Math.floor(Data.data.storage.mouse.level/20) * 2 + 1);
			});
			
			_window._buildingMouseStorage.gotoAndStop(23);
			_window._mouseStorageLabel.visible = false;
			_window._buildingMouseStorage.mouseEnabled = _window._buildingMouseStorage.mouseChildren = false;	
			
			//原料仓库
			initBuilding(_window._buildingMaterialStorage, function() : void
			{	
//				NewbieController.refreshNewBieBtn(30, 3);
				ControllerManager.storageController.showStorage("material");
			}, Data.data.storage.material.level, _window._materialStorageLabel);
			_window._buildingMaterialStorage.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingMaterialStorage.gotoAndStop(Math.floor(Data.data.storage.material.level/20) * 2 + 2);
			});
			_window._buildingMaterialStorage.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingMaterialStorage.gotoAndStop(Math.floor(Data.data.storage.material.level/20) * 2 + 1);
			});		
			
			_window._buildingMaterialStorage.gotoAndStop(23);
			_window._materialStorageLabel.visible = false;
			_window._buildingMaterialStorage.mouseEnabled = _window._buildingMaterialStorage.mouseChildren = false;	
			
			//奶酪仓库
			initBuilding(_window._buildingCheeseStorage, function() : void
			{	
				ControllerManager.storageController.showStorage("cheese");
			}, Data.data.storage.cheese.level, _window._cheeseStorageLabel);
			_window._buildingCheeseStorage.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingCheeseStorage.gotoAndStop(Math.floor(Data.data.storage.cheese.level/20) * 2 + 2);
			});
			_window._buildingCheeseStorage.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingCheeseStorage.gotoAndStop(Math.floor(Data.data.storage.cheese.level/20) * 2 + 1);
			});			
			
			_window._buildingCheeseStorage.gotoAndStop(23);
			_window._cheeseStorageLabel.visible = false;
			_window._buildingCheeseStorage.mouseEnabled = _window._buildingCheeseStorage.mouseChildren = false;	
			
			//军需仓库
			initBuilding(_window._buildingArmStorage, function() : void
			{	
				ControllerManager.storageController.showStorage("arm");
			}, Data.data.storage.arm.level, _window._armStorageLabel);
			_window._buildingArmStorage.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingArmStorage.gotoAndStop(Math.floor(Data.data.storage.arm.level/20) * 2 + 2);
			});
			_window._buildingArmStorage.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingArmStorage.gotoAndStop(Math.floor(Data.data.storage.arm.level/20) * 2 + 1);
			});		
			
			_window._buildingArmStorage.gotoAndStop(23);
			_window._armStorageLabel.visible = false;
			_window._buildingArmStorage.mouseEnabled = _window._buildingArmStorage.mouseChildren = false;			
			
			//小火车
			_window._train.visible = false;
			
			//铁路1
			initBuilding(_window._buildingRailway1, function() : void
			{	
				NewbieController.refreshNewBieBtn(21, 2);
//				NewbieController.refreshNewBieBtn(26, 2);
				ControllerManager.railwayController.showRailway();
			}, Data.data.railway.level, _window._railway1Label, _window._buildingRailway1s);
			_window._buildingRailway1.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingRailway1.gotoAndStop(Math.floor(Data.data.railway.level/20) * 2 + 2);
				_window._buildingRailway1s.gotoAndStop(Math.floor(Data.data.railway.level/20) * 2 + 2);
			});
			_window._buildingRailway1.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingRailway1.gotoAndStop(Math.floor(Data.data.railway.level/20) * 2 + 1);
				_window._buildingRailway1s.gotoAndStop(Math.floor(Data.data.railway.level/20) * 2 + 1);
			});	
			
			_window._buildingRailway1.gotoAndStop(23);
			_window._buildingRailway1s.gotoAndStop(23);
			_window._railway1Label.visible = false;
			_window._buildingRailway1.mouseEnabled = _window._buildingRailway1.mouseChildren = false;		
			
			//铁路2
			initBuilding(_window._buildingRailway2, function() : void
			{	
				NewbieController.refreshNewBieBtn(21, 2);
//				NewbieController.refreshNewBieBtn(26, 2);
				ControllerManager.railwayController.showRailway();
			}, Data.data.railway.level, _window._railway2Label, _window._buildingRailway2s);
			_window._buildingRailway2.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingRailway2.gotoAndStop(Math.floor(Data.data.railway.level/20) * 2 + 2);
				_window._buildingRailway2s.gotoAndStop(Math.floor(Data.data.railway.level/20) * 2 + 2);
			});
			_window._buildingRailway2.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingRailway2.gotoAndStop(Math.floor(Data.data.railway.level/20) * 2 + 1);
				_window._buildingRailway2s.gotoAndStop(Math.floor(Data.data.railway.level/20) * 2 + 1);
			});	
			
			_window._buildingRailway2.gotoAndStop(23);
			_window._buildingRailway2s.gotoAndStop(23);
			_window._railway2Label.visible = false;
			_window._buildingRailway2.mouseEnabled = _window._buildingRailway2.mouseChildren = false;		
			
			//强化中心
			initBuilding(_window._buildingSmithy, function() : void
			{	
				NewbieController.refreshNewBieBtn(7, 2);
				ControllerManager.smithyController.showSmithy();
			}, Data.data.institute.level);
			_window._buildingSmithy.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingSmithy.gotoAndStop(Math.floor(Data.data.institute.level/20) * 2 + 2);
			});
			_window._buildingSmithy.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingSmithy.gotoAndStop(Math.floor(Data.data.institute.level/20) * 2 + 1);
			});
			
			_window._buildingSmithy.gotoAndStop(23);
			_window._smithyLabel.visible = false;
			_window._buildingSmithy.mouseEnabled = _window._buildingSmithy.mouseChildren = false;	
			
			//物资交易中心
			initBuilding(_window._buildingStock, function() : void
			{	
//				NewbieController.refreshNewBieBtn(42, 2);
				ControllerManager.stockController.showStock();
			}, Data.data.institute.level);
			_window._buildingStock.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingStock.gotoAndStop(Math.floor(Data.data.institute.level/20) * 2 + 2);
			});
			_window._buildingStock.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingStock.gotoAndStop(Math.floor(Data.data.institute.level/20) * 2 + 1);
			});
			
			_window._buildingStock.gotoAndStop(23);
			_window._stockLabel.visible = false;
			_window._buildingStock.mouseEnabled = _window._buildingStock.mouseChildren = false;	
			
			//发条鼠工厂
			initBuilding(_window._buildingMouseFactory, function() : void
			{	
				NewbieController.refreshNewBieBtn(15, 2);
//				NewbieController.refreshNewBieBtn(31, 2);
				ControllerManager.factoryController.showFactory("mouse");
			}, Data.data.factory.mouse.level,  _window._mouseFactoryLabel);
			if(Data.data.factory.mouse.produceInfo is Array)  {
				_window._buildingMouseFactory._unit.gotoAndStop(1);
			}
			_window._buildingMouseFactory.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingMouseFactory.gotoAndStop(Math.floor(Data.data.factory.mouse.level/20) * 2 + 2);
			});
			_window._buildingMouseFactory.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingMouseFactory.gotoAndStop(Math.floor(Data.data.factory.mouse.level/20) * 2 + 1);
				if(Data.data.factory.mouse.produceInfo is Array)  {
					_window._buildingMouseFactory._unit.gotoAndStop(1);
				}
			});
			
			_window._buildingMouseFactory.gotoAndStop(23);
			_window._mouseFactoryLabel.visible = false;
			_window._buildingMouseFactory.mouseEnabled = _window._buildingMouseFactory.mouseChildren = false;	
			
			//奶酪工厂
			initBuilding(_window._buildingCheeseFactory, function() : void
			{	
				NewbieController.refreshNewBieBtn(25, 2);
//				NewbieController.refreshNewBieBtn(18, 3);
				ControllerManager.factoryController.showFactory("cheese");
			}, Data.data.factory.cheese.level, _window._cheeseFactoryLabel);
			if(Data.data.factory.cheese.produceInfo is Array)  {
				_window._buildingCheeseFactory._unit.gotoAndStop(1);
			}
			_window._buildingCheeseFactory.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingCheeseFactory.gotoAndStop(Math.floor(Data.data.factory.cheese.level/20) * 2 + 2);
			});
			_window._buildingCheeseFactory.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingCheeseFactory.gotoAndStop(Math.floor(Data.data.factory.cheese.level/20) * 2 + 1);
				if(Data.data.factory.cheese.produceInfo is Array)  {
					_window._buildingCheeseFactory._unit.gotoAndStop(1);
				}
			});
			
			_window._buildingCheeseFactory.gotoAndStop(23);
			_window._cheeseFactoryLabel.visible = false;
			_window._buildingCheeseFactory.mouseEnabled = _window._buildingCheeseFactory.mouseChildren = false;	
			
			//军需工厂
			initBuilding(_window._buildingArmFactory, function() : void
			{	
//				NewbieController.refreshNewBieBtn(44, 2);
				ControllerManager.factoryController.showFactory("arm");
			}, Data.data.factory.arm.level, _window._armFactoryLabel);
			if(Data.data.factory.arm.produceInfo is Array)  {
				_window._buildingArmFactory._unit.gotoAndStop(1);
			}
			_window._buildingArmFactory.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_window._buildingArmFactory.gotoAndStop(Math.floor(Data.data.factory.arm.level/20) * 2 + 2);
			});
			_window._buildingArmFactory.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_window._buildingArmFactory.gotoAndStop(Math.floor(Data.data.factory.arm.level/20) * 2 + 1);
				if(Data.data.factory.arm.produceInfo is Array)  {
					_window._buildingArmFactory._unit.gotoAndStop(1);
				}
			});
			
			_window._buildingArmFactory.gotoAndStop(23);
			_window._armFactoryLabel.visible = false;
			_window._buildingArmFactory.mouseEnabled = _window._buildingArmFactory.mouseChildren = false;	
			
			updateUnitStatus();
		}
		
		private function initBuilding(_mc:MovieClip, click:Function, level:int = 1, label:MovieClip = null, railway2:MovieClip = null):void
		{
			//动画都用mask
			if(_mc._mask) 
				_mc.hitArea = _mc._mask;
			
			//等级
			if(label != null) label._lvl.text = level;
			_mc.gotoAndStop(Math.floor(level/20) * 2 + 1);
			if(railway2 != null) railway2.gotoAndStop(Math.floor(level/20) * 2 + 1);
			
			_mc.addEventListener(MouseEvent.CLICK, click);
			_mc.buttonMode = true;
		}
	}
}
