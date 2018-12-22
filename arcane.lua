arcane_protocol = Proto("Arcane",  "ArcaneSector Game Protocol")
packet_length = ProtoField.uint32("arcane.packet_length", "packetLength", base.DEC)
chunk_id = ProtoField.string("arcane.chunk_id", "chunkID", ftypes.STRING)
packet_id = ProtoField.uint64("arcane.packet_id", "packetID", base.HEX)

arcane_protocol.fields = { packet_length, chunk_id, packet_id }

function arcane_protocol.dissector(buffer, pinfo, tree)
  length = buffer:len()
  if length == 0 then return end
  
  pinfo.cols.protocol = arcane_protocol.name
  
  local subtree = tree:add(arcane_protocol, buffer(), "ArcaneSector Game Data")
  subtree:add_le(packet_length, buffer(0,4))
  subtree:add_le(chunk_id, buffer(4,4))
  subtree:add_le(packet_id, buffer(8,8))
end

local tcp_port = DissectorTable.get("tcp.port")
tcp_port:add(5001, arcane_protocol)
