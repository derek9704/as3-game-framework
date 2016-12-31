package com.brickmice.view.planet
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.Message;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class BlueSunHelp extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "BlueSunHelp";
		
		private var _mc:MovieClip;
		private var _reinforceBtn:MovieClip;
		
		private var _pos1:BmButton;
		private var _pos2:BmButton;
		private var _pos3:BmButton;
		private var _pos4:BmButton;
		private var _pos5:BmButton;
		
		private var _type:int = 0;
		
		public function BlueSunHelp(pid:int, data:Object, callback:Function)
		{
			_mc = new ResPlanetBlueSunHelpWindow;
			super(NAME, _mc);
			
			_reinforceBtn = _mc._reinforceBtn;
			
			new BmButton(_reinforceBtn, function():void{
				if(!_type) {
					TextMessage.showEffect('请选择部队！', 2);
					return;
				}
				ModelManager.warModel.aimWarByBlueSun(pid, _type, callback);
			});
			
			var selectTime:Function = function(type:int):void{
				_type = type;
				_pos1.selected = type == 1;
				_pos2.selected = type == 2;
				_pos3.selected = type == 3;
				_pos4.selected = type == 4;
				_pos5.selected = type == 5;
			};
			
			_pos1 = new BmButton(_mc._pos1, function():void{selectTime(1)}, true);
			_pos2 = new BmButton(_mc._pos2, function():void{selectTime(2)}, true);
			_pos3 = new BmButton(_mc._pos3, function():void{selectTime(3)}, true);
			_pos4 = new BmButton(_mc._pos4, function():void{selectTime(4)}, true);
			_pos5 = new BmButton(_mc._pos5, function():void{selectTime(5)}, true);
			
			var freeNum:Object = Data.data.blueSun;
			
			for (var i:int = 1; i <= 5; i++) 
			{
				_mc['_pos' + i]._name.text = data[i]['name'];
				_mc['_pos' + i]._lvl.text = data[i]['level'];
				_mc['_pos' + i]._troopCount.text = data[i]['troop'];
				_mc['_pos' + i]._atk.text = data[i]['attack'];
				_mc['_pos' + i]._defense.text = data[i]['defense'];
				_mc['_pos' + i]._price.text = data[i]['price'];
				if(freeNum[i] > 0){
					_mc['_pos' + i]._freeNum.text = '免费' + freeNum[i] + '次';
					_mc['_pos' + i]._price.visible = false;
				}else{
					_mc['_pos' + i]._freeNum.text = '';
					_mc['_pos' + i]._price.visible = true;
				}
			}
		}
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_BLUESUN];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_BLUESUN:
					var freeNum:Object = Data.data.blueSun;
					for (var i:int = 1; i <= 5; i++) 
					{
						if(freeNum[i] > 0){
							_mc['_pos' + i]._freeNum.text = '免费' + freeNum[i] + '次';
							_mc['_pos' + i]._price.visible = false;
						}else{
							_mc['_pos' + i]._freeNum.text = '';
							_mc['_pos' + i]._price.visible = true;
						}
					}
					break;
				default:
			}
		}	
	}
}