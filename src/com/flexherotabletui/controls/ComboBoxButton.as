package com.flexherotabletui.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	import mx.collections.IList;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.List;
	
	[Event(name="accept", type="com.flexherotabletui.controls.ComboBoxButtonEvent")]
	[Event(name="cancel", type="com.flexherotabletui.controls.ComboBoxButtonEvent")]
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
		/**
		 * Allow multiple selection on the list 
		 * @return 
		 * 
		 */		
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}
		/**
		 * Allow multiple selection on the list 
		 * @return 
		 * 
		 */
		public function set allowMultipleSelection(value:Boolean):void
		{
			_allowMultipleSelection = value;
		}
		/**
		 * When the button was clicked react here 
		 * @param event
		 * 
		 */
		protected function onButtonClick(event:MouseEvent):void
		{
			this.displayList();
			
		}
		
		protected var _list:List;
		/**
		 * I don't know to test this on a tablet! 
		 * @param event
		 * 
		 */		
		protected function onButtonTap(event:TouchEvent):void
		{
			this.displayList();
			
		}
		/**
		 * internal function
		 */		
		protected function displayList():void
		{
			if(this._list == null) {
				this._list = new PromptList();
				if(this.handleListCreation is Function) {
					handleListCreation(this._list);
				}
				this._list.allowMultipleSelection = this.allowMultipleSelection;
				this._list.minWidth = 240;
				this._list.minHeight = 320;
				
				this._list.dataProvider = this.dataProvider;
				
				if(this.rememberSelectedItems) {
					this._list.selectedItems = this.selectedItems;
				}
				
				PopUpManager.addPopUp(this._list, this, true);
				
				this._list.addEventListener(PromptList.ACCEPT, this.onExitListTouch);
				this._list.addEventListener(PromptList.CANCEL, this.onExitListTouch);
			}
		}
		
		/**
		 * Exit handler.
		 *  
		 * @param event
		 */		
		protected function onExitListTouch(event:Event):void
		{
			if(this._list) {
				PopUpManager.removePopUp(this._list);
				
				if(this.rememberSelectedItems && event.type == PromptList.ACCEPT) {
					this.selectedItems = this._list.selectedItems;
				}
				
				var comboevent:ComboBoxButtonEvent = new ComboBoxButtonEvent(event.type);
				comboevent.data = this._list.selectedItems;
				this.dispatchEvent(comboevent);
				
				
				this._list = null;
			}
			
		}
		
		protected var _dataProvider:IList;
		
		private var _allowMultipleSelection:Boolean = false;
		/**
		 * Function to handle and setup extra params for the list UI.
		 * <code>
		 * my_button.handleListCreation = my_function(listui:List):void {<br />
		 * }
		 * </code>
		 *  
		 */		
		public var handleListCreation:Function;
		
		private var _selectedItems:Vector.<Object>;

		/**
		 * Set of selected items previously or for initial setup 
		 */
		public function get selectedItems():Vector.<Object>
		{
			return _selectedItems;
		}

		/**
		 * @private
		 */
		public function set selectedItems(value:Vector.<Object>):void
		{
			_selectedItems = value;
		}

		
		/**
		 * If you set this flag the selected items are preserver for later selection.
		 */		
		public var rememberSelectedItems:Boolean = true;
		
		/**
		 * Dataprovider for the poped-up list
		 *  
		 * @return 
		 */
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		/**
		 * Dataprovider for the poped-up list
		 *  
		 * @return 
		 */
		public function set dataProvider(value:IList):void
		{
			_dataProvider = value;
		}

	}
}