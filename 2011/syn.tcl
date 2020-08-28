source synopsys_dc.setup
read_file lcd_ctrl.v
source lcd_ctrl.sdc
compile
write -format verilog -hierarchy -output lcd_ctrl_syn.v
write -format ddc -hierarchy -output lcd_ctrl_syn.ddc
write_sdf -version 2.1 lcd_ctrl_syn.sdf
