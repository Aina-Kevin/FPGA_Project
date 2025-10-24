VLOG      = vlog
VSIM      = vsim
LIB       = work
SV_SOURCE = source.f
TOP_LEVEL = CPU_6502_tb

.PHONY: compile guisim clean

compile: $(SV_SOURCE)
	@if [ ! -d $(LIB) ]; then vlib $(LIB); fi
	@echo "=== Compilation des sources ==="
	$(VLOG) +acc -f $(SV_SOURCE)

guisim: compile
	$(VSIM) -L $(LIB) $(TOP_LEVEL)

clean:
	rm -rf $(LIB) transcript vsim.wlf *.bak

