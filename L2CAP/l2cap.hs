-- A highly simplified classic L2CAP written in ProFactory DSL
-- Fei Wang, Nov 2020

import ProFactoryTypes

--Define L2CAP message header
chanID = Fix "cid" 2 1 65535
l2Len = Fix "l2Len" 2 1 0
l2Hdr = Hdr "l2Hdr" [chanID] l2Len

--Define L2CAP generic payload
payload = Var "l2Payload" 1 1400

--Define L2CAP command header
l2CmdType = Fix "l2CmdType" 1 1 25
l2CmdLen = Fix "l2CmdLen" 2 1 0
l2CmdHdr = Hdr "l2CmdHdr" [l2CmdType] l2CmdLen

--Define L2CAP connection request command
srcChanID = Fix "scid" 2 10 65535
psm = Fix "psm" 1 1 100
connReq = FixSeq "l2ConnReq" [srcChanID, psm]

--Define L2CAP connection response command
dstChanID = Fix "dcid" 2 10 65535
connResult = Fix "l2ConnResult" 1 0 1
connRsp = FixSeq "l2ConnRsp" [connResult, srcChanID, dstChanID]

--Define L2CAP configuration request command
confReqLen = Fix "l2ConfReqLen" 2 1 600
confReqHdr = Hdr "l2ConfReqHdr" [srcChanID] confReqLen
mtu = Fix "mtu" 2 128 1024
paraReqMTU = Para "l2ParaReqMtu" 0 mtu
confReqList = Plist "l2ConfReqList" [paraReqMTU]

--Define L2CAP configuration response command
confResult = Fix "l2ConfResult" 1 0 1
confRsp = FixSeq "l2ConfRsp" [confResult, dstChanID]

--Define L2CAP shutdown request command
closeReq = FixSeq "l2CloseReq" [srcChanID, dstChanID]

--Define L2CAP shutdown response command
closeRsp = FixSeq "l2CloseRsp" [srcChanID, dstChanID]

--Define L2CAP channel data structure
paraMTU = Para "imtu" 0 mtu
paraMTU = Para "omtu" 1 mtu
paraPSM = Para "psm" 2 psm
paraSrcChanID = Para "scid" 3 srcChanID
paraDstChanID = Para "dcid" 4 dstChanID
chan = Chan [paraMTU, paraPSM, paraSrcChanID, paraDstChanID, paraConfResult]

--Define L2CAP connection/channel data structure
conn = Conn []

--Define protocol state
btConnect= State "bt_connect" 0 20
btConnect2= State "bt_connect2" 1 20
btConnected = State "bt_connected" 2 20
btconfig = State "bt_config" 5 20

--Define tree-structured message formats
fmtL2Payload = MsgFmtVar "msgL2Payload" payload
fmtConnReq = MsgFmtFixSeq "msgConnReq" connReq
fmtConnRsp = MsgFmtFixSeq "msgConnRsp" connRsp
fmtConfReqList = MsgFmtPlist "msgConfReqList" confReqList
fmtConfReq = MsgFmtLayer "msgConfReq" confReqHdr [(FindChanByParaExpr paraDstChanID (BinaryExpr confReqHdr PfACC srcChanID), fmtConfReqList)]
fmtConfRsp = MsgFmtFixSeq "msgConfRsp" confRsp
fmtCloseReq = MsgFmtFixSeq "msgCloseReq" closeReq
fmtCloseRsp = MsgFmtFixSeq "msgCloseRsp" closeRsp
fmtL2Cmd = MsgFmtLayer "msgL2Cmd" cmdHdr [(BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 1, fmtConnReq), (BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 2, fmtConnRsp), (BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 3, fmtConfReq), (BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 4, fmtConfRsp), (BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 5, closeReq), (BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 6, closeRsp)]
fmtL2 = MsgFmtLayer "msgL2" l2Hdr [(BinaryExpr (BinaryExpr l2Hdr PfACC chanID) PfEQ 1, fmtL2Cmd), (BinaryExpr (BinaryExpr l2Hdr PfACC chanID) PfGE 10, fmtL2Payload)]

--Define message symbols
msgConnReq = MsgSymbol fmtL2 [0, 0]
msgConnRsp = MsgSymbol fmtL2 [0, 1]
msgConfReq = MsgSymbol fmtL2 [0, 2, 0]
msgConfRsp = MsgSymbol fmtL2 [0, 3, 0]
msgCloseReq = MsgSymbol fmtL2 [0, 4]
msgCloseRsp = MsgSymbol fmtL2 [0, 5]
msgPayload = MsgSymbol fmtL2 [1]

--Please do not use the following definitions for code generation as our statments and expressions cannot completely cover the hardware features in current version. We would continue to improve it later to fully virtualize hardware features. The corresponding routines and functions are hardcoded with hardware features in l2cap_core.c for testing purposes.
--Define parsers
--recvMsgConnReqRoutine = Routine 
-- statements have been changed and they would be updated later
--recvMsgConnRspRoutine = Routine 
-- statements have been changed and they would be updated later
--recvMsgConfReqRoutine = Routine 
-- statements have been changed and they would be updated later
--recvMsgConfRspRoutine = Routine 
-- statements have been changed and they would be updated later
--recvMsgCloseReqRoutine = Routine 
-- statements have been changed and they would be updated later
--recvMsgCloseRspRoutine = Routine 
-- statements have been changed and they would be updated later
--recvMsgPayloadRoutine = Routine 
-- statements have been changed and they would be updated later
--recvMsgConnReq = Recv 
--recvMsgConfReq = Recv 
--recvMsgCloseReq = Recv 
--recvMsgConnRsp = Recv 
--recvMsgConfRsp = Recv 
--recvMsgCloseRsp = Recv 
--recvMsgPayload = Recv

--Define send activity
--sendMsgConnReqRoutine = Routine 
-- statements have been changed and they would be updated later
--sendMsgCloseReqRoutine = Routine 
-- statements have been changed and they would be updated later
--sendMsgPayloadRoutine = Routine 
-- statements have been changed and they would be updated later
--sendMsgConnReq = Send 
--sendMsgCloseReqRoutine = Send 
--sendMsgPayload = Send
