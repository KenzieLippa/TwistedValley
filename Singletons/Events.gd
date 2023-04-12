extends Node


signal request_show_message(message)
signal request_show_dialogue(message, character)

#wont have access to the box so we need th dialogue to connect with the events
signal dialogue_finished
#moved this from here to the battle menu manager for ease of use
#signal battle_menu_option_selected(selected_resource)
#signal for the showing of menu
signal request_show_overworld_menu()
signal request_update_camera_limits(limits)#send out a box

signal update_time
