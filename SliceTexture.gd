extends Polygon2D

signal on_sprite_assigned;

export var spritePath : NodePath;
var sprite : Sprite;
var textureArray : Array;

func _ready():
	get_parent().get_node("AnimationPlayer").play("New Anim");
	sprite = get_parent().get_node("Sprite");
	_on_sprite_assigned();
	sprite.connect("texture_changed",self,"_on_sprite_assigned");
	sprite.connect("frame_changed",self,"Set_Texture");

func Set_Image():
	textureArray.clear();
	var image = sprite.texture.get_data();
	var n = sprite.hframes;
	for i in range(n):
		var t = ImageTexture.new();
		var temp_image = image.get_rect(Rect2(Vector2(192*i,0),Vector2(192,192)))
		t.create_from_image(temp_image,sprite.texture.flags);
		
		textureArray.push_back(t);

func Set_Texture():
	texture = textureArray[sprite.frame];
	

func _on_sprite_assigned():
	Set_Image();
	Set_Texture();