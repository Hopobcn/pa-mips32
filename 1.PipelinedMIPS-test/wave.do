onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipelinedmips32test/clk
add wave -noupdate /pipelinedmips32test/boot
add wave -noupdate -divider 0.CL
add wave -noupdate -expand -group {0.Hazard Ctrl} -label idRegisterRs /pipelinedmips32test/processor/hazard_contol_logic/idRegisterRs
add wave -noupdate -expand -group {0.Hazard Ctrl} -label idRegisterRt /pipelinedmips32test/processor/hazard_contol_logic/idRegisterRt
add wave -noupdate -expand -group {0.Hazard Ctrl} -label exeRegisterRt /pipelinedmips32test/processor/hazard_contol_logic/exeRegisterRt
add wave -noupdate -expand -group {0.Hazard Ctrl} -label idMemWrite /pipelinedmips32test/processor/hazard_contol_logic/idMemWrite
add wave -noupdate -expand -group {0.Hazard Ctrl} -label exeMemRead /pipelinedmips32test/processor/hazard_contol_logic/exeMemRead
add wave -noupdate -expand -group {0.Hazard Ctrl} -label Branch /pipelinedmips32test/processor/hazard_contol_logic/Branch
add wave -noupdate -expand -group {0.Hazard Ctrl} -label Jump /pipelinedmips32test/processor/hazard_contol_logic/Jump
add wave -noupdate -expand -group {0.Hazard Ctrl} -label {Stall (out)} /pipelinedmips32test/processor/hazard_contol_logic/Stall
add wave -noupdate -expand -group {0.Fordward Ctrl} -label idRegisterRs /pipelinedmips32test/processor/forwarding_control_logic/idRegisterRs
add wave -noupdate -expand -group {0.Fordward Ctrl} -label idRegisterRt /pipelinedmips32test/processor/forwarding_control_logic/idRegisterRt
add wave -noupdate -expand -group {0.Fordward Ctrl} -label exeRegisterRd /pipelinedmips32test/processor/forwarding_control_logic/exeRegisterRd
add wave -noupdate -expand -group {0.Fordward Ctrl} -label exeRegisterRt /pipelinedmips32test/processor/forwarding_control_logic/exeRegisterRt
add wave -noupdate -expand -group {0.Fordward Ctrl} -label memRegisterRd /pipelinedmips32test/processor/forwarding_control_logic/memRegisterRd
add wave -noupdate -expand -group {0.Fordward Ctrl} -label exeRegWrite /pipelinedmips32test/processor/forwarding_control_logic/exeRegWrite
add wave -noupdate -expand -group {0.Fordward Ctrl} -label memRegWrite /pipelinedmips32test/processor/forwarding_control_logic/memRegWrite
add wave -noupdate -expand -group {0.Fordward Ctrl} -label idMemWrite /pipelinedmips32test/processor/forwarding_control_logic/idMemWrite
add wave -noupdate -expand -group {0.Fordward Ctrl} -label exeMemWrite /pipelinedmips32test/processor/forwarding_control_logic/exeMemWrite
add wave -noupdate -expand -group {0.Fordward Ctrl} -label {fwd_aluRs (out)} /pipelinedmips32test/processor/forwarding_control_logic/fwd_aluRs
add wave -noupdate -expand -group {0.Fordward Ctrl} -label {fwd_aluRt (out)} /pipelinedmips32test/processor/forwarding_control_logic/fwd_aluRt
add wave -noupdate -expand -group {0.Fordward Ctrl} -label {fwd_alu_regmem (out)} /pipelinedmips32test/processor/forwarding_control_logic/fwd_alu_regmem
add wave -noupdate -expand -group {0.Fordward Ctrl} -label {fwd_mem_regmem (out)} /pipelinedmips32test/processor/forwarding_control_logic/fwd_mem_regmem
add wave -noupdate -divider 1.IF
add wave -noupdate -label Jump /pipelinedmips32test/processor/first_stage/Jump
add wave -noupdate -label boot /pipelinedmips32test/processor/first_stage/boot
add wave -noupdate -label {Jump_tmp (0 when boot)} /pipelinedmips32test/processor/first_stage/Jump_tmp
add wave -noupdate -group MuxPcUpOrBranch -label {addr_branch (1 Mux0)} -radix hexadecimal /pipelinedmips32test/processor/first_stage/addr_branch
add wave -noupdate -group MuxPcUpOrBranch -label {Pc_Up (0 Mux0)} -radix hexadecimal /pipelinedmips32test/processor/first_stage/pc_up_tmp2
add wave -noupdate -group MuxPcUpOrBranch -label {PCSrc (Control Mux0)} /pipelinedmips32test/processor/first_stage/PCSrc
add wave -noupdate -group MuxJumpOrElse -label {addr_jump (1 Mux1)} -radix hexadecimal /pipelinedmips32test/processor/first_stage/addr_jump
add wave -noupdate -group MuxJumpOrElse -label {Mux0_out (0 Mux1)} -radix hexadecimal /pipelinedmips32test/processor/first_stage/first_mux_res
add wave -noupdate -group MuxJumpOrElse -label {Jump_tmp (Control Mux1)} /pipelinedmips32test/processor/first_stage/Jump_tmp
add wave -noupdate -label {Mux0_out (Entrada PC_reg)} -radix hexadecimal -childformat {{/pipelinedmips32test/processor/first_stage/pc_up_tmp(31) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(30) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(29) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(28) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(27) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(26) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(25) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(24) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(23) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(22) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(21) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(20) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(19) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(18) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(17) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(16) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(15) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(14) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(13) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(12) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(11) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(10) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(9) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(8) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(7) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(6) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(5) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(4) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(3) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(2) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(1) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_up_tmp(0) -radix hexadecimal}} -subitemconfig {/pipelinedmips32test/processor/first_stage/pc_up_tmp(31) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(30) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(29) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(28) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(27) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(26) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(25) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(24) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(23) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(22) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(21) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(20) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(19) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(18) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(17) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(16) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(15) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(14) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(13) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(12) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(11) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(10) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(9) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(8) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(7) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(6) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(5) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(4) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(3) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(2) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(1) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_up_tmp(0) {-height 17 -radix hexadecimal}} /pipelinedmips32test/processor/first_stage/pc_up_tmp
add wave -noupdate -group PC -label PC_input -radix hexadecimal /pipelinedmips32test/processor/first_stage/pc_up_tmp
add wave -noupdate -group PC -label PC_out -radix hexadecimal /pipelinedmips32test/processor/first_stage/pc_tmp
add wave -noupdate -group PC -label {enable (not Stall)} /pipelinedmips32test/processor/first_stage/Stall
add wave -noupdate -group PC -label clk /pipelinedmips32test/processor/first_stage/clk
add wave -noupdate -group PC -label boot /pipelinedmips32test/processor/first_stage/boot
add wave -noupdate -group Inst_mem -label pc -radix hexadecimal -childformat {{/pipelinedmips32test/processor/first_stage/pc_tmp(31) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(30) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(29) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(28) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(27) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(26) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(25) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(24) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(23) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(22) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(21) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(20) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(19) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(18) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(17) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(16) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(15) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(14) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(13) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(12) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(11) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(10) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(9) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(8) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(7) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(6) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(5) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(4) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(3) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(2) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(1) -radix hexadecimal} {/pipelinedmips32test/processor/first_stage/pc_tmp(0) -radix hexadecimal}} -subitemconfig {/pipelinedmips32test/processor/first_stage/pc_tmp(31) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(30) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(29) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(28) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(27) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(26) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(25) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(24) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(23) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(22) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(21) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(20) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(19) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(18) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(17) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(16) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(15) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(14) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(13) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(12) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(11) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(10) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(9) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(8) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(7) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(6) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(5) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(4) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(3) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(2) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(1) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/first_stage/pc_tmp(0) {-height 17 -radix hexadecimal}} /pipelinedmips32test/processor/first_stage/pc_tmp
add wave -noupdate -group Inst_mem -label instruction -radix hexadecimal /pipelinedmips32test/processor/first_stage/instruction
add wave -noupdate -group Inst_mem -label clk /pipelinedmips32test/processor/first_stage/clk
add wave -noupdate -group Inst_mem -label boot /pipelinedmips32test/processor/first_stage/boot
add wave -noupdate -label {pc_up (IF out to ID)} -radix hexadecimal /pipelinedmips32test/processor/first_stage/pc_up
add wave -noupdate -label {instruction (IF out to ID)} -radix hexadecimal /pipelinedmips32test/processor/first_stage/instruction
add wave -noupdate -divider -height 30 2.ID
add wave -noupdate -group IF_ID_register -label {instruction (IF_ID_reg input)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/instruction
add wave -noupdate -group IF_ID_register -label {instruction (IF_ID_reg output)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/instruction_reg
add wave -noupdate -group IF_ID_register -label {pc_up (IF_ID_reg input)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/pc_up_in
add wave -noupdate -group IF_ID_register -label {pc_up (IF_ID_reg output)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/pc_up_reg
add wave -noupdate -group IF_ID_register -label {enable (not Stall)} /pipelinedmips32test/processor/second_stage/enable
add wave -noupdate -group IF_ID_register -label clk /pipelinedmips32test/processor/second_stage/clk
add wave -noupdate -label addr_jump -radix hexadecimal -childformat {{/pipelinedmips32test/processor/second_stage/addr_jump(31) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(30) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(29) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(28) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(27) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(26) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(25) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(24) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(23) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(22) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(21) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(20) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(19) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(18) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(17) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(16) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(15) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(14) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(13) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(12) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(11) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(10) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(9) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(8) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(7) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(6) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(5) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(4) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(3) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(2) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(1) -radix hexadecimal} {/pipelinedmips32test/processor/second_stage/addr_jump(0) -radix hexadecimal}} -subitemconfig {/pipelinedmips32test/processor/second_stage/addr_jump(31) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(30) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(29) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(28) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(27) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(26) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(25) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(24) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(23) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(22) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(21) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(20) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(19) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(18) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(17) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(16) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(15) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(14) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(13) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(12) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(11) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(10) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(9) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(8) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(7) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(6) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(5) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(4) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(3) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(2) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(1) {-height 17 -radix hexadecimal} /pipelinedmips32test/processor/second_stage/addr_jump(0) {-height 17 -radix hexadecimal}} /pipelinedmips32test/processor/second_stage/addr_jump
add wave -noupdate -label pc_up_out -radix hexadecimal /pipelinedmips32test/processor/second_stage/pc_up_out
add wave -noupdate -label opcode /pipelinedmips32test/processor/second_stage/opcode
add wave -noupdate -label addr_rs /pipelinedmips32test/processor/second_stage/addr_rs
add wave -noupdate -label addr_rt /pipelinedmips32test/processor/second_stage/addr_rt
add wave -noupdate -label addr_rd /pipelinedmips32test/processor/second_stage/addr_rd
add wave -noupdate -expand -group Ctrl_Inst_decode -label opcode /pipelinedmips32test/processor/second_stage/control/opcode
add wave -noupdate -expand -group Ctrl_Inst_decode -label RegWrite /pipelinedmips32test/processor/second_stage/control/RegWrite
add wave -noupdate -expand -group Ctrl_Inst_decode -label Jump /pipelinedmips32test/processor/second_stage/control/Jump
add wave -noupdate -expand -group Ctrl_Inst_decode -label Branch /pipelinedmips32test/processor/second_stage/control/Branch
add wave -noupdate -expand -group Ctrl_Inst_decode -label MemRead /pipelinedmips32test/processor/second_stage/control/MemRead
add wave -noupdate -expand -group Ctrl_Inst_decode -label MemWrite /pipelinedmips32test/processor/second_stage/control/MemWrite
add wave -noupdate -expand -group Ctrl_Inst_decode -label ByteAddress /pipelinedmips32test/processor/second_stage/control/ByteAddress
add wave -noupdate -expand -group Ctrl_Inst_decode -label WordAddress /pipelinedmips32test/processor/second_stage/control/WordAddress
add wave -noupdate -expand -group Ctrl_Inst_decode -label MemtoReg /pipelinedmips32test/processor/second_stage/control/MemtoReg
add wave -noupdate -expand -group Ctrl_Inst_decode -label RegDst /pipelinedmips32test/processor/second_stage/control/RegDst
add wave -noupdate -expand -group Ctrl_Inst_decode -label ALUOp /pipelinedmips32test/processor/second_stage/control/ALUOp
add wave -noupdate -expand -group Ctrl_Inst_decode -label ALUSrc /pipelinedmips32test/processor/second_stage/control/ALUSrc
add wave -noupdate -expand -group {NOP Multiplexor} -label {Stall (if 1-> NOP R0 = R0 or R0)} /pipelinedmips32test/processor/second_stage/Stall
add wave -noupdate -expand -group {NOP Multiplexor} -label {RegWrite_out (0 if Stall)} /pipelinedmips32test/processor/second_stage/RegWrite_out
add wave -noupdate -expand -group {NOP Multiplexor} -label {MemRead (0 if Stall)} /pipelinedmips32test/processor/second_stage/MemRead
add wave -noupdate -expand -group {NOP Multiplexor} -label {MemWrite (0 if Stall)} /pipelinedmips32test/processor/second_stage/MemWrite
add wave -noupdate -expand -group {NOP Multiplexor} -label {MemtoReg (0 if Stall)} /pipelinedmips32test/processor/second_stage/MemtoReg
add wave -noupdate -expand -group {NOP Multiplexor} -label {RegDst (0 if Stall)} /pipelinedmips32test/processor/second_stage/RegDst
add wave -noupdate -expand -group {NOP Multiplexor} -label {ALUOp (010-or-if Stall)} /pipelinedmips32test/processor/second_stage/ALUOp
add wave -noupdate -group regfile -label addr_rs /pipelinedmips32test/processor/second_stage/register_file/addr_rs
add wave -noupdate -group regfile -label addr_rt /pipelinedmips32test/processor/second_stage/register_file/addr_rt
add wave -noupdate -group regfile -label addr_rd /pipelinedmips32test/processor/second_stage/register_file/addr_rd
add wave -noupdate -group regfile -label rs /pipelinedmips32test/processor/third_stage/rs
add wave -noupdate -group regfile -label rt /pipelinedmips32test/processor/third_stage/rt
add wave -noupdate -group regfile -label rd /pipelinedmips32test/processor/second_stage/register_file/rd
add wave -noupdate -group regfile -label RegWrite /pipelinedmips32test/processor/second_stage/register_file/RegWrite
add wave -noupdate -group regfile -label clk /pipelinedmips32test/processor/second_stage/register_file/clk
add wave -noupdate -divider {Forwarding Muxs}
add wave -noupdate -expand -group MuxRs -label {fwd_path_alu (11 MuxRs)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/fwd_path_alu
add wave -noupdate -expand -group MuxRs -label {fwd_path_mem (10 MuxRs)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/fwd_path_mem
add wave -noupdate -expand -group MuxRs -label {rs_regfile (00 MuxRs)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/rs_regfile
add wave -noupdate -expand -group MuxRs -label {fwd_aluRs (Control MuxRs)} /pipelinedmips32test/processor/second_stage/fwd_aluRs
add wave -noupdate -label {rs (Output MuxRs)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/rs
add wave -noupdate -expand -group MuxRt -label {fwd_path_alu (11 MuxRt)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/fwd_path_alu
add wave -noupdate -expand -group MuxRt -label {fwd_path_mem (10 MuxRt)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/fwd_path_mem
add wave -noupdate -expand -group MuxRt -label {rt_regfile (00 MuxRt)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/rt_regfile
add wave -noupdate -expand -group MuxRt -label {fwd_aluRt (Control MuxRt)} /pipelinedmips32test/processor/second_stage/fwd_aluRt
add wave -noupdate -label {rt (Output MuxRt)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/rt
add wave -noupdate -group MuxWriteDataID -label {fwd_path_alu (11 MuxWriteData)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/fwd_path_alu
add wave -noupdate -group MuxWriteDataID -label {fwd_path_mem (10 MuxWriteData)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/fwd_path_mem
add wave -noupdate -group MuxWriteDataID -label {rt_regfile (00 MuxWriteData)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/rt_regfile
add wave -noupdate -group MuxWriteDataID -label {fwd_alu_regmem (Control MuxWriteData)} /pipelinedmips32test/processor/second_stage/fwd_alu_regmem
add wave -noupdate -label {write_data (Output MuxWriteData)} -radix hexadecimal /pipelinedmips32test/processor/second_stage/write_data
add wave -noupdate -divider -height 30 3.EXE
add wave -noupdate -expand -group ID_EXE_register -label {pc_up (ID_EXE input)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/pc_up
add wave -noupdate -expand -group ID_EXE_register -label {pc_up (ID_EXE output)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/pc_up_reg
add wave -noupdate -expand -group ID_EXE_register -label {opcode (ID_EXE input)} /pipelinedmips32test/processor/third_stage/opcode
add wave -noupdate -expand -group ID_EXE_register -label {opcode (ID_EXE output)} /pipelinedmips32test/processor/third_stage/opcode_reg
add wave -noupdate -expand -group ID_EXE_register -label {rs (ID_EXE input)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/rs
add wave -noupdate -expand -group ID_EXE_register -label {rs (ID_EXE output)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/rs_reg
add wave -noupdate -expand -group ID_EXE_register -label {rt (ID_EXE input)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/rt
add wave -noupdate -expand -group ID_EXE_register -label {rt (ID_EXE output)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/rt_reg
add wave -noupdate -expand -group ID_EXE_register -label {sign_ext (ID_EXE input)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/sign_ext
add wave -noupdate -expand -group ID_EXE_register -label {sign_ext (ID_EXE output)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/sign_ext_reg
add wave -noupdate -expand -group ID_EXE_register -label {zero_ext (ID_EXE input)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/zero_ext
add wave -noupdate -expand -group ID_EXE_register -label {zero_ext (ID_EXE output)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/zero_ext_reg
add wave -noupdate -expand -group ID_EXE_register -label {addr_rt (ID_EXE input)} /pipelinedmips32test/processor/third_stage/addr_rt_in
add wave -noupdate -expand -group ID_EXE_register -label {addr_rt (ID_EXE output)} /pipelinedmips32test/processor/third_stage/addr_rt_reg
add wave -noupdate -expand -group ID_EXE_register -label {addr_rd (ID_EXE input)} /pipelinedmips32test/processor/third_stage/addr_rd
add wave -noupdate -expand -group ID_EXE_register -label {addr_rd (ID_EXE output)} /pipelinedmips32test/processor/third_stage/addr_rd_reg
add wave -noupdate -expand -group ID_EXE_register -label {addr_jump (ID_EXE input)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/addr_jump_in
add wave -noupdate -expand -group ID_EXE_register -label {addr_jump (ID_EXE output)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/addr_jump_reg
add wave -noupdate -expand -group ID_EXE_register -label {RegWrite (ID_EXE input)} /pipelinedmips32test/processor/third_stage/RegWrite_in
add wave -noupdate -expand -group ID_EXE_register -label {RegWrite (ID_EXE output)} /pipelinedmips32test/processor/third_stage/RegWrite_reg
add wave -noupdate -expand -group ID_EXE_register -label {Jump (ID_EXE input)} /pipelinedmips32test/processor/third_stage/Jump_in
add wave -noupdate -expand -group ID_EXE_register -label {Jump (ID_EXE output)} /pipelinedmips32test/processor/third_stage/Jump_reg
add wave -noupdate -expand -group ID_EXE_register -label {Branch (ID_EXE input)} /pipelinedmips32test/processor/third_stage/Branch_in
add wave -noupdate -expand -group ID_EXE_register -label {Branch (ID_EXE output)} /pipelinedmips32test/processor/third_stage/Branch_reg
add wave -noupdate -expand -group ID_EXE_register -label {MemRead (ID_EXE input)} /pipelinedmips32test/processor/third_stage/MemRead_in
add wave -noupdate -expand -group ID_EXE_register -label {MemRead (ID_EXE output)} /pipelinedmips32test/processor/third_stage/MemRead_reg
add wave -noupdate -expand -group ID_EXE_register -label {MemWrite (ID_EXE input)} /pipelinedmips32test/processor/third_stage/MemWrite_in
add wave -noupdate -expand -group ID_EXE_register -label {MemWrite (ID_EXE output)} /pipelinedmips32test/processor/third_stage/MemWrite_reg
add wave -noupdate -expand -group ID_EXE_register -label {ByteAddress (ID_EXE input)} /pipelinedmips32test/processor/third_stage/ByteAddress_in
add wave -noupdate -expand -group ID_EXE_register -label {ByteAddress (ID_EXE output)} /pipelinedmips32test/processor/third_stage/ByteAddress_reg
add wave -noupdate -expand -group ID_EXE_register -label {WordAddress (ID_EXE input)} /pipelinedmips32test/processor/third_stage/WordAddress_in
add wave -noupdate -expand -group ID_EXE_register -label {WordAddress (ID_EXE output)} /pipelinedmips32test/processor/third_stage/WordAddress_reg
add wave -noupdate -expand -group ID_EXE_register -label {MemtoReg (IF_EXE input)} /pipelinedmips32test/processor/third_stage/MemtoReg_in
add wave -noupdate -expand -group ID_EXE_register -label {MemtoReg (IF_EXE output)} /pipelinedmips32test/processor/third_stage/MemtoReg_reg
add wave -noupdate -expand -group ID_EXE_register -label {RegDst (IF_EXE input)} /pipelinedmips32test/processor/third_stage/RegDst
add wave -noupdate -expand -group ID_EXE_register -label {RegDst (IF_EXE output)} /pipelinedmips32test/processor/third_stage/RegDst_reg
add wave -noupdate -expand -group ID_EXE_register -label {ALUOp (ID_EXE input)} /pipelinedmips32test/processor/third_stage/ALUOp
add wave -noupdate -expand -group ID_EXE_register -label {ALUOp (ID_EXE output)} /pipelinedmips32test/processor/third_stage/ALUOp_reg
add wave -noupdate -expand -group ID_EXE_register -label {ALUSrc (ID_EXE input)} /pipelinedmips32test/processor/third_stage/ALUSrc
add wave -noupdate -expand -group ID_EXE_register -label {ALUSrc (ID_EXE output)} /pipelinedmips32test/processor/third_stage/ALUSrc_reg
add wave -noupdate -expand -group ID_EXE_register -label clk /pipelinedmips32test/processor/third_stage/clk
add wave -noupdate -expand -group alu_control -label opcode /pipelinedmips32test/processor/third_stage/control/opcode
add wave -noupdate -expand -group alu_control -label funct /pipelinedmips32test/processor/third_stage/control/funct
add wave -noupdate -expand -group alu_control -label {ALUOp (input)} /pipelinedmips32test/processor/third_stage/control/ALUOp_in
add wave -noupdate -expand -group alu_control -label {ALUOp (output)} /pipelinedmips32test/processor/third_stage/control/ALUOp_out
add wave -noupdate -expand -group alu_control -label {SignedSrc (output)} /pipelinedmips32test/processor/third_stage/control/SignedSrc
add wave -noupdate -expand -group alu_control -label {ShiftSrc (output)} /pipelinedmips32test/processor/third_stage/control/ShiftSrc
add wave -noupdate -group MuxSignedOrUnsigned -label {sign_ext (1 MuxSignedOrUnsigned)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/sign_ext_reg
add wave -noupdate -group MuxSignedOrUnsigned -label {zero_ext (0 MuxSignedOrUnsigned)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/zero_ext_reg
add wave -noupdate -group MuxSignedOrUnsigned -label {SignedSrc (Control MuxSignedOrUnsigned)} /pipelinedmips32test/processor/third_stage/SignedSrc
add wave -noupdate -label {immed (output MuxSignedOrUnsigned)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/sign_immed_mux
add wave -noupdate -group MuxImmOrReg -label {immed (1 MuxImmOrReg)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/sign_immed_mux
add wave -noupdate -group MuxImmOrReg -label {rt (0 MuxImmOrReg)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/rt_reg
add wave -noupdate -group MuxImmOrReg -label {ALUSrc (Control MuxImmOrReg)} /pipelinedmips32test/processor/third_stage/ALUSrc_reg
add wave -noupdate -label {ImmOrReg (Output MuxImmOrReg)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/alusrc_b_mux
add wave -noupdate -group MuxShiftOrElse -label {shamt (1 MuxShiftOrElse)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/shamt
add wave -noupdate -group MuxShiftOrElse -label {ImmOrReg (0 MuxShiftOrElse)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/alusrc_b_mux
add wave -noupdate -label {alusrc_b (output MuxShiftOrElse)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/shiftsrc_mux
add wave -noupdate -group {MuxIfShift (if shift a<-rt b<-shamt else a<-rs b<-rt)} -label {rt (1 MuxIfShift)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/rt_reg
add wave -noupdate -group {MuxIfShift (if shift a<-rt b<-shamt else a<-rs b<-rt)} -label {rs (0 MuxIfShift)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/rs_reg
add wave -noupdate -group {MuxIfShift (if shift a<-rt b<-shamt else a<-rs b<-rt)} -label {ShiftSrc (Control MuxIfShift)} /pipelinedmips32test/processor/third_stage/ShiftSrc
add wave -noupdate -label {alusrc_a (output MuxIfShift)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/alusrc_a_mux
add wave -noupdate -group ALU -label a -radix hexadecimal /pipelinedmips32test/processor/third_stage/integer_alu/a
add wave -noupdate -group ALU -label b -radix hexadecimal /pipelinedmips32test/processor/third_stage/integer_alu/b
add wave -noupdate -group ALU -label res -radix hexadecimal /pipelinedmips32test/processor/third_stage/integer_alu/res
add wave -noupdate -group ALU -label Zero /pipelinedmips32test/processor/third_stage/integer_alu/Zero
add wave -noupdate -group ALU -label Overflow /pipelinedmips32test/processor/third_stage/integer_alu/Overflow
add wave -noupdate -group ALU -label funct /pipelinedmips32test/processor/third_stage/integer_alu/funct
add wave -noupdate -group ALU -label ALUOp /pipelinedmips32test/processor/third_stage/integer_alu/ALUOp
add wave -noupdate -label {fwd_path_alu (producer)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/fwd_path_alu
add wave -noupdate -label {addr_branch (producer) pc_up+sign_ext[29]&"00"} -radix hexadecimal /pipelinedmips32test/processor/third_stage/addr_branch
add wave -noupdate -group MuxDestReg -label {addr_rd (1 MuxDestReg)} /pipelinedmips32test/processor/third_stage/addr_rd_reg
add wave -noupdate -group MuxDestReg -label {addr_rt (0 MuxDestReg)} /pipelinedmips32test/processor/third_stage/addr_rt_reg
add wave -noupdate -group MuxDestReg -label {RegDst_reg (Control MuxDestReg)} /pipelinedmips32test/processor/third_stage/RegDst_reg
add wave -noupdate -label {addr_regw (output MuxDestReg)} /pipelinedmips32test/processor/third_stage/addr_regw
add wave -noupdate -expand -group {MuxWriteData(mem2mem fordward Mux)} -label {fwd_path_mem (1 MuxWriteData)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/fwd_path_mem
add wave -noupdate -expand -group {MuxWriteData(mem2mem fordward Mux)} -label {write_data (0 MuxWriteData)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/write_data_in
add wave -noupdate -expand -group {MuxWriteData(mem2mem fordward Mux)} -label {fwd_mem_regmem (Control MuxWriteData)} /pipelinedmips32test/processor/third_stage/fwd_mem_regmem
add wave -noupdate -label {write_data (Output MuxWriteData)} -radix hexadecimal /pipelinedmips32test/processor/third_stage/write_data_out
add wave -noupdate -divider -height 30 4.MEM
add wave -noupdate -group EXE_MEM -label {addr_jump (in)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/addr_jump_in
add wave -noupdate -group EXE_MEM -label {addr_jump (out)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/addr_jump_reg
add wave -noupdate -group EXE_MEM -label {addr_branch (in)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/addr_branch_in
add wave -noupdate -group EXE_MEM -label {addr_branch (out)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/addr_branch_reg
add wave -noupdate -group EXE_MEM -label {addr (in)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/addr
add wave -noupdate -group EXE_MEM -label {addr (out)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/addr_reg
add wave -noupdate -group EXE_MEM -label {addr_regw (in)} /pipelinedmips32test/processor/fourth_stage/addr_regw_in
add wave -noupdate -group EXE_MEM -label {addr_regw (out)} /pipelinedmips32test/processor/fourth_stage/addr_regw_reg
add wave -noupdate -group EXE_MEM -label {RegWrite (in)} /pipelinedmips32test/processor/fourth_stage/RegWrite_in
add wave -noupdate -group EXE_MEM -label {RegWrite (out)} /pipelinedmips32test/processor/fourth_stage/RegWrite_reg
add wave -noupdate -group EXE_MEM -label {Jump (in)} /pipelinedmips32test/processor/fourth_stage/Jump_in
add wave -noupdate -group EXE_MEM -label {Jump (out)} /pipelinedmips32test/processor/fourth_stage/Jump_reg
add wave -noupdate -group EXE_MEM -label {Branch (in)} /pipelinedmips32test/processor/fourth_stage/Branch
add wave -noupdate -group EXE_MEM -label {Branch (out)} /pipelinedmips32test/processor/fourth_stage/Branch_reg
add wave -noupdate -group EXE_MEM -label {MemRead (in)} /pipelinedmips32test/processor/fourth_stage/MemRead
add wave -noupdate -group EXE_MEM -label {MemRead (out)} /pipelinedmips32test/processor/fourth_stage/MemRead_reg
add wave -noupdate -group EXE_MEM -label {MemWrite (in)} /pipelinedmips32test/processor/fourth_stage/MemWrite
add wave -noupdate -group EXE_MEM -label {MemWrite (out)} /pipelinedmips32test/processor/fourth_stage/MemWrite_reg
add wave -noupdate -group EXE_MEM -label {ByteAddress (in)} /pipelinedmips32test/processor/fourth_stage/ByteAddress
add wave -noupdate -group EXE_MEM -label {ByteAddress (out)} /pipelinedmips32test/processor/fourth_stage/ByteAddress_reg
add wave -noupdate -group EXE_MEM -label {WordAddress (in)} /pipelinedmips32test/processor/fourth_stage/WordAddress
add wave -noupdate -group EXE_MEM -label {WordAddress (out)} /pipelinedmips32test/processor/fourth_stage/WordAddress_reg
add wave -noupdate -group EXE_MEM -label {MemtoReg (in)} /pipelinedmips32test/processor/fourth_stage/MemtoReg
add wave -noupdate -group EXE_MEM -label {MemtoReg (out)} /pipelinedmips32test/processor/fourth_stage/MemtoReg_reg
add wave -noupdate -group EXE_MEM -label {Zero (in)} /pipelinedmips32test/processor/fourth_stage/Zero
add wave -noupdate -group EXE_MEM -label {Zero (out)} /pipelinedmips32test/processor/fourth_stage/Zero_reg
add wave -noupdate -group EXE_MEM -label clk /pipelinedmips32test/processor/fourth_stage/clk
add wave -noupdate -label Branch /pipelinedmips32test/processor/fourth_stage/Branch_reg
add wave -noupdate -label Zero /pipelinedmips32test/processor/fourth_stage/Zero_reg
add wave -noupdate -label {PCSrc (producer) Branch and Zero} /pipelinedmips32test/processor/fourth_stage/PCSrc
add wave -noupdate -expand -group data_mem -label addr /pipelinedmips32test/processor/fourth_stage/data_memory/addr
add wave -noupdate -expand -group data_mem -label {write_data (in)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/data_memory/write_data
add wave -noupdate -expand -group data_mem -label {read_data (out)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/data_memory/read_data
add wave -noupdate -expand -group data_mem -label clk /pipelinedmips32test/processor/fourth_stage/data_memory/clk
add wave -noupdate -expand -group data_mem -label MemRead /pipelinedmips32test/processor/fourth_stage/data_memory/MemRead
add wave -noupdate -expand -group data_mem -label MemWrite /pipelinedmips32test/processor/fourth_stage/data_memory/MemWrite
add wave -noupdate -expand -group data_mem -label ByteAddress /pipelinedmips32test/processor/fourth_stage/data_memory/ByteAddress
add wave -noupdate -expand -group data_mem -label WordAddress /pipelinedmips32test/processor/fourth_stage/data_memory/WordAddress
add wave -noupdate -expand -group MuxLoadOrOther -label {read_data_mem (1 MuxLoadOrOther)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/read_data_mem
add wave -noupdate -expand -group MuxLoadOrOther -label {bypass_mem (0 MuxLoadOrOther)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/bypass_mem
add wave -noupdate -expand -group MuxLoadOrOther -label {MemtoReg (Control MuxLoadOrOther)} /pipelinedmips32test/processor/fourth_stage/MemtoReg_reg
add wave -noupdate -label {load_or_bypass (output MuxLoadOrOther)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/load_or_bypass
add wave -noupdate -label {fwd_path_mem (producer)} -radix hexadecimal /pipelinedmips32test/processor/fourth_stage/fwd_path_mem
add wave -noupdate -divider -height 30 5.WB
add wave -noupdate -expand -group MEM_WB -label {write_data (in)} -radix hexadecimal /pipelinedmips32test/processor/fifth_stage/write_data_in
add wave -noupdate -expand -group MEM_WB -label {write_data (out)} -radix hexadecimal /pipelinedmips32test/processor/fifth_stage/write_data_reg
add wave -noupdate -expand -group MEM_WB -label {addr_regw (in)} /pipelinedmips32test/processor/fifth_stage/addr_regw_in
add wave -noupdate -expand -group MEM_WB -label {addr_regw (out)} /pipelinedmips32test/processor/fifth_stage/addr_regw_reg
add wave -noupdate -expand -group MEM_WB -label {RegWrite (in)} /pipelinedmips32test/processor/fifth_stage/RegWrite_in
add wave -noupdate -expand -group MEM_WB -label {RegWrite (out)} /pipelinedmips32test/processor/fifth_stage/RegWrite_reg
add wave -noupdate -expand -group MEM_WB -label {MemtoReg (out)} /pipelinedmips32test/processor/fifth_stage/MemtoReg_reg
add wave -noupdate -expand -group MEM_WB -label clk /pipelinedmips32test/processor/fifth_stage/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {897 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 486
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {57 ps} {1050 ps}
bookmark add wave bookmark0 {{0 ps} {866 ps}} 6
