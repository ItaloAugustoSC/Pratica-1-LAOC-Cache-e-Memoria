onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /p3_main/SW
add wave -noupdate /p3_main/dataMemOut
add wave -noupdate /p3_main/dataCacheOut
add wave -noupdate /p3_main/dataOut
add wave -noupdate -radix unsigned /p3_main/writeBack
add wave -noupdate -radix unsigned /p3_main/hit
add wave -noupdate /p3_main/exibirBlocoVia0Antes
add wave -noupdate /p3_main/exibirBlocoVia1Antes
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9846 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 194
configure wave -valuecolwidth 87
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {8536 ps} {11445 ps}
