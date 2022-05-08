package res.bios.heaps;

import h2d.Bitmap;
import h2d.Scene;
import h2d.Tile;
import haxe.io.Bytes;
import hxd.Pixels;

class FrameBuffer extends res.display.FrameBuffer {
	final _pixels:Pixels;
	final _bitmap:Bitmap;

	public function new(s2d:Scene, width:Int, height:Int, palette:Palette) {
		super(width, height, palette.format([A, R, G, B]));

		_pixels = new Pixels(width, height, Bytes.alloc(width * height * 4), ARGB);
		_pixels.makeSquare(false);

		_bitmap = new Bitmap(Tile.fromPixels(_pixels), s2d);
	}

	override function clear(index:Int) {
		super.clear(index);

		for (line in 0...height)
			for (col in 0...width)
				setPixel(col, line, _palette.get(index));
	}

	function setPixel(x:Int, y:Int, color:Color32)
		_pixels.setPixel(x, y, color.output);

	override public function endFrame()
		_bitmap.tile.getTexture().uploadPixels(_pixels);
}
