package com.flexherotabletui.controls
{
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	import mx.collections.IList;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.List;
	
	
	/**
	 * ComboBoxButton an interface that allows you to place a button with on click display an overlay pop-up of a list.
	 *  
	 * @author c17911
	 */	
	public class ComboBoxButton extends Button
	{
		public function ComboBoxButton()
		{
			super();
			this.addEventListener(TouchEvent.TOUCH_TAP, this.onButtonTap);
			this.addEventListener(MouseEvent.CLICK, this.onButtonClick);
		}
		
		protected function onButtonClick(event:MouseEvent):void
		{
			this.displayList();
			
		}
		
		protected var _list:List;
		
		protected function onButtonTap(event:TouchEvent):void
		{
			this.displayList();
			
		}
		
		private function displayList():void
		{
			if(this._list == null) {
				this._list = new PromptList();
				this._list.minWidth = 240;
				this._list.minHeight = 320;
				this._list.dataProvider = this.dataProvider;
				PopUpManager.addPopUp(this._list, this, true);
				this._list.addEventListener(TouchEvent.TOUCH_OUT,this.onExitListTouch);
			}
			
		}
		
		protected function onExitListTouch(event:TouchEvent):void
		{
			if(this._list) {
				this._list.addEventListener(TouchEvent.TOUCH_OUT,this.onExitListTouch);
				PopUpManager.removePopUp(this._list);
				this._list = null;
			}
			
		}
		
		protected var _dataProvider:IList;

		public function get dataProvider():IList
		{
			return _dataProvider;
		}

		public function set dataProvider(value:IList):void
		{
			_dataProvider = value;
		}

	}
}