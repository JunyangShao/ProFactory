ProFactory L2CAP-classic use case
1. Because the current version of ProFactory cannot fully cover BT hardware features, we opt to hardcode the inner-most parsers and sending functions in l2cap_core.c. This file is highly coupled with our use case.
2. Please generate the hierarchical parsers from l2cap.hs and append them to the end of l2cap_core.c. Prototypes have been declared at the beginning.
3. Please generate the data structures and macros from l2cap.hs, and put them in l2cap_me.h
4. Put all the files l2cap_me.h, l2cap.h, l2cap_core.c and l2cap_sock.c into Linux kernel v4.11.0
5. Compile the kernel and get the kernel modules. Load those modules to have a runnable and simplied bluetooth.
6. You may expect some running errors or hanging if you use this version of Bluetooth for existing software, because we do not support all the features of Bluetooth in this customized version.


TODO:
1. Add the full virtualization of hardware features (especially for BT) in the next version 
