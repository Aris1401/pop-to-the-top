extends Node
class_name DamageManager

# Damage tracking
var total_damage : float = 0.0

# Signals
signal damage_dealt(damage : float, total_damage : float)
signal limit_reached

var immunity : bool = false

func reset_damage():
	do_damage(-total_damage)

func do_damage(damage):
	if immunity:
		return
	
	total_damage += damage
	
	if total_damage >= 100:
		total_damage = 100
		limit_reached.emit()
	
	damage_dealt.emit(damage, total_damage)
