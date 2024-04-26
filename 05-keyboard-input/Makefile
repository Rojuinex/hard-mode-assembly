.PHONY: run debug clean

boot.img: boot.bin
	$(eval n := $(shell echo "$$((510-$$(wc -c < boot.bin | xargs)))"))
	cat boot.bin > boot.img.tmp
	dd if=/dev/zero bs=1 count=$n >> boot.img.tmp
	echo -n "55AA" | xxd -ps -r >> boot.img.tmp
	mv boot.img.tmp boot.img

boot.bin: boot.hex
	cat boot.hex | xxd -ps -r > boot.bin

boot.hex: boot.asm
	cat boot.asm |\
		sed -E 's/^[^;]+//' |\
		sed -E 's/;[^-]*//' |\
		sed -E 's/;.*//' |\
		sed -E 's/-- //' \
		> boot.hex

run:
	qemu-system-i386 -drive format=raw,file=boot.img --nographic

debug:
	qemu-system-i386 -drive format=raw,file=boot.img --nographic -s -S

clean:
	rm -f boot.img
	rm -f boot.img.tmp
	rm -f boot.bin
	rm -f boot.hex
