onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CLK /cachedmips32test/clk
add wave -noupdate -label BOOT /cachedmips32test/boot
add wave -noupdate -divider 0.CL
add wave -noupdate -group {Hazard Control} -label {idRegisterRs [in]} /cachedmips32test/processor/hazard_contol_logic/idRegisterRs
add wave -noupdate -group {Hazard Control} -label {idRegisterRt [in]} /cachedmips32test/processor/hazard_contol_logic/idRegisterRt
add wave -noupdate -group {Hazard Control} -label {exeRegisterRt [in]} /cachedmips32test/processor/hazard_contol_logic/exeRegisterRt
add wave -noupdate -group {Hazard Control} -label {exeMemRead [in]} /cachedmips32test/processor/hazard_contol_logic/exeMemRead
add wave -noupdate -group {Hazard Control} -label {Branch [in]} /cachedmips32test/processor/hazard_contol_logic/Branch
add wave -noupdate -group {Hazard Control} -label {Jump [in]} /cachedmips32test/processor/hazard_contol_logic/Jump
add wave -noupdate -group {Hazard Control} -label {Exception [in]} /cachedmips32test/processor/hazard_contol_logic/Exception
add wave -noupdate -group {Hazard Control} -label {Interrupt [in]} /cachedmips32test/processor/hazard_contol_logic/Interrupt
add wave -noupdate -group {Hazard Control} -label {Interrupt_to_Exception_ctrl [out]} /cachedmips32test/processor/hazard_contol_logic/Interrupt_to_Exception_ctrl
add wave -noupdate -group {Hazard Control} -label {Inst Cache Ready [in]} /cachedmips32test/processor/hazard_contol_logic/IC_Ready
add wave -noupdate -group {Hazard Control} -label {Data Cache Ready [in]} /cachedmips32test/processor/hazard_contol_logic/DC_Ready
add wave -noupdate -group {Hazard Control} -label {Ready (ROB)} /cachedmips32test/processor/hazard_contol_logic/ROB_Ready
add wave -noupdate -group {Hazard Control} -label {Update (ROB)} /cachedmips32test/processor/hazard_contol_logic/ROB_Update
add wave -noupdate -group {Hazard Control} -label {Stall PC [out]} /cachedmips32test/processor/hazard_contol_logic/Stall_PC
add wave -noupdate -group {Hazard Control} -label {Stall IF_ID [out]} /cachedmips32test/processor/hazard_contol_logic/Stall_IF_ID
add wave -noupdate -group {Hazard Control} -label {Stall ID_EXE [out]} /cachedmips32test/processor/hazard_contol_logic/Stall_ID_EXE
add wave -noupdate -group {Hazard Control} -label {Stall EXE_LOOKUP [out]} /cachedmips32test/processor/hazard_contol_logic/Stall_EXE_LOOKUP
add wave -noupdate -group {Hazard Control} -label {NOP to ID [out]} /cachedmips32test/processor/hazard_contol_logic/NOP_to_ID
add wave -noupdate -group {Hazard Control} -label {NOP to EXE [out]} /cachedmips32test/processor/hazard_contol_logic/NOP_to_EXE
add wave -noupdate -group {Hazard Control} -label {NOP to L [out]} /cachedmips32test/processor/hazard_contol_logic/NOP_to_L
add wave -noupdate -group {Hazard Control} -label {NOP to C [out]} /cachedmips32test/processor/hazard_contol_logic/NOP_to_C
add wave -noupdate -group {Hazard Control} -label {NOP to WB [out]} /cachedmips32test/processor/hazard_contol_logic/NOP_to_WB
add wave -noupdate -group {Forward Control} -label {idRegisterRs [in]} /cachedmips32test/processor/forwarding_control_logic/idRegisterRs
add wave -noupdate -group {Forward Control} -label {idRegisterRt [in]} /cachedmips32test/processor/forwarding_control_logic/idRegisterRt
add wave -noupdate -group {Forward Control} -label {exeRegisterRd [in]} /cachedmips32test/processor/forwarding_control_logic/exeRegisterRd
add wave -noupdate -group {Forward Control} -label {exeRegisterRt [in]} /cachedmips32test/processor/forwarding_control_logic/exeRegisterRt
add wave -noupdate -group {Forward Control} -label {tagRegisterRd [in]} /cachedmips32test/processor/forwarding_control_logic/tagRegisterRd
add wave -noupdate -group {Forward Control} -label {dcaRegisterRd [in]} /cachedmips32test/processor/forwarding_control_logic/dcaRegisterRd
add wave -noupdate -group {Forward Control} -label {exeRegWrite [in]} /cachedmips32test/processor/forwarding_control_logic/exeRegWrite
add wave -noupdate -group {Forward Control} -label {tagRegWrite [in]} /cachedmips32test/processor/forwarding_control_logic/tagRegWrite
add wave -noupdate -group {Forward Control} -label {dcaRegWrite [in]} /cachedmips32test/processor/forwarding_control_logic/dcaRegWrite
add wave -noupdate -group {Forward Control} -label {idMemWrite [in]} /cachedmips32test/processor/forwarding_control_logic/idMemWrite
add wave -noupdate -group {Forward Control} -label {exeMemWrite [in]} /cachedmips32test/processor/forwarding_control_logic/exeMemWrite
add wave -noupdate -group {Forward Control} -label {fwd_aluRs [out]} /cachedmips32test/processor/forwarding_control_logic/fwd_aluRs
add wave -noupdate -group {Forward Control} -label {fwd_aluRt [out]} /cachedmips32test/processor/forwarding_control_logic/fwd_aluRt
add wave -noupdate -group {Forward Control} -label {fwd_alu_regmem [out]} /cachedmips32test/processor/forwarding_control_logic/fwd_alu_regmem
add wave -noupdate -group {Forward Control} -label {fwd_lookup_regmem [out]} /cachedmips32test/processor/forwarding_control_logic/fwd_lookup_regmem
add wave -noupdate -group {Forward Control} -label {fwd_cache_regmem [out]} /cachedmips32test/processor/forwarding_control_logic/fwd_cache_regmem
add wave -noupdate -group {Exception Control} -label {exception_if [in]} /cachedmips32test/processor/exception_control_logic/exception_if
add wave -noupdate -group {Exception Control} -label {exception_id [in]} /cachedmips32test/processor/exception_control_logic/exception_id
add wave -noupdate -group {Exception Control} -label {exception_exe [in]} /cachedmips32test/processor/exception_control_logic/exception_exe
add wave -noupdate -group {Exception Control} -label {exception_lookup [in]} /cachedmips32test/processor/exception_control_logic/exception_lookup
add wave -noupdate -group {Exception Control} -label {exception_cache [in]} /cachedmips32test/processor/exception_control_logic/exception_cache
add wave -noupdate -group {Exception Control} -label {exception_interrupt [in]} /cachedmips32test/processor/exception_control_logic/exception_interrupt
add wave -noupdate -group {Exception Control} -label {exception_flag [out]} /cachedmips32test/processor/exception_control_logic/exception_flag
add wave -noupdate -group {Exception Control} -label {exception_jump [out]} /cachedmips32test/processor/exception_control_logic/exception_jump
add wave -noupdate -group {Exception Control} -label {wbexc_writeEPC [out]} /cachedmips32test/processor/exception_control_logic/wbexc_writeEPC
add wave -noupdate -group {Exception Control} -label {wbexc_writeBadVAddr [out]} /cachedmips32test/processor/exception_control_logic/wbexc_writeBadVAddr
add wave -noupdate -group {Exception Control} -label {wbexc_writeCause [out]} /cachedmips32test/processor/exception_control_logic/wbexc_writeCause
add wave -noupdate -group {Interrupt Control} -label {interrupt [in]} /cachedmips32test/processor/interrupts_control_logic/interrupt
add wave -noupdate -group {Interrupt Control} -label {clear interrupts [in]} /cachedmips32test/processor/interrupts_control_logic/int_clear
add wave -noupdate -group {Interrupt Control} -label {interrupt flag [out]} /cachedmips32test/processor/interrupts_control_logic/int_flag
add wave -noupdate -group {Interrupt Control} -label clk /cachedmips32test/processor/interrupts_control_logic/clk
add wave -noupdate -group {Interrupt Control} -label boot /cachedmips32test/processor/interrupts_control_logic/boot
add wave -noupdate -group {ReOrder Buffer} -label {Except Flag} /cachedmips32test/processor/rob_control_logic/except_flag
add wave -noupdate -group {ReOrder Buffer} -label {Except Addr (in ROB)} /cachedmips32test/processor/rob_control_logic/except_addr
add wave -noupdate -group {ReOrder Buffer} -label {Value Flag} /cachedmips32test/processor/rob_control_logic/value_flag
add wave -noupdate -group {ReOrder Buffer} -label {Value Addr (in ROB)} /cachedmips32test/processor/rob_control_logic/value_addr
add wave -noupdate -group {ReOrder Buffer} -label {Value (from ALU)} /cachedmips32test/processor/rob_control_logic/value_alu
add wave -noupdate -group {ReOrder Buffer} -label {Value (mem address)} /cachedmips32test/processor/rob_control_logic/value_mem
add wave -noupdate -group {ReOrder Buffer} -label {Register rf write} /cachedmips32test/processor/rob_control_logic/rf_write
add wave -noupdate -group {ReOrder Buffer} -label {Register rf addr} /cachedmips32test/processor/rob_control_logic/rf_addr
add wave -noupdate -group {ReOrder Buffer} -label {Register rf value} /cachedmips32test/processor/rob_control_logic/rf_val
add wave -noupdate -group {ReOrder Buffer} -label {New Entry flag} /cachedmips32test/processor/rob_control_logic/newentry_flag
add wave -noupdate -group {ReOrder Buffer} -label {New Entry store} /cachedmips32test/processor/rob_control_logic/newentry_store
add wave -noupdate -group {ReOrder Buffer} -label Ready /cachedmips32test/processor/rob_control_logic/ready
add wave -noupdate -group {ReOrder Buffer} -label {(internal) HEAD} /cachedmips32test/processor/rob_control_logic/i_head
add wave -noupdate -group {ReOrder Buffer} -label {(internal) TAIL} /cachedmips32test/processor/rob_control_logic/i_tail
add wave -noupdate -group {ReOrder Buffer} -label DATA -radix hexadecimal 
add wave -noupdate -group {ReOrder Buffer} -label Tail /cachedmips32test/processor/rob_control_logic/tail
add wave -noupdate -divider 0.MEM
add wave -noupdate -label addr -radix hexadecimal /cachedmips32test/processor/DRAM/addr
add wave -noupdate -label write_data -radix hexadecimal /cachedmips32test/processor/DRAM/write_data
add wave -noupdate -label read_data -radix hexadecimal /cachedmips32test/processor/DRAM/read_data
add wave -noupdate -label Rd -radix hexadecimal /cachedmips32test/processor/DRAM/Rd
add wave -noupdate -label Wr -radix hexadecimal /cachedmips32test/processor/DRAM/Wr
add wave -noupdate -label Ready -radix hexadecimal /cachedmips32test/processor/DRAM/Ready
add wave -noupdate -label reset -radix hexadecimal /cachedmips32test/processor/DRAM/reset
add wave -noupdate -label memCurrState -radix hexadecimal /cachedmips32test/processor/DRAM/memCurrState
add wave -noupdate -label memNextState -radix hexadecimal /cachedmips32test/processor/DRAM/memNextState
add wave -noupdate -divider 1.IF
add wave -noupdate -label PC -radix hexadecimal /cachedmips32test/processor/first_stage/pc
add wave -noupdate -label PC+4 -radix hexadecimal /cachedmips32test/processor/first_stage/pc_up
add wave -noupdate -label instruction -radix hexadecimal /cachedmips32test/processor/first_stage/instruction
add wave -noupdate -group {IF_ID Register} -label {instruction [in]} /cachedmips32test/processor/second_stage/instruction
add wave -noupdate -group {IF_ID Register} -label {instruction_reg [out]} /cachedmips32test/processor/second_stage/instruction_reg
add wave -noupdate -group {IF_ID Register} -label {pc_up_in [in]} /cachedmips32test/processor/second_stage/pc_up_in
add wave -noupdate -group {IF_ID Register} -label {pc_up_reg [out]} /cachedmips32test/processor/second_stage/pc_up_reg
add wave -noupdate -group {IF_ID Register} -label enable /cachedmips32test/processor/second_stage/enable
add wave -noupdate -group {IF_ID Register} -label {exception_if_in [in]} /cachedmips32test/processor/second_stage/exception_if_in
add wave -noupdate -group {IF_ID Register} -label {exception_if_reg [out]} /cachedmips32test/processor/second_stage/exception_if_reg
add wave -noupdate -group {IF_ID Register} -label {Exc_BadVAddr_in [in]} /cachedmips32test/processor/second_stage/Exc_BadVAddr_in
add wave -noupdate -group {IF_ID Register} -label {Exc_BadVAddr_reg [out]} /cachedmips32test/processor/second_stage/Exc_BadVAddr_reg
add wave -noupdate -group {IF_ID Register} -label {Exc_Cause_in [in]} /cachedmips32test/processor/second_stage/Exc_Cause_in
add wave -noupdate -group {IF_ID Register} -label {Exc_Cause_reg [out]} /cachedmips32test/processor/second_stage/Exc_Cause_reg
add wave -noupdate -group {IF_ID Register} -label {Exc_EPC_in [in]} /cachedmips32test/processor/second_stage/Exc_EPC_in
add wave -noupdate -group {IF_ID Register} -label {Exc_EPC_reg [out]} /cachedmips32test/processor/second_stage/Exc_EPC_reg
add wave -noupdate -group {Program Counter Register} -label pc_up -radix hexadecimal /cachedmips32test/processor/first_stage/pc_up_tmp
add wave -noupdate -group {Program Counter Register} -label pc -radix hexadecimal /cachedmips32test/processor/first_stage/pc_tmp
add wave -noupdate -group {Program Counter Register} -label Stall /cachedmips32test/processor/first_stage/Stall
add wave -noupdate -group {IC - Controller} -label {PrRd [in]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/PrRd
add wave -noupdate -group {IC - Controller} -label {PrWr [in]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/PrWr
add wave -noupdate -group {IC - Controller} -label {Ready [out]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/Ready
add wave -noupdate -group {IC - Controller} -label {Hit [in]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/Hit
add wave -noupdate -group {IC - Controller} -label {WriteTags [out]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/WriteTags
add wave -noupdate -group {IC - Controller} -label {WriteState [out]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/WriteState
add wave -noupdate -group {IC - Controller} -label {WriteCache [out]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/WriteCache
add wave -noupdate -group {IC - Controller} -label {nextState [out]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/nextState
add wave -noupdate -group {IC - Controller} -label {muxDataR [out]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/muxDataR
add wave -noupdate -group {IC - Controller} -label {muxDataW [out]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/muxDataW
add wave -noupdate -group {IC - Controller} -label {BusRd [out]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/BusRd
add wave -noupdate -group {IC - Controller} -label {BusWr [out]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/BusWr
add wave -noupdate -group {IC - Controller} -label {BusReady [in]} /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/BusReady
add wave -noupdate -group {IC - Controller} -label procCurrState /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/procCurrState
add wave -noupdate -group {IC - Controller} -label procNextState /cachedmips32test/processor/first_stage/instruction_cache/CONTROLLER/procNextState
add wave -noupdate -group {IC - Fields - Tags} -label index -radix hexadecimal /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/index
add wave -noupdate -group {IC - Fields - Tags} -label tagWrite -radix hexadecimal /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/tagWrite
add wave -noupdate -group {IC - Fields - Tags} -label tagRead -radix hexadecimal /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/tagRead
add wave -noupdate -group {IC - Fields - Tags} -label WriteEnable -radix hexadecimal /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/WriteEnable
add wave -noupdate -group {IC - Fields - Tags} -label mem_tags -radix hexadecimal -childformat {{/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(31) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(30) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(29) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(28) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(27) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(26) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(25) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(24) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(23) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(22) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(21) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(20) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(19) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(18) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(17) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(16) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(15) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(14) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(13) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(12) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(11) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(10) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(9) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(8) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(7) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(6) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(5) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(4) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(3) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(2) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(1) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(0) -radix hexadecimal}} -subitemconfig {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(31) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(30) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(29) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(28) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(27) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(26) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(25) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(24) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(23) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(22) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(21) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(20) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(19) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(18) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(17) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(16) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(15) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(14) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(13) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(12) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(11) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(10) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(9) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(8) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(7) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(6) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(5) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(4) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(3) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(2) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(1) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags(0) {-height 17 -radix hexadecimal}} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/TAGS/mem_tags
add wave -noupdate -group {IC - Fields - State} -label {index [in]} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/STATE/index
add wave -noupdate -group {IC - Fields - State} -label {nextState [in]} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/STATE/nextState
add wave -noupdate -group {IC - Fields - State} -label {state [out]} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/STATE/state
add wave -noupdate -group {IC - Fields - State} -label {WriteEnable [in]} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/STATE/WriteEnable
add wave -noupdate -group {IC - Fields - State} -label mem_state /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/STATE/mem_state
add wave -noupdate -group {IC - Fields - Data} -label index /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/index
add wave -noupdate -group {IC - Fields - Data} -label block_offset /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/block_offset
add wave -noupdate -group {IC - Fields - Data} -label write_data -radix hexadecimal /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/write_data
add wave -noupdate -group {IC - Fields - Data} -label read_data -radix hexadecimal /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/read_data
add wave -noupdate -group {IC - Fields - Data} -label WriteEnable /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/WriteEnable
add wave -noupdate -group {IC - Fields - Data} -label mem_data -radix hexadecimal -childformat {{/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(31) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(30) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(29) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(28) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(27) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(26) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(25) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(24) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(23) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(22) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(21) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(20) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(19) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(18) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(17) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(16) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(15) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(14) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(13) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(12) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(11) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(10) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(9) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(8) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(7) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(6) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(5) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(4) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(3) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(2) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(1) -radix hexadecimal} {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(0) -radix hexadecimal}} -subitemconfig {/cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(31) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(30) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(29) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(28) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(27) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(26) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(25) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(24) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(23) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(22) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(21) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(20) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(19) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(18) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(17) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(16) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(15) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(14) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(13) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(12) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(11) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(10) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(9) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(8) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(7) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(6) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(5) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(4) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(3) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(2) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(1) {-height 17 -radix hexadecimal} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data(0) {-height 17 -radix hexadecimal}} /cachedmips32test/processor/first_stage/instruction_cache/FIELDS/DATA/mem_data
add wave -noupdate -divider 2.ID
add wave -noupdate -label addr_jump /cachedmips32test/processor/second_stage/addr_jump
add wave -noupdate -label PC+4 /cachedmips32test/processor/second_stage/pc_up_out
add wave -noupdate -label opcode /cachedmips32test/processor/second_stage/opcode
add wave -noupdate -label addr_rs /cachedmips32test/processor/second_stage/addr_rs
add wave -noupdate -label addr_rt /cachedmips32test/processor/second_stage/addr_rt
add wave -noupdate -label addr_rd /cachedmips32test/processor/second_stage/addr_rd
add wave -noupdate -group {Control Inst. Decode} -label opcode /cachedmips32test/processor/second_stage/control/opcode
add wave -noupdate -group {Control Inst. Decode} -label opcode_extra /cachedmips32test/processor/second_stage/control/opcode_extra
add wave -noupdate -group {Control Inst. Decode} -label RegWrite /cachedmips32test/processor/second_stage/control/RegWrite
add wave -noupdate -group {Control Inst. Decode} -label c0RegWrite /cachedmips32test/processor/second_stage/control/c0RegWrite
add wave -noupdate -group {Control Inst. Decode} -label c0RegRead /cachedmips32test/processor/second_stage/control/c0RegRead
add wave -noupdate -group {Control Inst. Decode} -label Jump /cachedmips32test/processor/second_stage/control/Jump
add wave -noupdate -group {Control Inst. Decode} -label Branch /cachedmips32test/processor/second_stage/control/Branch
add wave -noupdate -group {Control Inst. Decode} -label MemRead /cachedmips32test/processor/second_stage/control/MemRead
add wave -noupdate -group {Control Inst. Decode} -label MemWrite /cachedmips32test/processor/second_stage/control/MemWrite
add wave -noupdate -group {Control Inst. Decode} -label ByteAddress /cachedmips32test/processor/second_stage/control/ByteAddress
add wave -noupdate -group {Control Inst. Decode} -label WordAddress /cachedmips32test/processor/second_stage/control/WordAddress
add wave -noupdate -group {Control Inst. Decode} -label MemtoReg /cachedmips32test/processor/second_stage/control/MemtoReg
add wave -noupdate -group {Control Inst. Decode} -label RegDst /cachedmips32test/processor/second_stage/control/RegDst
add wave -noupdate -group {Control Inst. Decode} -label ALUOp /cachedmips32test/processor/second_stage/control/ALUOp
add wave -noupdate -group {Control Inst. Decode} -label ALUSrc /cachedmips32test/processor/second_stage/control/ALUSrc
add wave -noupdate -divider {Big NOP multiplexor}
add wave -noupdate -label NOP_to_EXE /cachedmips32test/processor/second_stage/NOP_to_EXE
add wave -noupdate -label exception_internal /cachedmips32test/processor/second_stage/exception_internal
add wave -noupdate -label RegWrite_out /cachedmips32test/processor/second_stage/RegWrite_out
add wave -noupdate -label MemRead /cachedmips32test/processor/second_stage/MemRead
add wave -noupdate -label MemWriteHazard /cachedmips32test/processor/second_stage/MemWriteHazard
add wave -noupdate -label MemWrite /cachedmips32test/processor/second_stage/MemWrite
add wave -noupdate -label MemtoReg /cachedmips32test/processor/second_stage/MemtoReg
add wave -noupdate -label RegDst /cachedmips32test/processor/second_stage/RegDst
add wave -noupdate -label ALUOp /cachedmips32test/processor/second_stage/ALUOp
add wave -noupdate -label Jump /cachedmips32test/processor/second_stage/Jump
add wave -noupdate -label Branch /cachedmips32test/processor/second_stage/Branch
add wave -noupdate -group {Register File} -label clk /cachedmips32test/processor/second_stage/register_file/clk
add wave -noupdate -group {Register File} -label {addr_rs [in]} /cachedmips32test/processor/second_stage/register_file/addr_rs
add wave -noupdate -group {Register File} -label {addr_rt [in]} /cachedmips32test/processor/second_stage/register_file/addr_rt
add wave -noupdate -group {Register File} -label {addr_rd [in]} /cachedmips32test/processor/second_stage/register_file/addr_rd
add wave -noupdate -group {Register File} -label {rs [out]} /cachedmips32test/processor/second_stage/register_file/rs
add wave -noupdate -group {Register File} -label {rt [out]} /cachedmips32test/processor/second_stage/register_file/rt
add wave -noupdate -group {Register File} -label {rd [in]} /cachedmips32test/processor/second_stage/register_file/rd
add wave -noupdate -group {Register File} -label {RegWrite [in]} /cachedmips32test/processor/second_stage/register_file/RegWrite
add wave -noupdate -label addr_rd_tmp /cachedmips32test/processor/second_stage/addr_rd_tmp
add wave -noupdate -label addr_c0_write_tmp /cachedmips32test/processor/second_stage/addr_c0_write_tmp
add wave -noupdate -label c0RegWrite_in_tmp /cachedmips32test/processor/second_stage/c0RegWrite_in_tmp
add wave -noupdate -group {Especial Register File} -label clk /cachedmips32test/processor/second_stage/coprocessor0_register_file/clk
add wave -noupdate -group {Especial Register File} -label {addr_read [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/addr_read
add wave -noupdate -group {Especial Register File} -label {reg_read [out]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/reg_read
add wave -noupdate -group {Especial Register File} -label {addr_write [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/addr_write
add wave -noupdate -group {Especial Register File} -label {reg_write [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/reg_write
add wave -noupdate -group {Especial Register File} -label {RegWrite [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/RegWrite
add wave -noupdate -group {Especial Register File} -label {BadVAddr_reg [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/BadVAddr_reg
add wave -noupdate -group {Especial Register File} -label {BadVAddr_w [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/BadVAddr_w
add wave -noupdate -group {Especial Register File} -label {Status_reg [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/Status_reg
add wave -noupdate -group {Especial Register File} -label {Status_w [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/Status_w
add wave -noupdate -group {Especial Register File} -label {Cause_reg [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/Cause_reg
add wave -noupdate -group {Especial Register File} -label {Cause_w [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/Cause_w
add wave -noupdate -group {Especial Register File} -label {EPC_reg [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/EPC_reg
add wave -noupdate -group {Especial Register File} -label {EPC_w [in]} /cachedmips32test/processor/second_stage/coprocessor0_register_file/EPC_w
add wave -noupdate -divider {Forwarding Muxs}
add wave -noupdate -group {Mux Rs} -label {fwd_path_alu [11]} /cachedmips32test/processor/second_stage/fwd_path_alu
add wave -noupdate -group {Mux Rs} -label {fwd_path_lookup [10]} /cachedmips32test/processor/second_stage/fwd_path_lookup
add wave -noupdate -group {Mux Rs} -label {fwd_path_cache [01]} /cachedmips32test/processor/second_stage/fwd_path_cache
add wave -noupdate -group {Mux Rs} -label {rs_regfile [00]} /cachedmips32test/processor/second_stage/rs_regfile
add wave -noupdate -group {Mux Rs} -label {fwd_aluRs [Control Mux]} /cachedmips32test/processor/second_stage/fwd_aluRs
add wave -noupdate -group {Mux Rs} -label {rs [out]} /cachedmips32test/processor/second_stage/rs
add wave -noupdate -group {Mux Rt} -label {fwd_path_alu [11]} /cachedmips32test/processor/second_stage/fwd_path_alu
add wave -noupdate -group {Mux Rt} -label {fwd_path_lookup [10]} /cachedmips32test/processor/second_stage/fwd_path_lookup
add wave -noupdate -group {Mux Rt} -label {fwd_path_cache [01]} /cachedmips32test/processor/second_stage/fwd_path_cache
add wave -noupdate -group {Mux Rt} -label {rt_regfile [00]} /cachedmips32test/processor/second_stage/rt_regfile
add wave -noupdate -group {Mux Rt} -label {fwd_aluRt [Control Mux]} /cachedmips32test/processor/second_stage/fwd_aluRt
add wave -noupdate -group {Mux Rt} -label {rt [out]} /cachedmips32test/processor/second_stage/rt
add wave -noupdate -group {Mux Write Data(dcache)} -label {fwd_path_alu [11]} /cachedmips32test/processor/second_stage/fwd_path_alu
add wave -noupdate -group {Mux Write Data(dcache)} -label {fwd_path_lookup [10]} /cachedmips32test/processor/second_stage/fwd_path_lookup
add wave -noupdate -group {Mux Write Data(dcache)} -label {fwd_path_cache [01]} /cachedmips32test/processor/second_stage/fwd_path_cache
add wave -noupdate -group {Mux Write Data(dcache)} -label {rt_regfile [00]} /cachedmips32test/processor/second_stage/rt_regfile
add wave -noupdate -group {Mux Write Data(dcache)} -label {fwd_alu_regmem [Control Mux]} /cachedmips32test/processor/second_stage/fwd_alu_regmem
add wave -noupdate -group {Mux Write Data(dcache)} -label {write_data [out]} /cachedmips32test/processor/second_stage/write_data
add wave -noupdate -label sign_ext /cachedmips32test/processor/second_stage/sign_ext
add wave -noupdate -label zero_ext /cachedmips32test/processor/second_stage/zero_ext
add wave -noupdate -divider -height 30 3-7.LONGPIPE
add wave -noupdate -divider -height 30 3.EXE
add wave -noupdate -label addr_jump_out /cachedmips32test/processor/third_stage/addr_jump_out
add wave -noupdate -label write_data_out /cachedmips32test/processor/third_stage/write_data_out
add wave -noupdate -label RegWrite_out /cachedmips32test/processor/third_stage/RegWrite_out
add wave -noupdate -label Jump_out /cachedmips32test/processor/third_stage/Jump_out
add wave -noupdate -label Branch_out /cachedmips32test/processor/third_stage/Branch_out
add wave -noupdate -label MemRead_out /cachedmips32test/processor/third_stage/MemRead_out
add wave -noupdate -label MemWrite_out /cachedmips32test/processor/third_stage/MemWrite_out
add wave -noupdate -label ByteAddress_out /cachedmips32test/processor/third_stage/ByteAddress_out
add wave -noupdate -label WordAddress_out /cachedmips32test/processor/third_stage/WordAddress_out
add wave -noupdate -label MemtoReg_out /cachedmips32test/processor/third_stage/MemtoReg_out
add wave -noupdate -expand -group ALU -label {a [in]} /cachedmips32test/processor/third_stage/integer_alu/a
add wave -noupdate -expand -group ALU -label {b [in]} /cachedmips32test/processor/third_stage/integer_alu/b
add wave -noupdate -expand -group ALU -label {res [out]} /cachedmips32test/processor/third_stage/integer_alu/res
add wave -noupdate -expand -group ALU -label {Zero [out]} /cachedmips32test/processor/third_stage/integer_alu/Zero
add wave -noupdate -expand -group ALU -label {Overflow [out]} /cachedmips32test/processor/third_stage/integer_alu/Overflow
add wave -noupdate -expand -group ALU -label {funct [in]} /cachedmips32test/processor/third_stage/integer_alu/funct
add wave -noupdate -expand -group ALU -label {ALUOp [in]} /cachedmips32test/processor/third_stage/integer_alu/ALUOp
add wave -noupdate -label fwd_path_alu /cachedmips32test/processor/third_stage/fwd_path_alu
add wave -noupdate -label alu_res /cachedmips32test/processor/third_stage/alu_res
add wave -noupdate -label addr_regw /cachedmips32test/processor/third_stage/addr_regw
add wave -noupdate -label sign_ext_sh2 /cachedmips32test/processor/third_stage/sign_ext_sh2
add wave -noupdate -label addr_branch /cachedmips32test/processor/third_stage/addr_branch
add wave -noupdate -divider -height 30 4.L
add wave -noupdate -label addr_branch_out /cachedmips32test/processor/fourth_stage/addr_branch_out
add wave -noupdate -label addr_out /cachedmips32test/processor/fourth_stage/addr_out
add wave -noupdate -label write_data_mem_out /cachedmips32test/processor/fourth_stage/write_data_mem_out
add wave -noupdate -label addr_regw_out /cachedmips32test/processor/fourth_stage/addr_regw_out
add wave -noupdate -label fwd_path_lookup /cachedmips32test/processor/fourth_stage/fwd_path_lookup
add wave -noupdate -group {Data Cache - Lookup} -label {addr [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/addr
add wave -noupdate -group {Data Cache - Lookup} -label {PrRd [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/PrRd
add wave -noupdate -group {Data Cache - Lookup} -label {PrWr [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/PrWr
add wave -noupdate -group {Data Cache - Lookup} -label {Ready [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/Ready
add wave -noupdate -group {Data Cache - Lookup} -label {WriteCache [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/WriteCache
add wave -noupdate -group {Data Cache - Lookup} -label {muxDataR [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/muxDataR
add wave -noupdate -group {Data Cache - Lookup} -label {muxDataW [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/muxDataW
add wave -noupdate -group {Data Cache - Lookup} -label {BusRd [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/BusRd
add wave -noupdate -group {Data Cache - Lookup} -label {BusWr [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/BusWr
add wave -noupdate -group {Data Cache - Lookup} -label {BusReady [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/BusReady
add wave -noupdate -group {Data Cache - Lookup} -label clk /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/clk
add wave -noupdate -group {Data Cache - Lookup} -label reset /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/reset
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {PrRd [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/PrRd
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {PrWr [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/PrWr
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {Ready [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/Ready
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {Hit [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/Hit
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {WriteTags [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/WriteTags
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {WriteState [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/WriteState
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {WriteCache [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/WriteCache
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {State [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/State
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {nextState [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/nextState
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {muxDataR [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/muxDataR
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {muxDataW [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/muxDataW
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {BusRd [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/BusRd
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {BusWr [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/BusWr
add wave -noupdate -group {Data Cache - Lookup - Controller} -label {BusReady [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/BusReady
add wave -noupdate -group {Data Cache - Lookup - Controller} -label clk /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/clk
add wave -noupdate -group {Data Cache - Lookup - Controller} -label reset /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/reset
add wave -noupdate -group {Data Cache - Lookup - Controller} -label procCurrState /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/procCurrState
add wave -noupdate -group {Data Cache - Lookup - Controller} -label procNextState /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/CONTROLLER/procNextState
add wave -noupdate -group {Data Cache - Lookup - Tags} -label {index [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/FIELDS/TAGS/index
add wave -noupdate -group {Data Cache - Lookup - Tags} -label {tagWrite [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/FIELDS/TAGS/tagWrite
add wave -noupdate -group {Data Cache - Lookup - Tags} -label {tagRead [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/FIELDS/TAGS/tagRead
add wave -noupdate -group {Data Cache - Lookup - Tags} -label {WriteEnable [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/FIELDS/TAGS/WriteEnable
add wave -noupdate -group {Data Cache - Lookup - Tags} -label mem_tags /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/FIELDS/TAGS/mem_tags
add wave -noupdate -group {Data Cache - Lookup - State} -label {index [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/FIELDS/STATES/index
add wave -noupdate -group {Data Cache - Lookup - State} -label {nextState [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/FIELDS/STATES/nextState
add wave -noupdate -group {Data Cache - Lookup - State} -label {state [out]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/FIELDS/STATES/state
add wave -noupdate -group {Data Cache - Lookup - State} -label {WriteEnable [in]} /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/FIELDS/STATES/WriteEnable
add wave -noupdate -group {Data Cache - Lookup - State} -label mem_state /cachedmips32test/processor/fourth_stage/TAGS_AND_STATE/FIELDS/STATES/mem_state
add wave -noupdate -label RegWrite_out /cachedmips32test/processor/fourth_stage/RegWrite_out
add wave -noupdate -label BranchTaken /cachedmips32test/processor/fourth_stage/BranchTaken
add wave -noupdate -label PCSrc /cachedmips32test/processor/fourth_stage/PCSrc
add wave -noupdate -label ByteAddress_out /cachedmips32test/processor/fourth_stage/ByteAddress_out
add wave -noupdate -label WordAddress_out /cachedmips32test/processor/fourth_stage/WordAddress_out
add wave -noupdate -label MemtoReg_out /cachedmips32test/processor/fourth_stage/MemtoReg_out
add wave -noupdate -label WriteCache /cachedmips32test/processor/fourth_stage/WriteCache
add wave -noupdate -divider -height 30 5.C
add wave -noupdate -label addr_regw_out /cachedmips32test/processor/fifth_stage/addr_regw_out
add wave -noupdate -label write_data_reg /cachedmips32test/processor/fifth_stage/write_data_reg
add wave -noupdate -label fwd_path_cache /cachedmips32test/processor/fifth_stage/fwd_path_cache
add wave -noupdate -label RegWrite_out /cachedmips32test/processor/fifth_stage/RegWrite_out
add wave -noupdate -group {Data Cache - Cache} -label {addr [in] } /cachedmips32test/processor/fifth_stage/DATA_CACHE/addr
add wave -noupdate -group {Data Cache - Cache} -label {busDataMem [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/busDataMem
add wave -noupdate -group {Data Cache - Cache} -label {write_data [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/write_data
add wave -noupdate -group {Data Cache - Cache} -label {read_data [out]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/read_data
add wave -noupdate -group {Data Cache - Cache} -label {ByteAddress [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/ByteAddress
add wave -noupdate -group {Data Cache - Cache} -label {WordAddress [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/WordAddress
add wave -noupdate -group {Data Cache - Cache} -label {muxDataR [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/muxDataR
add wave -noupdate -group {Data Cache - Cache} -label {muxDataW [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/muxDataW
add wave -noupdate -group {Data Cache - Cache} -label {WriteEnable [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/WriteEnable
add wave -noupdate -group {Data Cache - Cache} -label readCache /cachedmips32test/processor/fifth_stage/DATA_CACHE/readCache
add wave -noupdate -group {Data Cache - Cache} -label writeCache /cachedmips32test/processor/fifth_stage/DATA_CACHE/writeCache
add wave -noupdate -group {Data Cache - Cache - Data} -label {index [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/DATA/index
add wave -noupdate -group {Data Cache - Cache - Data} -label {block_offset [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/DATA/block_offset
add wave -noupdate -group {Data Cache - Cache - Data} -label {write_data [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/DATA/write_data
add wave -noupdate -group {Data Cache - Cache - Data} -label {read_data [out]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/DATA/read_data
add wave -noupdate -group {Data Cache - Cache - Data} -label {WriteEnable [in]} /cachedmips32test/processor/fifth_stage/DATA_CACHE/DATA/WriteEnable
add wave -noupdate -group {Data Cache - Cache - Data} -label mem_data /cachedmips32test/processor/fifth_stage/DATA_CACHE/DATA/mem_data
add wave -noupdate -divider -height 30 6.WB
add wave -noupdate -label addr_regw_out /cachedmips32test/processor/sixth_stage/addr_regw_out
add wave -noupdate -label RegWrite_out /cachedmips32test/processor/sixth_stage/RegWrite_out
add wave -noupdate -label write_data_out /cachedmips32test/processor/sixth_stage/write_data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {159 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 676
configure wave -valuecolwidth 152
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
WaveRestoreZoom {57 ps} {819 ps}
bookmark add wave bookmark0 {{0 ps} {866 ps}} 6
