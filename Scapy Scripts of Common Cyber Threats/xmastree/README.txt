The Xmas Tree attack/scan violates the TCP protocol by sending packets that are not expected at the start of a connection. It does this by sending packets with the “FPU” (FIN, PSH, URG) control bits set, which gives the attack/scan its name, as these control bits set in the TCP header look like Christmas tree lights.
In a normal TCP connection, only some flags are set at set stages (e.g. SYN at initiation). In the Xmas Tree scan, multiple flags are set at the same time, which isn’t normal and can be used to look for responses from network devices, which can help to find the OS or specific Vulnerabilities.
“If a router/firewall is looking for specific control bits set before it allows packets in, it’ll find them in an Xmas Tree scan, because they’re all lit up with a value of 1” - [1].


This basic script sends an Xmas tree packet to 192.168.1.1 on port 80. The main thing for an Xmas tree attack is having the [FIN, PSH, URG] flags set on the packet.