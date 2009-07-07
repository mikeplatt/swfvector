package test {
import wumedia.vector.VectorText;

import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

/**
 * @author lenovo
 */
public class TestLoadFonts extends Sprite {
	public function TestLoadFonts() {
		if ( stage ) {
			init();
		} else {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	private var _loader:URLLoader;
	private function init(e:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		_loader = new URLLoader();
		_loader.dataFormat = URLLoaderDataFormat.BINARY;
		_loader.addEventListener(Event.COMPLETE, onLoaded);
		_loader.load(new URLRequest("fonts.swf"));
	}
	
	private function onLoaded(e:Event):void {
		_loader.removeEventListener(Event.COMPLETE, onLoaded);
		VectorText.extractFont(_loader.data, null, true);
		
		graphics.beginFill(0xff9900);
		VectorText.write(graphics, "Zurich Blk BT", 18, 18, 0, "Zurich Blk BT", 0, 0);
	}
}
}