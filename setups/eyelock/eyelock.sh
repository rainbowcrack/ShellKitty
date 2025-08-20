#!/usr/bin/python3

import socket

# cloudflare port dictionary
ports = {
        "FTP":21,
        "SSH":22,
        "HTTP":80,
        "HTTPS":443,
        "TCP":445,
        "MySQL":3306,
        "SMTP":25,
        "BGP":179,
        "NTP":123,
        "DNS":53,
        "ISAKMP":500,
        "SMTP":587,
        "RDP":3389
}

print("--------------- Eyelock v 1.0 by Rainbowcrack ---------------")

host = input("Enter a website URL or IP address: ")

# loop through each item in dictionary and test for error
for service, port in ports.items():

        try:

# calls the customer variable by method .socket()
# inside the method calls the arguments .AF_INET e IP
# socket is TCP, so .SOCK_STREAM
                client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# set the seconds for connection, same -T in nmap
# tests the connection with the client. "0" means success and "11" is failed
                client.settimeout(1)
                code = client.connect_ex((host, port))

                if code == 0:
                        print(f"{service} | {port} : OPEN")
                else:
                        print(f"{service} | {port} : CLOSED")

        except socket.error as error:
                print(f"Error connecting {port} : {error}")

        finally:
                client.close()