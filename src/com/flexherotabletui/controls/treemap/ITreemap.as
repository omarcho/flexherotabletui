package com.flexherotabletui.controls.treemap
{
	public interface ITreemap
	{
		/**
		 * Provide a way to retrieve a label from an item
		 *  
		 * @param item
		 * @return String 
		 */
		function get labelFunction():Function;
		/**
		 * Provide a way to calculate the color for an item.
		 * Default color is 0xEFEFEF.
		 * You shoul return something like 0x[0-9{6}]
		 * @param item
		 * @return uint
		 */		
		function get colorFunction():Function;
	}
}