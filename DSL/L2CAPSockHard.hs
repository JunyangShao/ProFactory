-- Hardcoded necessary L2CAP-Classic interface names
-- Fei Wang, Nov 2020
-- This module defines all the necessary L2CAP-Classic hardcoded interfaces in ProFactory
-- These interfaces should be transparent to developers
-- Note that this is not a generic list for all the IoT protocols, but it should be adapted to fit other protocol stacks. This file has been customized to our basic L2CAP use case.
-- Howver, we believe that Bluetooth L2CAP is a sufficiently complex IoT delivery protocol and other protocols may only need a subset of this list
-- If a developer wants to customized these interfaces, they should also customize user-space files accordingly.

-- Why do we need such hardcoded interfaces? Does it harm the scalability of ProFactory?
-- A delivery protocol residing in the kernel is connected to lots of other components, such as protocol family operations, family-compatible socket interfaces, combined protocol initialization/destruction, and protocol communication between different layers. If we choose to emit customized versions for those parts, we need to do manual kernel-wide interface searching and replacement, which is a highly ad-hoc effort. This is obviously beyond the purpose of proposing ProFactory.
-- It does not harm the ProFactory scalability. ProFactory aims to build a generic framework to generate protocol-specific parsing and state transitions, however, those connecting shims that guarantee the kernel functioning are highly coupled with kernel design and structure, which are considered impossible to scale.

module L2CAPClassicInterfaceNames
where

-- Protocol name
protoName = "l2cap"

-- Protocol family socket buffer allocation
protoFamilySkbAllocName = "bt_skb_alloc"

-- Lower-layer delivery interface
lowDeliveryCallSite = "hci_send_acl(pconn->hchan, skb_out, ACL_START);\n"

-- Lower-layer connect interface
lowConnect
