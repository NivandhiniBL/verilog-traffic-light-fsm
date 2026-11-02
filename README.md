# verilog-traffic-light-fsm
**Overview**

Moore FSM controlling a RED → GREEN → YELLOW sequence with configurable per-state timing, plus a self-checking testbench.

**Run:** iverilog -o sim traffic_light.v tb_traffic_light.v && vvp sim && gtkwave tb.vcd (or ModelSim/Quartus). Note: adjust the check timing if a check fails by one cycle; the aim is that the testbench output says PASS in your simulator.
