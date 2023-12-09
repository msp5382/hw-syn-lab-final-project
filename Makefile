
CROSS=riscv64-unknown-elf-

current_dir := ${CURDIR}
TOP := top
SOURCES := ${current_dir}/picosoc_noflash.v \
           ${current_dir}/picorv32.v \
           ${current_dir}/simpleuart.v \
           ${current_dir}/progmem.v \
		   ${current_dir}/vga_controller.v \
		   ${current_dir}/render.v \
			${current_dir}/ascii_rom.v \

SDC := ${current_dir}/picosoc.sdc

SOURCES += ${current_dir}/basys3.v
PCF := ${current_dir}/basys3.pcf

include ${current_dir}/common.mk

firmware: main.elf
	$(CROSS)objcopy -O binary main.elf main.bin
	python progmem.py

main.elf: main.lds start.s main.c
	$(CROSS)gcc $(CFLAGS) -march=rv32im -mabi=ilp32 -Wl,--build-id=none,-Bstatic,-T,main.lds,-Map,main.map,--strip-debug -ffreestanding -nostdlib \
	-o main.elf start.s main.c

main.lds: sections.lds
	$(CROSS)cpp -P -o $@ $^