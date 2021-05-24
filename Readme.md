This is a ProFactory BT-L2CAP-classic use case for code-generation testing purpose.
Note that Because the current version of ProFactory cannot fully cover BT hardware features, we opt to hardcode the inner-most parsers and active message sending functions in l2cap_core.c.
Please follow the steps to have a running BT-L2CAP-classic protocol customized by us: 
1. Prepare two BT-available machines running on Linux, and change your current running Linux kernel version to v4.11 (both). Make sure CPUs are in little-endian (almost all the CPUs shipped now are in little endian).
2. Go to L2CAP directory and run "runhaskell -i<YourFullPathToProFactoryDirectory>/DSL/ProFactoryTypes.hs l2cap.hs" to generate customized kernel file snippets, and your l2cap_core.c and l2cap.h should be updated.
3. Check out linux kernel v4.11 from git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git, replace l2cap_core.c and l2cap.h under net/bluetooth and include/net/bluetooth. 
4. Switch to the kernel root directory and run "make modules SUBDIRS=net/bluetooth". Then, load all the generated customized modules in both machines. Note that if you are asked to configure the kernel, please make sure you select to add bluetooth support, otherwise there would be no make target for any bluetooth modules.
5. Run l2cap_server.py to create a l2cap server on one machine, then run l2cap_client.py with the server machine's HCI address ("python l2cap_client.py <hci_address>") to create a l2cap client on the other machine. You should see the server received and printed a string "Hello world!" delivered by the client.

TODO:
1. Add the full virtualization of hardware features (especially for BT) in the next version.
