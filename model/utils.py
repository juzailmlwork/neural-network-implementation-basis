import matplotlib.pyplot as plt
import numpy as np

def quantize_nbit(data, n_bit, use_scale=0, verbose=0):
    max_bit_val = (2**(n_bit-1))-1
    max_val     = np.max(np.abs(data))
    if use_scale > 0:
        scale = use_scale
    else :
        scale   = max_bit_val / max_val 
    if verbose:
        print('Quantizing to +/- {}, scaling by {}'.format(max_bit_val, scale))
        
    out_int = np.around(data * scale)
    out = out_int /  scale
    
    return out, out_int, scale

import IPython.display as dp
def print_nowrap(s):
    display(dp.HTML("<style>.nowrap{white-space:nowrap;}</style><span class='nowrap'>" +s+ "</span>"))
def create_data_to_verilog(n_bit, data, show_img=0, suffix=''):

    # Input data - Flatten into 1-d vector
    m_output = data.reshape(1, np.prod(data.shape)) 
    m_output = m_output[0]

    # check the output shape is 1D
    if m_output.shape[0] != m_output.size:
        print('Error: Model output is not 1D. Check the model and layer requested')
    
    # Show the image if requested
    if show_img:
        plt.subplot(111)
        dim=int(np.sqrt(m_output.size))
        plt.imshow(m_output.reshape(dim,dim), cmap='Greys')
        plt.show()
    
    # Quantize
    data_q, data_qi, scale = quantize_nbit(m_output, n_bit)
    
    # Print this arry to verilog
    s = "logic signed [{}:0] test_data{} [0:{}] = '{{ {} }};".format(n_bit-1, suffix, data_qi.size-1, ', '.join(str(int(e)) for e in data_qi))
    print_nowrap(s)
    
    return data_q, data_qi