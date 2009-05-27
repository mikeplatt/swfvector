/* * Copyright 2009 (c) Guojian Miguel Wu, guojian@wu-media.com. * * Permission is hereby granted, free of charge, to any person * obtaining a copy of this software and associated documentation * files (the "Software"), to deal in the Software without * restriction, including without limitation the rights to use, * copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the * Software is furnished to do so, subject to the following * conditions: * * The above copyright notice and this permission notice shall be * included in all copies or substantial portions of the Software. * * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR * OTHER DEALINGS IN THE SOFTWARE. */package wumedia.parsers.swf {	import flash.display.GradientType;
	import flash.geom.Matrix;		
	/**	 * @author guojianwu	 */	public class SWFGraphicsFillStyle extends SWFGraphicsElement {		public function SWFGraphicsFillStyle(data:SWFData, hasAlpha:Boolean) {			var i:int;			var fillType:int = data.readUnsignedByte();			if ( fillType == 0x00 ) {				_solidColor = new SWFColor(data, hasAlpha);				_function = "beginFill";				_arguments = [_solidColor.color, _solidColor.alpha];				_type = "FS";			} else if ( fillType == 0x10 || fillType == 0x12 || fillType == 0x13 ) {				// gradient - linear || radial || focal radial				var numRatios:int;				var ratios:Array;				var colors:Array;				_fillMatrix = new SWFMatrix(data);       			       			numRatios = data.readUnsignedByte();				ratios = new Array(numRatios);				colors = new Array(numRatios);				for ( i = 0; i < numRatios; ++i ) {					ratios[i] = data.readUnsignedByte();					colors[i] = new SWFColor(data, hasAlpha);				}				if ( fillType == 0x10 ) {					_arguments = [GradientType.LINEAR];				} else if ( fillType == 0x12 ) {					_arguments = [GradientType.RADIAL];				} else /*if ( fillType == 0x13 )*/ {					_arguments = [GradientType.RADIAL];				}				_arguments = _arguments.concat([colors.map(mapColors), colors.map(mapAlphas), ratios]);				_function = "beginGradientFill";				_type = "FG";			} else if ( fillType == 0x40 || fillType == 0x41 || fillType == 0x42 || fillType == 0x43 ) {				// repeat bitmap || regular bitmap || non-smooth repeat || no-smooth regular				// TODO - not yet implemented				var bitmapId:uint;				bitmapId = data.readUnsignedShort();				_fillMatrix = new SWFMatrix(data);				_function = "beginBitmapFill";				_type = "FB";			} else {				_type = "FS";				_function = "beginFill";				_arguments = [0xffffff];			}		}				private var _solidColor	:SWFColor;		private var _fillMatrix :Matrix;		private var _function	:String;		private var _arguments	:Array;				override public function apply(graphics:*, scale:Number = 1.0, offsetX:Number = 0.0, offsetY:Number = 0.0):void {			if ( graphics.hasOwnProperty(_function) ) {				if ( _type == "FS" ) {					graphics[_function].apply(null, _arguments);				} else {					var mat:Matrix = _fillMatrix.clone();					mat.scale(scale, scale);					mat.translate(offsetX, offsetY);					graphics[_function].apply(null, _arguments.concat(mat));				}			}		}				override public function toString():String {			return ["F", _solidColor ? "0x" +_solidColor.color.toString(16) : "Gradient"].join(", ");		}				private function mapColors(c:SWFColor, ...args):uint { return c.color;}		private function mapAlphas(c:SWFColor, ...args):uint { return c.alpha;}	}}