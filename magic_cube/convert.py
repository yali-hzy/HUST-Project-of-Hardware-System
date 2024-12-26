# Generate and convert riscv32i binary executable to logisim hex file (little endian)
# Usage: python convert.py <elf_file>
# Output: <elf_file>.bin and <elf_file>.hex


import sys
import os


def generate_bin_file(elf_file: str):
    bin_file = elf_file + ".bin"
    cmd = "rust-objcopy --binary-architecture=riscv32i --strip-all -O binary {} {}".format(
        elf_file, bin_file
    )
    print(cmd)
    if os.system(cmd) != 0:
        print("Failed to generate binary file from {}".format(elf_file))
        sys.exit(1)
    print("Generate binary file {} from {}".format(bin_file, elf_file))
    return bin_file


def convert_bin_to_hex(bin_file, hex_file):
    with open(bin_file, "rb") as f:
        count = 0
        bytes = f.read(4)
        with open(hex_file + "_rom.coe", "w") as g:
            g.write("MEMORY_INITIALIZATION_RADIX=16;\n")
            g.write("MEMORY_INITIALIZATION_VECTOR=\n")

            while bytes:
                # Little endian
                bytes = bytes[::-1]
                for byte in bytes:
                    g.write("{:02X}".format(byte))
                g.write(",\n")
                bytes = f.read(4)

                count += 4
                if count >= 0x40000:
                    break

        with open(hex_file + "_ram0.coe", "w") as ram0:
            ram0.write("MEMORY_INITIALIZATION_RADIX=16;\n")
            ram0.write("MEMORY_INITIALIZATION_VECTOR=\n")
            with open(hex_file + "_ram1.coe", "w") as ram1:
                ram1.write("MEMORY_INITIALIZATION_RADIX=16;\n")
                ram1.write("MEMORY_INITIALIZATION_VECTOR=\n")
                with open(hex_file + "_ram2.coe", "w") as ram2:
                    ram2.write("MEMORY_INITIALIZATION_RADIX=16;\n")
                    ram2.write("MEMORY_INITIALIZATION_VECTOR=\n")
                    with open(hex_file + "_ram3.coe", "w") as ram3:
                        ram3.write("MEMORY_INITIALIZATION_RADIX=16;\n")
                        ram3.write("MEMORY_INITIALIZATION_VECTOR=\n")

                        while bytes:
                            # for byte in bytes:
                            ram0.write("{:02X},\n".format(bytes[0]))
                            ram1.write("{:02X},\n".format(bytes[1]))
                            ram2.write("{:02X},\n".format(bytes[2]))
                            ram3.write("{:02X},\n".format(bytes[3]))
                            bytes = f.read(4)
                            if len(bytes) != 4:
                                break

        print("Convert {} bytes from {} to {}".format(count, bin_file, hex_file))


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python convert.py <elf_file>")
        sys.exit(1)
    elf_file = sys.argv[1]
    bin_file = generate_bin_file(elf_file)
    hex_file = elf_file.split("/")[-1]
    convert_bin_to_hex(bin_file, hex_file)
    print("Done")
