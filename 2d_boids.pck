GDPC                �                                                                         P   res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn�'      *      n-;|�~{� �su�    P   res://.godot/exported/133200997/export-b5c1dec75872349b928beccf83e85a2b-boid.scn@      �      �m��=;���#���_�    ,   res://.godot/global_script_class_cache.cfg   ,      �       Hf-�}һ�?T>�V4    D   res://.godot/imported/boid.png-8456e1fe60cfd707d6ab4f4deff9d97a.ctex@      4      n̛�٦/Jr�!=�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex0      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  P0      n       yEcP@����&��       res://boid.gd           8      E7�|��6@���T�A       res://boid.png.import   �      �       �� (��m��꯵��       res://boid.tscn.remap    +      a       K����j����8vEr       res://icon.svg  �,      �      C��=U���^Qu��U3       res://icon.svg.import   #      �       SAJU2K�(2�!N�w       res://main.gd   �#            ��W٤��)�!@�9�j~       res://main.tscn.remap   �+      a       �J�Sw� ������       res://project.binary�0      �      �~��k�(ָ���R            extends CharacterBody2D
class_name Boid

var ALIGNMENT_VAL = 0.9
var COHESION_VAL = 0.9
var SEPERATION_VAL = 0.9

var avoid_dist = 100.0

var speed = 5.0
var boids_around = []

func _physics_process(delta):
	var center = Vector2()
	var align = Vector2()
	var avoid = Vector2()
	
		
	var averagePos = Vector2(0,0)
	for boid in boids_around:
		if boid == self: continue
		align += boid.velocity
		averagePos += boid.position
		
		var dist = position.distance_to(boid.position)
		if dist > 0 and dist < avoid_dist:
			avoid -= (boid.position - position).normalized() * (avoid_dist/dist)
	
	
	var mouse_dist = position.distance_to(get_global_mouse_position())
	if mouse_dist > 0 and mouse_dist < 300:
		avoid -= (get_global_mouse_position() - position).normalized() 
	
	if len(boids_around) != 0:
		align = align/(len(boids_around))
		averagePos = averagePos/(len(boids_around))
		center = position.direction_to(averagePos)
	
	var accel = Vector2()
	accel += center * COHESION_VAL
	accel += align * ALIGNMENT_VAL
	accel += avoid * SEPERATION_VAL
	#accel += position.direction_to(get_global_mouse_position())
	
	velocity = (velocity + accel).normalized() * speed
	rotation = velocity.angle()
	move_and_collide(velocity)
	
	
func start(pos):
	position = pos
	rotation = randf_range(-PI, PI)
	velocity = Vector2(speed, 0).rotated(rotation)
	
func interpolate(a,b,t):
	return a*t + (1-t)*b

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var width = get_viewport().get_visible_rect().size.x
	var height = get_viewport().get_visible_rect().size.y
	if position.x > width:
		position.x = 0
	if position.x < 0:
		position.x = width
	if position.y > height:
		position.y = 0
	if position.y < 0:
		position.y = height
			

func _on_area_2d_body_entered(body):
	if body == self: 
		return
	if body is Boid:
		boids_around.append(body)


