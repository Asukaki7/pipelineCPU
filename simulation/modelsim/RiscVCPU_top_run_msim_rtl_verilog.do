transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/riscvcpu_top.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/mul_pc.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/pc.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/pcadder_if.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/instmem.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/if_id_register.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/ie.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/id.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/registerfile.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/id_ex_register.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/ex_alu.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/ex_m_register.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/memdata.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/m_wb_register.v}
vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/mul_memtoreg.v}

vlog -vlog01compat -work work +incdir+E:/coding/Fpga_project_digital/pipelineCPU {E:/coding/Fpga_project_digital/pipelineCPU/RiscVCPU_top_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  RiscVCPU_top_tb

add wave *
view structure
view signals
run -all
