# Specify the input and output file paths
dimensions = ['10-10-10', '50-50-50', '100-100-100', '500-500-500', '1000-1000-1000']

for dim in dimensions:
    input_file_path = f"{dim}/a.txt"
    output_file_path = f"{dim}/a_vec.txt"

    # Open the input file in read mode and output file in write mode
    with open(input_file_path, "r") as input_file, open(output_file_path, "w") as output_file:
        # Read input file line by line and write to output file line by line
        
        output_file.write('vec![')
        for line in input_file:
            nums = line.split(' ')
            vec = 'vec![' + ', '.join(nums) + '],'
            output_file.write(vec)
        
        output_file.write(']')


    input_file_path = f"{dim}/b.txt"
    output_file_path = f"{dim}/b_vec.txt"

    # Open the input file in read mode and output file in write mode
    with open(input_file_path, "r") as input_file, open(output_file_path, "w") as output_file:
        # Read input file line by line and write to output file line by line
        
        output_file.write('vec![')
        for line in input_file:
            nums = line.split(' ')
            vec = 'vec![' + ', '.join(nums) + '],'
            output_file.write(vec)
        
        output_file.write(']')

print('Done!')