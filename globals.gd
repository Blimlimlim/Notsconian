extends Node
class_name Globals

const packed_beam = preload("res://beam.tscn")


#============= Constants =================
const MAP_LENGTH = 4000 #originally 2304
const MAP_HEIGHT = 4000 #originally 1296 use those values as control
# NOTE, current paralax background transitions seemlessly when wrapping around the map only when map dimentions are a mulitple of 4x the back ground pixels

const PLAYER_SPEED = 375
const ARCSHIP_SPEED = PLAYER_SPEED +50
const ARCSHIP_ANGLSPEED = PI
const BUGSHIP_SPEED = PLAYER_SPEED -100
const BUGSHIP_ANGLSPEED = PI*2
const BULLETSHIP_SPEED = PLAYER_SPEED + 275
const BULLETSHIP_ANGLSPEED = PI/1.75

const ENEMY_ANGLE_OFFSET = PI/5

const WRAP_OFFSET = 30
# clone positions
const N = Vector2(0, -MAP_HEIGHT)
const NE = Vector2(MAP_LENGTH, -MAP_HEIGHT)
const E = Vector2(MAP_LENGTH, 0)
const SE = Vector2(MAP_LENGTH, MAP_HEIGHT)
const S = Vector2(0, MAP_HEIGHT)
const SW = Vector2(-MAP_LENGTH, MAP_HEIGHT)
const W = Vector2(-MAP_LENGTH, 0)
const NW = Vector2(-MAP_LENGTH, -MAP_HEIGHT)
