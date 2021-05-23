import sys
import bluetooth
client_sock = bluetooth.BluetoothSocket(bluetooth.L2CAP)
bd_addr = sys.argv[1]
psm = 0x000f
client_sock.connect((bd_addr, psm))
client_sock.send("Hello world!")
client_sock.close()
