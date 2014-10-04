onerror {resume}
quietly virtual signal -install /basicmips32test/processor/first_stage { /basicmips32test/processor/first_stage/instruction(31 downto 26)} inst_Op
quietly virtual signal -install /basicmips32test/processor/first_stage { /basicmips32test/processor/first_stage/instruction(25 downto 21)} inst_Rs
quietly virtual signal -install /basicmips32test/processor/first_stage { /basicmips32test/processor/first_stage/instruction(20 downto 16)} inst_Rt
quietly virtual signal -install /basicmips32test/processor/first_stage { /basicmips32test/processor/first_stage/instruction(15 downto 11)} inst_Rd
quietly virtual signal -install /basicmips32test/processor/first_stage { /basicmips32test/processor/first_stage/instruction(10 downto 6)} inst_Shamt
quietly virtual signal -install /basicmips32test/processor/first_stage { /basicmips32test/processor/first_stage/instruction(5 downto 0)} inst_Funct
quietly virtual signal -install /basicmips32test/processor/third_stage { /basicmips32test/processor/third_stage/sign_ext(5 downto 0)} alu_ctrl_sign_ext
quietly WaveActivateNextPane {} 0
add wave -noupdate /basicmips32test/clk
add wave -noupdate /basicmips32test/boot
add wave -noupdate -divider IF
add wave -noupdate -radix hexadecimal /basicmips32test/processor/first_stage/addr_jump
add wave -noupdate -radix hexadecimal /basicmips32test/processor/first_stage/pc_up_tmp2
add wave -noupdate /basicmips32test/processor/first_stage/PCSrc
add wave -noupdate -radix hexadecimal /basicmips32test/processor/first_stage/first_mux_res
add wave -noupdate -radix hexadecimal /basicmips32test/processor/first_stage/addr_jump
add wave -noupdate /basicmips32test/processor/first_stage/Jump
add wave -noupdate -radix hexadecimal /basicmips32test/processor/first_stage/pc_up_tmp
add wave -noupdate -radix hexadecimal /basicmips32test/processor/first_stage/pc_tmp
add wave -noupdate -radix hexadecimal /basicmips32test/processor/first_stage/instruction
add wave -noupdate -radix hexadecimal /basicmips32test/processor/first_stage/pc_up
add wave -noupdate -divider ID
add wave -noupdate -radix hexadecimal /basicmips32test/processor/first_stage/instruction
add wave -noupdate /basicmips32test/processor/first_stage/inst_Op
add wave -noupdate -radix decimal /basicmips32test/processor/first_stage/inst_Rs
add wave -noupdate -radix decimal /basicmips32test/processor/first_stage/inst_Rt
add wave -noupdate -radix decimal /basicmips32test/processor/first_stage/inst_Rd
add wave -noupdate /basicmips32test/processor/first_stage/inst_Shamt
add wave -noupdate /basicmips32test/processor/first_stage/inst_Funct
add wave -noupdate /basicmips32test/processor/second_stage/RegWrite_out
add wave -noupdate /basicmips32test/processor/second_stage/Jump
add wave -noupdate /basicmips32test/processor/second_stage/Branch
add wave -noupdate /basicmips32test/processor/second_stage/MemRead
add wave -noupdate /basicmips32test/processor/second_stage/MemWrite
add wave -noupdate /basicmips32test/processor/second_stage/MemtoReg
add wave -noupdate /basicmips32test/processor/second_stage/RegDst
add wave -noupdate /basicmips32test/processor/second_stage/ALUOp
add wave -noupdate /basicmips32test/processor/second_stage/ALUSrc
add wave -noupdate /basicmips32test/processor/second_stage/addr_regw
add wave -noupdate -radix hexadecimal -childformat {{/basicmips32test/processor/second_stage/rs(31) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(30) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(29) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(28) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(27) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(26) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(25) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(24) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(23) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(22) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(21) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(20) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(19) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(18) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(17) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(16) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(15) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(14) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(13) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(12) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(11) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(10) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(9) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(8) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(7) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(6) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(5) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(4) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(3) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(2) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(1) -radix hexadecimal} {/basicmips32test/processor/second_stage/rs(0) -radix hexadecimal}} -subitemconfig {/basicmips32test/processor/second_stage/rs(31) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(30) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(29) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(28) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(27) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(26) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(25) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(24) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(23) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(22) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(21) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(20) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(19) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(18) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(17) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(16) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(15) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(14) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(13) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(12) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(11) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(10) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(9) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(8) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(7) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(6) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(5) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(4) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(3) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(2) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(1) {-height 15 -radix hexadecimal} /basicmips32test/processor/second_stage/rs(0) {-height 15 -radix hexadecimal}} /basicmips32test/processor/second_stage/rs
add wave -noupdate -radix hexadecimal /basicmips32test/processor/second_stage/rt
add wave -noupdate -radix hexadecimal /basicmips32test/processor/second_stage/rd
add wave -noupdate /basicmips32test/processor/second_stage/RegWrite_in
add wave -noupdate -radix hexadecimal /basicmips32test/processor/second_stage/sign_ext
add wave -noupdate -divider EXE
add wave -noupdate -radix hexadecimal /basicmips32test/processor/third_stage/alu_ctrl_sign_ext
add wave -noupdate /basicmips32test/processor/third_stage/ALUOp
add wave -noupdate /basicmips32test/processor/third_stage/ALUOp_control
add wave -noupdate -radix hexadecimal /basicmips32test/processor/third_stage/rt
add wave -noupdate -radix hexadecimal /basicmips32test/processor/third_stage/sign_ext
add wave -noupdate /basicmips32test/processor/third_stage/ALUSrc
add wave -noupdate -radix hexadecimal /basicmips32test/processor/third_stage/rs
add wave -noupdate -radix hexadecimal /basicmips32test/processor/third_stage/alu_res
add wave -noupdate /basicmips32test/processor/third_stage/Zero
add wave -noupdate -divider MEM
add wave -noupdate -radix hexadecimal /basicmips32test/processor/fourth_stage/addr
add wave -noupdate -radix hexadecimal /basicmips32test/processor/fourth_stage/write_data
add wave -noupdate -radix hexadecimal /basicmips32test/processor/fourth_stage/read_data
add wave -noupdate /basicmips32test/processor/fourth_stage/MemRead
add wave -noupdate /basicmips32test/processor/fourth_stage/MemWrite
add wave -noupdate /basicmips32test/processor/fourth_stage/ByteAddress
add wave -noupdate /basicmips32test/processor/fourth_stage/WordAddress
add wave -noupdate /basicmips32test/processor/fourth_stage/Branch
add wave -noupdate /basicmips32test/processor/fourth_stage/Zero
add wave -noupdate /basicmips32test/processor/fourth_stage/PCSrc
add wave -noupdate -divider WB
add wave -noupdate -radix hexadecimal /basicmips32test/processor/fifth_stage/bypass_mem
add wave -noupdate -radix hexadecimal /basicmips32test/processor/fifth_stage/read_data
add wave -noupdate /basicmips32test/processor/fifth_stage/MemtoReg
add wave -noupdate -radix hexadecimal /basicmips32test/processor/fifth_stage/write_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1697 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 344
configure wave -valuecolwidth 211
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
WaveRestoreZoom {1327 ps} {2141 ps}
