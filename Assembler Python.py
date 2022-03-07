# def value, bits):
#     sign_bit = 1 << (bits - 1)
#     # print((value))
#     # print((bits))
#     # print(sign_bit)
#     # if value > 0:
        
#     return (value & (sign_bit - 1)) - (value & sign_bit)

if __name__ == "__main__":
    # opens file in read mode
    f = open('Assembler_File.txt', 'r')
    o = open('binary.txt', 'w')
    binary = ''
    # get line
    line = f.readlines()
    if(len(line) > 0):
        print("\n" + line[0] + "\n")
        words = line[0].split()
    
    # print("\n" + line[0] + "\n");
    # split line into words
    words = line[0].split()
    with open('Assembler_File.txt', 'r') as openfileobject:
        # get each line
        for line in openfileobject:
            # split each line into separate words
            binary = '' 
            words = line.split()
            # li load_ind imm rd
            if(words[0] == 'li'):
                binary = binary + '0'
                binary = binary + bin(int(words[1]))[2:].zfill(3);
                # print(binary)
                
                binary = binary + bin(int(words[2]))[2:].zfill(16);
                binary = binary + bin(int(words[3]))[2:].zfill(5);

            # 
            #
            #
            # R3 Instructions
            #
            #
            #
            if(words[0] == 'simals'):
                binary = binary + '10'
                binary = binary + '000'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
                binary = binary + bin(int(words[4]))[2:].zfill(5);
            # 
            if(words[0] == 'simahs'):
                binary = binary + '10'
                binary = binary + '001'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
                binary = binary + bin(int(words[4]))[2:].zfill(5);                           
            # 
            if(words[0] == 'simsls'):
                binary = binary + '10'
                binary = binary + '010'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
                binary = binary + bin(int(words[4]))[2:].zfill(5);
            # 
            if(words[0] == 'simshs'):
                binary = binary + '10'
                binary = binary + '011'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
                binary = binary + bin(int(words[4]))[2:].zfill(5);
            # 
            if(words[0] == 'slmals'):
                binary = binary + '10'
                binary = binary + '100'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
                binary = binary + bin(int(words[4]))[2:].zfill(5);
            #
            if(words[0] == 'slmahs'):
                binary = binary + '10'
                binary = binary + '101'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
                binary = binary + bin(int(words[4]))[2:].zfill(5);
            #
            if(words[0] == 'slmsls'):
                binary = binary + '10'
                binary = binary + '110'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
                binary = binary + bin(int(words[4]))[2:].zfill(5);
            #
            if(words[0] == 'slmshs'):
                binary = binary + '10'
                binary = binary + '111'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
                binary = binary + bin(int(words[4]))[2:].zfill(5);
            #
            #
            #
            # R4 Instructions
            #
            #
            #
            if(words[0] == 'NOP'):
                binary = binary + '11'
                binary = binary + '00000000'
                temp = ""
                binary = binary + temp.zfill(15)
                # binary = binary + bin(int(words[1]))[2:].zfill(5);
                # binary = binary + bin(int(words[2]))[2:].zfill(5);
                # binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'AH'):
                binary = binary + '11'
                binary = binary + '00000001'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'AHS'):
                binary = binary + '11'
                binary = binary + '00000010'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'BCW'):
                binary = binary + '11'
                binary = binary + '00000011'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'CGH'):
                binary = binary + '11'
                binary = binary + '00000100'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'CLZ'):
                binary = binary + '11'
                binary = binary + '00000101'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'MAX'):
                binary = binary + '11'
                binary = binary + '00000110'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'MIN'):
                binary = binary + '11'
                binary = binary + '00000111'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'MSGN'):
                binary = binary + '11'
                binary = binary + '00001000'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'POPCNTH'):
                binary = binary + '11'
                binary = binary + '00001001'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'ROT'):
                binary = binary + '11'
                binary = binary + '00001010'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'ROTW'):
                binary = binary + '11'
                binary = binary + '00001011'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'SHLHI'):
                binary = binary + '11'
                binary = binary + '00001100'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'SFH'):
                binary = binary + '11'
                binary = binary + '00001101'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'SFHS'):
                binary = binary + '11'
                binary = binary + '00001110'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #
            if(words[0] == 'XOR'):
                binary = binary + '11'
                binary = binary + '00001111'
                binary = binary + bin(int(words[1]))[2:].zfill(5);
                binary = binary + bin(int(words[2]))[2:].zfill(5);
                binary = binary + bin(int(words[3]))[2:].zfill(5);
            #

            print(binary)
            o.write(binary + '\n');