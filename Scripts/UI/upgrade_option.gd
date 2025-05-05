extends Control
class_name UpgradePickerOption

@export_enum("Melee","Ranged","Outfit") var upgrade_type : String
@export var melee_upgrades : PermanentStatStrategy
@export var ranged_upgrades : PermenantProjectileStatStrategy
@export var outfit_upgrades : PermenantOutfitStatStrategy
@export var status_effect : BaseEffectStrategy
