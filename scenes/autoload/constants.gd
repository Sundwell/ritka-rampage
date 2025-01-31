extends Node

const GROUPS = {
	"PLAYER": "player",
	"ENTITIES_LAYER": "entities_layer",
	"FOREGROUND_LAYER": "foreground_layer",
	"ENEMY": "enemy",
	"ANVIL": "anvil",
	"DECORATION": "decoration",
}

enum Weapon {
	PISTOL,
}

enum UIPositions {
	CENTER,
	RIGHT
}

const PLAYER_VIEW_RADIUS = 370.0

const AUDIO_BUSES = {
	"SFX": "SFX",
	"Music": "Music",
	"Master": "Master"
}