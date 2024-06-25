from scapy.all import *

target_ip = "192.168.1.1"  
target_port = 80  

xmas_pkt = IP(dst=target_ip) / TCP(dport=target_port, flags="FPU")
send(xmas_pkt)

print(f"Xmas Tree packet sent to {target_ip}:{target_port}")

