;BitZero V2

;Start with end mill in hole, BELOW Z surface of probe

; Wait until the planner queue is empty
%wait

; Set user-defined variables
%Z_PROBE_THICKNESS = 13.02	;thickness of Z probe plate
%PROBE_DISTANCE = 20  ;Max distance for a probe motion
%PROBE_FEEDRATE_A = 150
%PROBE_FEEDRATE_B = 30
%PROBE_MAJOR_RETRACT = 3  ;distance of retract before probing opposite side
%Z_PROBE = 15	; Lift out of hole and Max Z probe
%Z_PROBE_KEEPOUT = 15	;distance (X&Y) from edge of hole for Z probe
%Z_FINAL = 15	;final height above probe


%UNITS=modal.units
%DISTANCE=modal.distance


G91 ; Relative positioning
G21 ;Use millimeters

; Probe X
; Probe toward right side of hole with a maximum probe distance
G38.2 X[PROBE_DISTANCE] F[PROBE_FEEDRATE_A]
G0 X-2 ;retract 2mm
G38.2 X5 F[PROBE_FEEDRATE_B] ;Slow Probe
%X_RIGHT = posx
G0 X-[PROBE_MAJOR_RETRACT]	;retract

; Probe toward Left side of hole with a maximum probe distance
G38.2 X-[PROBE_DISTANCE] F[PROBE_FEEDRATE_A]
G0 X2 ;retract 2mm
G38.2 X-5 F[PROBE_FEEDRATE_B] ;Slow Probe
%X_LEFT = posx
%X_CHORD = X_RIGHT - X_LEFT
G0 X[X_CHORD/2]
%X_CENTER = posx	;get X-value of hole center for some reason
; A dwell time of one second to make sure the planner queue is empty
G4 P1
G10L20X0

; Probe Y
; Probe toward top side of hole with a maximum probe distance
G38.2 Y[PROBE_DISTANCE] F[PROBE_FEEDRATE_A]
G0 Y-2 ;retract 2mm
G38.2 Y5 F[PROBE_FEEDRATE_B] ;Slow Probe
%Y_TOP = posy
G0 Y-[PROBE_MAJOR_RETRACT]	;retract
; Probe toward bottom side of hole with a maximum probe distance
G38.2 Y-[PROBE_DISTANCE] F[PROBE_FEEDRATE_A]
G0 Y2 ;retract 2mm
G38.2 Y-5 F[PROBE_FEEDRATE_B] ;Slow Probe
%Y_BTM = posy
%Y_CHORD = Y_TOP - Y_BTM
%HOLE_RADIUS = Y_CHORD/2
G0 Y[HOLE_RADIUS]
%Y_CENTER = posy	;get Y-value of hole center for some reason
; A dwell time of one second to make sure the planner queue is empty
G4 P1
G10L20Y0

; Probe Z
G0 Z15
G0 X10 Y10
G38.2 Z-[Z_PROBE] F[PROBE_FEEDRATE_A]
G0 Z2 ;retract 2mm
G38.2 Z-15 F[PROBE_FEEDRATE_B] ;Slow Probe
G10L20Z[Z_PROBE_THICKNESS]
G0 Z[Z_FINAL+10]	;raise Z
G90	;absolute distance
G0 X0 Y0
; A dwell time of one second to make sure the planner queue is empty
G4 P1

[UNITS] [DISTANCE] ;restore unit and distance modal state
