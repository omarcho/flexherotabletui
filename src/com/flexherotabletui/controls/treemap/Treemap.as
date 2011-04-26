package com.flexherotabletui.controls.treemap
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	
	import spark.components.DataGroup;

	use namespace mx_internal;
	/**
	 * Treemap implementation with squarify layout.
	 * A ligther version for mobile devices.
	 * 
	 * 
	 * @example
	 * 
	 * var treemap:Treemap = new Treemap();
	 * treemap.dataProvider = [];
	 * 
	 * 
	 * @see http://en.wikipedia.org/wiki/Treemapping
	 * @author c17911
	 */	
	public class Treemap extends DataGroup implements ITreemap
	{
		private var _labelField:String = "label";
		
		private var _sizeField:String = "value";
		
		private var _colorField:String = "value";
		
		private var dataProviderChanged:Boolean;
		
		private var sizeFieldChanged:Boolean;
		
		private var defaultColor:int = 0xFF3300;
		
		private var _labelFunction:Function = _defaultLabelFunction;
		
		private var _colorFunction:Function = _defaultColorFunction;
		
		/**
		 * Constructor 
		 */		
		public function Treemap()
		{
			super();
			this.layout = new SquarifyLayout();
			var classFactory:ClassFactory = new ClassFactory(TreemapLeafItemRenderer);
			classFactory.properties = {mapOwner:this};
			this.itemRenderer = classFactory;
		}
		/**
		 * @inheritDoc 
		 */		
		override public function invalidateProperties():void {
			super.invalidateProperties();
			if(sizeFieldChanged && dataProviderChanged) {
				sizeFieldChanged = dataProviderChanged = false;
				this.sortDataProviderForRender();
			}
			if(dataProviderChanged) {
				this.dataProviderChanged = false;
				this.sortDataProviderForRender();
			} else if (sizeFieldChanged) {
				sizeFieldChanged = false;
				this.sortDataProviderForRender();
			}
		}
		/**
		 * @inheritDoc 
		 */
		override mx_internal function setUpItemRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
		{
			super.mx_internal::setUpItemRenderer(renderer, itemIndex, data);
			renderer.addEventListener(MouseEvent.CLICK, handleItemClick);
		}
		/**
		 * @inheritDoc 
		 */
		private function handleItemClick(event:MouseEvent):void
		{
			//trace(event.currentTarget as TreemapLeafItemRenderer);
			event.currentTarget.selected=!event.currentTarget.selected; 
		}
		/**
		 * This function asign and sort the dataprovide to renderer helper. 
		 */
		protected function sortDataProviderForRender():void
		{
			if(this.dataProvider != null) {
				var items:Array;
				if(this.dataProvider is ArrayCollection) {
					items = (this.dataProvider as ArrayCollection).source;
				} else if (this.dataProvider is ArrayList) {
					items = (this.dataProvider as ArrayList).source;
				}
				//my_array.sortOn(someFieldName, Array.DESCENDING | Array.NUMERIC);
				items.sortOn(this.sizeField,Array.DESCENDING | Array.NUMERIC);
				//this.sumarization = getSumarization(this.sizeField, items);
				//actualizo el layout object
				if(this.layout is SquarifyLayout) {
					(this.layout as SquarifyLayout).dataProvider = items;
					(this.layout as SquarifyLayout).sizeField = this.sizeField;
				}
			}
		}
		/**
		 * @inheritDoc
		 */		
		override public function set dataProvider(value:IList):void {
			super.dataProvider = value;
			dataProviderChanged = true;
			invalidateProperties();
		}
		/**
		 * @inheritDoc 
		 */		
		public function get labelField():String
		{
			return _labelField;
		}
		/**
		 * Label field provide a way to change the property from wich the comp display an item label.
		 * default is "label" 
		 * @return 
		 */
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		/**
		 * @inheritDoc 
		 */
		public function get sizeField():String
		{
			return _sizeField;
		}
		/**
		 * Size field provide a way to change the property from wich the comp calculate the area of squares.
		 * default is "value" 
		 * @return 
		 */
		public function set sizeField(value:String):void
		{
			_sizeField = value;
		}
		/**
		 * @inheritDoc 
		 */
		public function get colorField():String
		{
			return _colorField;
		}
		/**
		 * colorField provide a way to change the property from wich the comp use to calculate the color of squares.
		 * default is "value" 
		 * @return 
		 */
		public function set colorField(value:String):void
		{
			_colorField = value;
		}
		/**
		 * Color Function 
		 * @param item
		 * @return int of HEX color
		 * 
		 */		
		private function _defaultColorFunction(item:Object):int
		{
			if(item && item.hasOwnProperty(this.colorField)) {
				return this.defaultColor * item[this.colorField];
			}
			return this.defaultColor;
		}
		/**
		 * Label function for the items. 
		 * @param item
		 * @return 
		 * 
		 */		
		private function _defaultLabelFunction(item:Object):String
		{
			if(item && item.hasOwnProperty(this.labelField)) {
				return item[this.labelField];
			}
			return "";
		}
		/**
		 * @inheritDoc
		 */
		public function get colorFunction():Function
		{
			return _colorFunction;
		}

		public function set colorFunction(value:Function):void
		{
			_colorFunction = value;
		}
		/**
		 * @inheritDoc
		 */
		public function get labelFunction():Function
		{
			return _labelFunction;
		}

		public function set labelFunction(value:Function):void
		{
			_labelFunction = value;
		}


	}
}