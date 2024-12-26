def process_coe_files(input_files, output_file):
    """
    Processes four .coe files by removing the first two lines, interleaving their contents,
    and saving the result to a new .coe file with 8 values per line.

    Args:
        input_files (list of str): Paths to the four input .coe files.
        output_file (str): Path to the output .coe file.
    """
    # Read and process each file
    data = []
    for file in input_files:
        with open(file, 'r') as f:
            lines = f.readlines()
            # Remove the first two lines and strip whitespace
            data.append([line.strip().strip(',') for line in lines[2:] if line.strip()])

    # Interleave the data
    interleaved_data = []
    for rows in zip(*data):
        interleaved_data.extend(rows)

    # Write the output file
    with open(output_file, 'w') as f:
        # f.write("MEMORY_INITIALIZATION_RADIX=16;\n")
        # f.write("MEMORY_INITIALIZATION_VECTOR=\n")

        for i in range(0, len(interleaved_data), 4):
            # Join 8 values per line with commas and add a comma at the end
            f.write(''.join(interleaved_data[i:i+4]) + '\n')

    print(f"Processed data written to {output_file}")

# Example usage
input_files = ["C:/Users/13183/Documents/cc_exp/HUST-Project-of-Hardware-System/Interrupt-Pipeline/coe/bare_metal_ram0.coe", 
               "C:/Users/13183/Documents/cc_exp/HUST-Project-of-Hardware-System/Interrupt-Pipeline/coe/bare_metal_ram1.coe", 
               "C:/Users/13183/Documents/cc_exp/HUST-Project-of-Hardware-System/Interrupt-Pipeline/coe/bare_metal_ram2.coe", 
               "C:/Users/13183/Documents/cc_exp/HUST-Project-of-Hardware-System/Interrupt-Pipeline/coe/bare_metal_ram3.coe"]
output_file = "C:/Users/13183/Documents/cc_exp/HUST-Project-of-Hardware-System/Interrupt-Pipeline/coe/ram.hex"
process_coe_files(input_files, output_file)