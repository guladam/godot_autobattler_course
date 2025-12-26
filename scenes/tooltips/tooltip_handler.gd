extends CanvasLayer

const DETAILED_TOOLTIP = preload("uid://cw7klrmt8unc")
const UNIT_TOOLTIP = preload("uid://dbe7j8b23vftu")

@onready var popup: GamePopup = %Popup
@onready var popup_2: GamePopup = %Popup2
@onready var timer: Timer = $Timer

func show_timed_popup(message: String, time: float) -> void:
	var label := Label.new()
	label.text = message
	await popup.show_popup(label, Vector2i.ZERO)
	TooltipHandler.popup.center()
	timer.wait_time = time
	timer.start()
	popup.hidden.connect(func(): timer.stop(), CONNECT_ONE_SHOT)
	timer.timeout.connect(func(): popup.hide_popup(), CONNECT_ONE_SHOT)
