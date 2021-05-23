import bluetooth
server_sock = bluetooth.BluetoothSocket(bluetooth.L2CAP)
psm = 0x000f
server_sock.bind("", psm)
server_sock.listen(1)
connect_sock, addr = server_sock.accept()
print "Accepted connection from", addr
data = connect_sock.recv(1024)
print "received [%s]" % data
connect_sock.close()
server_sock.close()
