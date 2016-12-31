package com.brickmice.view.girlhero
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCheckBox;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McDropDownList;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.utils.KeyValue;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class Inherit extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Inherit";
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _inheritor:MovieClip;
		private var _closeBtn:MovieClip;
		private var _ancestor:MovieClip;
		private var _goldenInheritCost:TextField;
		private var _checkbox:MovieClip;
		
		private var _hid:int = 0;
		private var _isPay:int = 0;
		private var _inheritId:int = 0;
		private var _inheritImg:McItem;
		private var _ancestorImg:McItem;
		private var _dropDownList:McDropDownList;
		
		
		/**
		 * 传承
		 * @param hid 传承的员工ID 
		 * @param callback
		 * 
		 */
		public function Inherit(hid : int, callback:Function)
		{
			_mc = new ResGirlHeroInheritWindow;
			super(NAME, _mc);
			
			_hid = hid;
			_yesBtn = _mc._yesBtn;
			_inheritor = _mc._inheritor;
			_ancestor = _mc._ancestor;
			_goldenInheritCost = _mc._goldenInheritCost;
			_checkbox = _mc._checkbox;
			
			var ancestor:Object = Data.data.girlHero[hid];
			_goldenInheritCost.text = inheritCost(ancestor.level);
			_mc._ancestorBar._name.htmlText =  '<font color="' + Trans.heroQualityColor[ancestor.quality] + '">' + ancestor.name + '</font>';
			_mc._ancestorBar._lvl.text = "Lv:" + ancestor.level;
			_ancestor._lvl.text = ancestor.level;
			_ancestor._point.text = ancestor.pointLimit;
			_ancestor._logic.text = Math.floor(ancestor.logic).toString();
			_ancestor._create.text = Math.floor(ancestor.create).toString();
			_ancestor._speed.text = Math.floor(ancestor.speed).toString() + " / 每分钟";
			
			_inheritImg = new McItem();
			_ancestorImg = new McItem(ancestor.img);
			
			addChildEx(_ancestorImg, 92, 112);
			addChildEx(_inheritImg, 288, 112);
			
			//下拉框
			var data:Object = Data.data.girlHero;
			var heroArr:Array = [];
			//过滤
			for(var k:String in data) {
				if(data[k].inherit == "")
					heroArr.push(data[k]);
			}
			heroArr.sortOn(["level", "id"], [Array.DESCENDING | Array.NUMERIC, Array.NUMERIC]);
			var items:Array = [];
			for each(var one:Object in heroArr) {
				if(one.id == hid) continue;
				var msg:String = one.name + " Lv:" + one.level;
				items.push(new KeyValue(one.id, msg));
			}
			
			_dropDownList = new McDropDownList(items, 170, 18, 0, onChanged);
			addChildEx(_dropDownList, 237, 75);
			if(items.length) _dropDownList.index = 0;
			
			new BmCheckBox(_checkbox, function():void{
				_isPay = 1 - _isPay;
				onChanged(_inheritId.toString());
			});
			
			new BmButton(_yesBtn, function():void{
				if(!_inheritId){
					TextMessage.showEffect("请选择需要被传承的美人", 2);
					return;
				}
				ModelManager.girlHeroModel.inheritGirlHero(hid, _inheritId, _isPay, function():void{
					callback();
					closeWindow();
				});
			});
		}
		
		//宇宙钻传承花费
		private function inheritCost(level:int):String
		{
			return (level * 5).toString();
		}
		
		/**
		 * 选项改变触发
		 * */		
		private function onChanged(title:String):void
		{
			var data:Object = Data.data.girlHero[title];
			_inheritId = int(title);
			ModelManager.girlHeroModel.viewInheritGirlHero(_hid, _inheritId, _isPay, function():void{
				var newData:Object = Data.data.inherit;
				_inheritImg.resetImage(data.img);
				_inheritor._lvl.htmlText = data.level + '<font color="#00FF00"> (' + newData.level + ')</font>';
				_inheritor._point.htmlText = data.pointLimit + '<font color="#00FF00"> (' + newData.pointLimit + ')</font>';
				_inheritor._logic.htmlText = Math.floor(data.logic).toString() + '<font color="#00FF00"> (' + Math.floor(newData.logic) + ')</font>';
				_inheritor._create.htmlText = Math.floor(data.create).toString() + '<font color="#00FF00"> (' + Math.floor(newData.create) + ')</font>';
				_inheritor._speed.htmlText = Math.floor(data.speed).toString() + '<font color="#00FF00"> (' + Math.floor(newData.speed) + ')</font>';
			});
		}
	}
}