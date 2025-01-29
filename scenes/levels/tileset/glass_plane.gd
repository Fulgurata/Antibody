extends Node2D

@onready var unbroken: Sprite2D = $unbroken
@onready var breaking: AnimatedSprite2D = $breaking
@onready var broken: Sprite2D = $broken
@onready var block: StaticBody2D = $StaticBody2D


var is_broken: bool = false

func _ready():
	unbroken.visible = true
	breaking.visible = false
	broken.visible = false
	
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("bullet") and is_broken == false:
		is_broken = true
		unbroken.visible = false
		breaking.visible = true
		$glass_break.play()
		breaking.play()
		await breaking.animation_finished
		breaking.visible = false
		print("hiding")
		broken.visible = true
		for shape in block.get_children():
			if shape is CollisionShape2D:
				shape.disabled = true
