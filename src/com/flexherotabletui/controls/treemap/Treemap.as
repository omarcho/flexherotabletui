package com.flexherotabletui.controls.treemap
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	import spark.components.DataGroup;

	/**
	 * Treemap implementation with squarify layout.
	 * A ligther version for mobile devices.
	 * 
	 * 
	 * @see http://en.wikipedia.org/wiki/Treemapping
	 * @author c17911
	 */	
	public class Treemap extends DataGroup
	{
		private var _labelField:String = "label";
		private var _sizeField:String = "value";
		private var _colorField:String = "value";
		
		private var dataProviderChanged:Boolean;
		private var sizeFieldChanged:Boolean;
		
		public function Treemap()
		{
			super();
			this.layout = new SquarifyLayout();
			var classFactory:ClassFactory = new ClassFactory(TreemapLeafItemRenderer);
			classFactory.properties = {mapOwner:this};
			this.itemRenderer = classFactory;
		}
		
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
		
		protected function sortDataProviderForRender():void
		{
			if(this.dataProvider != null) {
				var items:Array;
				if(this.dataProvider is ArrayCollection) {
					items = (this.dataProvider as ArrayCollection).source;
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
		
		override public function set dataProvider(value:IList):void {
			super.dataProvider = value;
			dataProviderChanged = true;
			invalidateProperties();
		}

		public function get labelField():String
		{
			return _labelField;
		}

		public function set labelField(value:String):void
		{
			_labelField = value;
		}

		public function get sizeField():String
		{
			return _sizeField;
		}

		public function set sizeField(value:String):void
		{
			_sizeField = value;
		}

		public function get colorField():String
		{
			return _colorField;
		}

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
		public function colorFunction(item:Object):int
		{
			if(item && item.hasOwnProperty(this.colorField)) {
				return 0xFF3300 * item[this.colorField];
			}
			return 0xefefef;
		}
		/**
		 * Label function for the items. 
		 * @param item
		 * @return 
		 * 
		 */		
		public function labelFunction(item:Object):String
		{
			if(item && item.hasOwnProperty(this.labelField)) {
				return item[this.labelField];
			}
			return "";
		}
	}
}