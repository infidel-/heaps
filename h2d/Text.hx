package h2d;

class Text extends Sprite {

	public var font(default, null) : Font;
	public var text(default, set) : String;
	public var textColor(default, set) : Int;
	public var alpha(default, set) : Float;
	public var maxWidth(default, set) : Null<Float>;
	
	var glyphs : TileGroup;
	
	public function new( font : Font, ?parent ) {
		super(parent);
		this.font = font;
		glyphs = new TileGroup(font, this);
		text = "";
		textColor = 0xFFFFFF;
		alpha = 1.0;
	}
	
	override function onDelete() {
		glyphs.onDelete();
		super.onDelete();
	}
	
	function set_text(t) {
		this.text = t;
		glyphs.reset();
		var letters = font.glyphs;
		var x = 0, y = 0;
		for( i in 0...t.length ) {
			var cc = t.charCodeAt(i);
			var e = letters[cc];
			// if the next word goes past the max width, change it into a newline
			if( cc == ' '.code && maxWidth != null ) {
				var size = x + e.width + 1;
				var k = i + 1, max = t.length;
				while( size <= maxWidth ) {
					var cc = t.charCodeAt(k++);
					if( cc == null || cc == ' '.code || cc == '\n'.code ) break;
					var e = letters[cc];
					if( e != null ) size += e.width + 1;
				}
				if( size > maxWidth ) {
					e = null;
					cc = '\n'.code;
				}
			}
			if( e == null ) {
				if( cc == '\n'.code ) {
					x = 0;
					y += font.lineHeight;
				}
				continue;
			}
			glyphs.add(x, y, e);
			x += e.width + 1;
		}
		return t;
	}
	
	function set_maxWidth(w) {
		maxWidth = w;
		this.text = text;
		return w;
	}
	
	function set_textColor(c) {
		this.textColor = c;
		glyphs.color.loadInt(c, alpha);
		return c;
	}
	
	function set_alpha(a) {
		this.alpha = a;
		glyphs.color.a = a;
		return a;
	}

}