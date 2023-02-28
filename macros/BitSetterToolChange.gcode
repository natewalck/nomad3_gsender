;Bitsetter measure tool better

; Wait until the planner queue is empty
%wait

%global.state.SAFE_HEIGHT = -10          ; clear everything height(negative number, distance below Z limit)
; Set BitSetter probe location
%global.state.BITSETTER_X_LOCATION = -5  ; machine coordinates
%global.state.BITSETTER_Y_LOCATION = -3  ; machine coordinates
%global.state.BITSETTER_Z_LOCATION = -20 ; machine coordinates --> lower this (more negative) to start the probing closer to wasteboard

; Location for tool changes
%global.state.TOOLCHANGE_X = -125

%global.state.BITSETTER_PROBE_DISTANCE = 100
%global.state.BITSETTER_PROBE_FEEDRATE = 300 ; mm/min

; Wait until the planner queue is empty
%wait

; Keep a backup of current work position
%X0=posx, Y0=posy, Z0=posz

; Save modal state
%WCS = modal.wcs
%PLANE = modal.plane
%UNITS = modal.units
%DISTANCE = modal.distance
%FEEDRATE = modal.feedrate
%SPINDLE = modal.spindle
%COOLANT = modal.coolant

G21 ; metric
M5  ; Stop spindle
G90 ; Absolute positioning

; Get to a safe height and park for tool change
G53 G0 Z[global.state.SAFE_HEIGHT]
G53 X[global.state.TOOLCHANGE_X] Y[global.state.BITSETTER_Y_LOCATION]

; Pause for manual tool change & probing
%wait
M0 ; Please insert a tool

; Go to BitSetter
G53 X[global.state.BITSETTER_X_LOCATION] Y[global.state.BITSETTER_Y_LOCATION]
G53 Z[global.state.BITSETTER_Z_LOCATION]

%probe_start_z = posz

G91 ; Relative positioning

G38.2 z-[global.state.BITSETTER_PROBE_DISTANCE] F[global.state.BITSETTER_PROBE_FEEDRATE]; fast probe (so it doesn't take forever)
G0 z2
G38.2 z-5 F40 ; "dial-it-in" probes
G4 P.25
G38.4 z10 F20
G4 P.25
G38.2 z-2 F10
G4 P.25
G38.4 z10 F5
G4 P.25

G90 ; Abosolute positioning
%wait

; Get the Z position at the end of measuring tool length
%probe_end_z = posz
%probe_actual_distance = probe_start_z - probe_end_z
%is_initial_tool = ! (global.state.PROBE_ACTUAL_DISTANCE > 0)

; Update Z offset for new tool
; note: do this in individual steps otherwise it sometimes treats some variables as strings (wtf??)
;     resulting in new_z=-31.0423.3225252

%delta_z = is_initial_tool ? 0 : probe_actual_distance*1.0 - global.state.PROBE_ACTUAL_DISTANCE*1.0
%new_z = posz*1.0 + delta_z*1.0
%new_z  =  Math.round(new_z * 1000) / 1000
(old=[global.state.PROBE_ACTUAL_DISTANCE] new=[probe_actual_distance] new_z=[new_z])

G10 L20 Z[new_z]

%global.state.PROBE_ACTUAL_DISTANCE = probe_actual_distance

%wait

G91 ; Relative positioning
G0 Z5
G90 ; Absolute positioning
G53 Z[global.state.SAFE_HEIGHT] ; Move in machine coordinates to safe height
%wait
; Go to work zero at a SAFE_HEIGHT for Z
G0 X0 Y0

; Restore modal state
[PLANE] [UNITS] [DISTANCE] [FEEDRATE] [SPINDLE] [COOLANT]
