input = [2.5, 3, 1];
transfer = [5, 0.2, 0.71];

output = input .* transfer; 



output_equalised = output ./ transfer;