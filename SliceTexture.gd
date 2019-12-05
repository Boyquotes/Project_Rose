extends Polygon2D

export var tex : Texture;
export var imgA : Array;

func _ready():
	"""
	var img2 = img.get_data();
	var idat = {'w': img2.get_width(), 'h': img2.get_height(), 'f': img2.get_format()}
	var ibytes = img2.get_data()
	idat['blen'] = len(ibytes)
	var img_out = File.new()
	var dat_out = File.new()
	img_out.open('res://img', File.WRITE)
	dat_out.open('res://img.json', File.WRITE)
	
	img_out.store_buffer(ibytes)
	dat_out.store_line(to_json(idat))
	img_out.close()
	dat_out.close()
	var img_in = File.new()
	var dat_in = File.new()
	img_in.open('res://img', File.READ)
	dat_in.open('res://img.json', File.READ)
	
	var dat = parse_json(dat_in.get_line())
	var inbytes = img_in.get_buffer(dat['blen'])
	var i = Image.new()
	i.create_from_data(dat['w'], dat['h'], false, dat['f'], inbytes)
	var t = ImageTexture.new()
	t.create_from_image(i)
	img_in.close()
	dat_in.close()
	texture = t;
	imgA.push_back(t);
	"""
	var img = tex.get_data();
	var n = img.get_width()/192;
	texture.frames = n;
	for i in range(n):
		imgA.push_back(img.get_rect(Rect2(Vector2(192*i,0),Vector2(192,192))));
		var t = ImageTexture.new();
		t.create_from_image(imgA[i]);
		texture.set_frame_texture(i,t);
	
	
	print(texture.frames);
	polygon.append(Vector2(0,0));
	polygon.append(Vector2(192,0));
	polygon.append(Vector2(192,192));
	polygon.append(Vector2(0,192));
	uv.append(Vector2(0,0));
	uv.append(Vector2(192,0));
	uv.append(Vector2(192,192));
	uv.append(Vector2(0,192));