extends Node
class_name Globals

# ======== Preloads ===========
const packed_beam   = preload("res://beam.tscn")
const PACKED_BOMB   = preload("res://bomb.tscn")
# enemy ships
const PACKED_ARC    = preload("res://arc_ship.tscn")
const PACKED_BUG    = preload("res://bug_ship.tscn")
const PACKED_BULLET = preload("res://bullet_ship.tscn")

#============= Constants =================
const MAP_LENGTH = 4000 #originally 2304
const MAP_HEIGHT = 4000 #originally 1296 use those values as control
# NOTE, current paralax background transitions seemlessly when wrapping around the map only when map dimentions are a mulitple of 4x the back ground pixels
#const MAP_HALF_LENGTH = MAP_LENGTH/2
#const MAP_HALF_HEIGHT = MAP_HEIGHT/2

const PLAYER_SPEED         = 320
const ARCSHIP_SPEED        = PLAYER_SPEED * 1.156
const ARCSHIP_ANGLSPEED    = PI * 1.20
const BUGSHIP_SPEED        = PLAYER_SPEED * 0.75
const BUGSHIP_ANGLSPEED    = PI*2
const BULLETSHIP_SPEED     = PLAYER_SPEED * 1.48
const BULLETSHIP_ANGLSPEED = PI/1.75
const BOMB_SPEED = 150

const ENEMY_BEELINE_SPEED_OFFSET = 130
const ENEMY_ANGLE_OFFSET         = PI/6

const CODE_GREEN_SPAWN_DELAY = 4.0
const CODE_RED_SPAWN_DELAY = 1.25

const WRAP_OFFSET = 30
# entity mirror positions
const N = Vector2(0, -MAP_HEIGHT)
const NE = Vector2(MAP_LENGTH, -MAP_HEIGHT)
const E = Vector2(MAP_LENGTH, 0)
const SE = Vector2(MAP_LENGTH, MAP_HEIGHT)
const S = Vector2(0, MAP_HEIGHT)
const SW = Vector2(-MAP_LENGTH, MAP_HEIGHT)
const W = Vector2(-MAP_LENGTH, 0)
const NW = Vector2(-MAP_LENGTH, -MAP_HEIGHT)

var random = RandomNumberGenerator.new()
