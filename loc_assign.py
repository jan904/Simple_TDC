n_carry4 = 32 

with open('loc_assign.txt', 'w') as f:
    y = 2
    n = 0
    for i in range(n_carry4):

        if i == 0: 
            node_name = 'first' 
        else: 
            node_name = 'next'

        if i == n_carry4-1:
            range_ = 4
        else:
            range_ = 5

        for j in range(range_):
            text = 'set_location_assignment LCCOMB_X29_Y' + str(y) +'_N' + str(n) + ' -to "delay_line:delay_line_inst|carry4:\\\carry_delay_line:' + str(i) + ':' + node_name + '_carry4:delayblock|carry[' + str(j) + ']" \n'
            f.write(text)
            if n == 30: y += 1
            n = (n+2)%32