func _on_area_2d_body_exited(body):
	if body == self: 
		return
	if body is Boid:
		boids_around.erase(body)
			
        GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /��o۶M۶�-^G���{��Mm۶��l۶m�6'��@�yڶIҫ,�m�6Ƕm۶m�V۶mM�8"�Ȉ�mFt�`�ye?�E��b0s���;�0��3d��+�g��� S��5?�3�J�򂱷`���L#�[N�?^�>��ЩS�I�%���7��d�p��	�p�W�_︟�X����mO�����d��.��m+�te�R_lw������te#��r�^7��*���;Uec���`�;��4]�������Sg��5�4_��qN!PUo��.3*�;�.��4�%-Y��deζ
��EM&���Tْ��B���s�w�T��5�� �]�gH��kVe��U+�}��s�xGTٲ[�JE_�<���+[w�Z�A�;�GO-������Q�E��g��JW��!����_�=���f*��Z�@�h��IXnU�mz��]
0ݘ���T��m/�{�:aܹ!��PپW�O�,vڰ3!\dTx��L6�J�3��C��»��ֻPb�9KXi�C��� [\1��p�]id_�^���U5^��^�*��|�-{ݢz�+ZǕ���Aw�=ڼ�TZ:�-G=��X��><�*M�h�c�5}
��N�
��G�ï3���1A�%M��nP��.6
A�Z3�JW�B��6�̵��J׫��>�a��;�gT��U�uP�.C��c�=���]j��aΤ����ǖ(���� �Y8Ωt�Z�A�������E���S��d�{�(嵮�����`�q����d����O��wb�T[8V���S� K��sz�*���|.`�sU��{�/�������%�Rav�VU��(�J`�+Uv�v�p S���7� �ܠ��\����f����ݪ���ζ*�8�+�ܣv�4q$��VFq�[��m?��K�2��B`yB���Q8ʭ��x�ոq���3+#9�,�W4m;Äk]˥F!�xK˦�\�S�2��U!��@ۆ��2ܧ*��A�tP������lؗ��6��Ah~��+]��l�].�g�%"K��93��֋��R���7i�����`׫��B�M0���<�)�u��|*`���!�%G�]�3� s�&M�.�ct}�!`��H[����8׾ԗ�V8�4��C�=o�d��X�,Ҝ����(�oA�M.T��9�^�A�C�B��e�=��o;Ct�[v�F����p�3�u�S��Q��X�p�j���PM�P���ݽ��B�ܫ6�ś�(��u�Y,��C�1\��;_������5��ͮ]�
A�IO^
��=�[�J�jJ�2H���;�Z9�hN�Rm}x���}jEjMz�t�[��zH툂�ϵ#�髸ҝ�'�Rʾщ�������3���u'#�H�S��������ЛA�B��U{o!�&@� aIx�X��r>�0�P2
���fZ_ﺟ��c4�.2��}�!`���8T��TMۗ�r2�r����-�2��:���`���P��l��oA�M.PA���p�j�!~!��R	2ׇ��]G��`�k�����fߎw
�~7�"�1!\��t�]�C5�+��|��l�(��MF�;�4�"�XQ����Rc��eF!�<�>������ZU�kHF�	����Mj���W5!��c8���u�Z� �m�������m]��u|�5����m���%�kG��p����	����ot"�s
��[��1�0���;�z����-������Л����D{k׫��B�M0�L�q�%������\�����cwx��Bﺟ��m4��w�1�����:�L�H�:��ڗ�r2�r��Y�e[x�ܤ�ox�:��ë�o��� �F���"\덯C�B�ݥd"�m�u�[v�F�L�s���qN!��FUd.�+���_�څ��;T�ɨ�:<�����B�ܫ6����_��s]d�����P���ˌB�yR}2!	�p��J�ZU�kH��~8��;N޳�Aƫ��I��r�֜L4|���|��            [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://w6jp7q40avpc"
path="res://.godot/imported/boid.png-8456e1fe60cfd707d6ab4f4deff9d97a.ctex"
metadata={
"vram_texture": false
}
 RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    radius    script 	   _bundled       Script    res://boid.gd ��������
   Texture2D    res://boid.png ���WS      local://CircleShape2D_0auec x         local://PackedScene_8wpgo �         CircleShape2D          �GAB         PackedScene          	         names "         boid    script    CharacterBody2D 	   Sprite2D    scale    texture    CollisionPolygon2D    polygon    Area2D    CollisionShape2D    shape    _on_area_2d_body_entered    body_entered    _on_area_2d_body_exited    body_exited    	   variants                 
   ���=���=         %        ��  ��   �      ��  �@  �@                    node_count             nodes     -   ��������       ����                            ����                                 ����                           ����               	   	   ����   
                conn_count             conns                                                              node_paths              editable_instances              version             RSRC     GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cpf5nl3x3l6ko"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                extends Node

@export var boid_scene: PackedScene

@export var Coherence = 0.0
@export var Seperation = 0.0
@export var Alignment = 0.0
@export var AvoidDistance = 0.0

var all_boids = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(30):
		spawn_boid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_boid():
	var boid = boid_scene.instantiate()
	var width = get_viewport().get_visible_rect().size.x
	var height = get_viewport().get_visible_rect().size.y
	var start_pos = Vector2(
		randi_range(0, width),
		randi_range(0, height))
	boid.start(start_pos)
	all_boids += [boid]
	add_child(boid)
	

func _input(event):
	if event is InputEventMouseButton and event.is_released():
		if event.get_button_index() == MOUSE_BUTTON_LEFT: 
			for i in range(5):
				spawn_boid()
		if event.get_button_index() == MOUSE_BUTTON_RIGHT:
			for i in range(5):
				var boid = all_boids.pop_front()
				if boid:
					boid.queue_free()
   RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://main.gd ��������   PackedScene    res://boid.tscn �I�3	�&      local://PackedScene_fdda6 1         PackedScene          	         names "         Main    script    boid_scene 
   Alignment    Node 
   BoidSpawn 	   position 	   Marker2D    	   variants                               �?
    �D ��C      node_count             nodes        ��������       ����                                        ����                   conn_count              conns               node_paths              editable_instances              version             RSRC      [remap]

path="res://.godot/exported/133200997/export-b5c1dec75872349b928beccf83e85a2b-boid.scn"
               [remap]

path="res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn"
               list=Array[Dictionary]([{
"base": &"CharacterBody2D",
"class": &"Boid",
"icon": "",
"language": &"GDScript",
"path": "res://boid.gd"
}])
       <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             �I�3	�&   res://boid.tscnV����-Q   res://icon.svg�̈�L��Z   res://main.tscn���WS   res://boid.png  ECFG      application/config/name         2d_boids   application/run/main_scene         res://main.tscn    application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg     layer_names/2d_physics/layer_1         boids   #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility          