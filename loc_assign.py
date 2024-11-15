n_carry4 = 63

with open('loc_assign.txt', 'w') as f:
    y = 16
    n = 0
    for i in range(4*n_carry4):

        if i == 0: 
            node_name = 'first' 
        else: 
            node_name = 'next'
            #text = 'set_location_assignment LCCOMB_X17_Y' + str(y) +'_N' + str(n) + ' -to "delay_line:delay_line_inst|carry4:\\\carry_delay_line:' + str(i) + ':' + node_name + '_carry4:delayblock|carry[' + str(j) + ']" \n'
        text = 'set_location_assignment LCCOMB_X17_Y' + str(y) +'_N' + str(n) + ' -to "delay_line:delay_line_inst|unlatched_signal[' + str(i) + ']" \n'
        f.write(text)
        if n == 30: 
            y -= 1
            n = 0
        else:
            n += 2


    y = 16
    n = 1
    for i in range(4*n_carry4):
        
        text_ = 'set_location_assignment FF_X17_Y' + str(y) +'_N' + str(n) + ' -to "delay_line:delay_line_inst|fdr:\\\latch_1:' + str(i) + ':ff1|q" \n'
        f.write(text_)
        
        if n == 31:
            y -= 1
            n = 1
        else:
            n += 2