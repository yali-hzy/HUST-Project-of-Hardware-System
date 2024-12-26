def add_comma_to_lines(input_file, output_file):
    """
    Reads an input file, adds a comma at the end of each line, and writes to an output file.

    Args:
        input_file (str): Path to the input file.
        output_file (str): Path to the output file.
    """
    with open(input_file, 'r') as f:
        lines = f.readlines()

    with open(output_file, 'w') as f:
        f.write("MEMORY_INITIALIZATION_RADIX=16;\n")
        f.write("MEMORY_INITIALIZATION_VECTOR=\n")
        for line in lines:
            f.write(line.strip() + ',\n')

    print(f"Processed file written to {output_file}")

# Example usage
input_file = "C:/Users/13183/Documents/cc_exp/HUST-Project-of-Hardware-System/Interrupt-Pipeline/coe/rv32i.hex"
output_file = "C:/Users/13183/Documents/cc_exp/HUST-Project-of-Hardware-System/Interrupt-Pipeline/coe/rv32i.coe"
add_comma_to_lines(input_file, output_file)