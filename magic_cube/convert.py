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
        with open(hex_file, "w") as g:
            count = 0
            while True:
                bytes = f.read(4)
                if not bytes:
                    break
                # Little endian
                bytes = bytes[::-1]
                for byte in bytes:
                    g.write("{:02X}".format(byte))
                count += 4
                g.write("\n")
            print("Convert {} bytes from {} to {}".format(count, bin_file, hex_file))


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python convert.py <elf_file>")
        sys.exit(1)
    elf_file = sys.argv[1]
    bin_file = generate_bin_file(elf_file)
    hex_file = elf_file.split("/")[-1] + ".hex"
    convert_bin_to_hex(bin_file, hex_file)
    print("Done")
