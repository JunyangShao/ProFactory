-- A highly simplified classic L2CAP written in ProFactory DSL
-- Fei Wang, Nov 2020

import ProFactoryTypes

--Define L2CAP message header
chanID = Fix "cid" 2 1 65535
l2Len = Fix "l2Len" 2 1 0
l2Hdr = Hdr "l2Hdr" [chanID] l2Len

--Define L2CAP generic payload
payload = Var "payload" 1 1400

--Define L2CAP command header
cmdType = Fix "cmdType" 1 1 25
cmdLen = Fix "cmdLen" 2 1 0
cmdHdr = Hdr "cmdHdr" [cmdType] cmdLen

--Define L2CAP connection request command
srcChanID = Fix "srcID" 2 1 65535
psm = Fix "psm" 1 1 22
connReq = FixSeq "connReq" [srcChanID, psm]

--Define L2CAP connection response command
dstChanID = Fix "dstID" 2 1 65535
connResult = Fix "connResult" 1 0 1
connRsp = FixSeq "connRsp" [connResult, srcChanID, dstChanID]

--Define L2CAP configuration request command
confReqLen = Fix "confReqLen" 2 1 600
confReqHdr = Hdr "confReqHdr" [srcChanID] confReqLen
mtu = Fix "mtu" 2 128 1024
paraReqMTU = Para "paraReqMTU" 0 mtu
confReqList = Plist "confReqList" [paraReqMTU]

--Define L2CAP configuration response command
confResult = Fix "confResult" 1 0 1
confRspLen = Fix "confRspLen" 2 1 600
confRspHdr = Hdr "confRspHdr" [confResult, dstChanID] confRspLen
paraRspMTU = Para "paraRspMTU" 0 mtu
confRspList = Plist "confRspList" [paraRspMTU]

--Define L2CAP shutdown request command
closeReq = FixSeq "closeReq" [srcChanID]

--Define L2CAP shutdown response command
closeResult = Fix "closeResult" 1 0 1
closeRsp = FixSeq "closeRsp" [closeResult, dstChanID]

--Define L2CAP channel data structure
paraMTU = Para "mtu" 0 mtu
paraPSM = Para "psm" 1 psm
paraSrcChanID = Para "srcChanID" 2 srcChanID
paraDstChanID = Para "dstChanID" 3 dstChanID
paraConfResult = Para "confResult" 4 confResult
chan = Chan [paraMTU, paraPSM, paraSrcChanID, paraDstChanID, paraConfResult]

--Define L2CAP connection data structure
conn = Conn []

--Define protocol state
connStart = State "conn_start" 0 20
connSent = State "conn_req_sent" 1 20
confSent = State "conf_req_sent" 2 20
closeReqSent = State "close_req_sent" 3 20
connected = State "connected" 4 20
configured = State "configured" 5 20
connClose = State "conn_close" 6 20

--Define tree-structured message formats
fmtL2Payload = MsgFmtVar "msgL2Payload" payload
fmtConnReq = MsgFmtFixSeq "msgConnReq" connReq
fmtConnRsp = MsgFmtFixSeq "msgConnRsp" connRsp
fmtConfReqList = MsgFmtPlist "msgConfReqList" confReqList
fmtConfRspList = MsgFmtPlist "msgConfRspList" confRspList
fmtConfReq = MsgFmtLayer "msgConfReq" confReqHdr [(FindChanByParaExpr paraDstChanID (BinaryExpr confReqHdr PfACC srcChanID), fmtConfReqList)]
fmtConfRsp = MsgFmtLayer "msgConfRsp" confRspHdr [(BinaryExpr (PriorExpr FindChanByParaExpr paraDstChanID (BinaryExpr confRspHdr PfACC dstChanID)) PfAND (SetChanParaExpr paraConfResult (BinaryExpr confRspHdr PfACC confResult)), fmtConfRspList)]
fmtCloseReq = MsgFmtFixSeq "msgCloseReq" closeReq
fmtCloseRsp = MsgFmtFixSeq "msgCloseRsp" closeRsp
fmtL2Cmd = MsgFmtLayer "msgL2Cmd" cmdHdr [(BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 1, fmtConnReq), (BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 2, fmtConnRsp), (BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 3, fmtConfReq), (BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 4, fmtConfRsp), (BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 5, closeReq), (BinaryExpr (BinaryExpr cmdHdr PfACC cmdType) PfEQ 6, closeRsp)]
fmtL2 = MsgFmtLayer "msgL2" l2Hdr [(BinaryExpr (BinaryExpr l2Hdr PfACC chanID) PfEQ 1, fmtL2Cmd), (BinaryExpr (BinaryExpr l2Hdr PfACC chanID) PfGT 1, fmtL2Payload)]

--Define message symbols
msgConnReq = MsgSymbol fmtL2 [0, 0]
msgConnRsp = MsgSymbol fmtL2 [0, 1]
msgConfReq = MsgSymbol fmtL2 [0, 2, 0]
msgConfRsp = MsgSymbol fmtL2 [0, 3, 0]
msgCloseReq = MsgSymbol fmtL2 [0, 4]
msgCloseRsp = MsgSymbol fmtL2 [0, 5]
msgPayload = MsgSymbol fmtL2 [1]

--Define parsers
recvMsgConnReqRoutine = Routine xxx [connStart] connected xx -- statements have been changed and they would be updated later
recvMsgConnRspRoutine = Routine xxx [connSent] connected xx -- statements have been changed and they would be updated later
recvMsgConfReqRoutine = Routine xxx [connected] configured xx -- statements have been changed and they would be updated later
recvMsgConfRspRoutine = Routine xxx [confSent] configured xx -- statements have been changed and they would be updated later
recvMsgCloseReqRoutine = Routine xxx [configured] connClose xx -- statements have been changed and they would be updated later
recvMsgCloseRspRoutine = Routine xxx [closeReqSent] connClose xx -- statements have been changed and they would be updated later
recvMsgPayloadRoutine = Routine xxx [configured] configured xx -- statements have been changed and they would be updated later
recvMsgConnReq = Recv msgConnReq msgConnRsp [recvMsgConnReqRoutine]
recvMsgConfReq = Recv msgConfReq msgConfRsp [recvMsgConfReqRoutine]
recvMsgCloseReq = Recv msgCloseReq msgCloseRsp [recvMsgCloseReqRoutine]
recvMsgConnRsp = Recv msgConnRsp msgConfReq [recvMsgConnRspRoutine]
recvMsgConfRsp = Recv msgConfRsp MsgEmpty [recvMsgConfRspRoutine]
recvMsgCloseRsp = Recv msgCloseRsp MsgEmpty [recvMsgCloseRspRoutine]
recvMsgPayload = Recv msgPayload MsgEmpty [recvMsgPayloadRoutine]

--Define send activity
sendMsgConnReqRoutine = Routine xxx [connStart] connSent xx -- statements have been changed and they would be updated later
sendMsgCloseReqRoutine = Routine xxx [configured] closeReqSent xx -- statements have been changed and they would be updated later
sendMsgPayloadRoutine = Routine xxx [configured] configured xx -- statements have been changed and they would be updated later
sendMsgConnReq = Send msgConnReq [sendMsgConnReqRoutine]
sendMsgCloseReqRoutine = Send msgCloseReq [sendMsgCloseReqRoutine]
sendMsgPayload = Send msgPayload [sendMsgPayloadRoutine]