from scapy.all import *

def handle_packet(packet):
    # Check if packet is ICMP: 8 = ICMP Echo request
    if ICMP in packet and packet[ICMP].type == 8:
        print(f"Received ICMP request from {packet[IP].src}")
        
        # Use TTL of 128, to make packets simulate windows host
        ip = IP(src=packet[IP].dst, dst=packet[IP].src, ttl=128)
        icmp = ICMP(type=0, id=packet[ICMP].id, seq=packet[ICMP].seq)
        data = packet[Raw].load
        
        reply_packet = ip / icmp / data
        send(reply_packet)
        print(f"Sent ICMP reply to {packet[IP].src} with TTL=128")


print("Monitoring ICMP requests...")
sniff(filter="icmp", prn=handle_packet)


