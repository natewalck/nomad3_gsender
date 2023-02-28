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
%Z_FINAL = 15	; Final height above probe


%UNITS=modal.units
%DISTANCE=modal.distance


G91 ; Relative positioning
G21 ; Use millimeters

; Probe Z
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
