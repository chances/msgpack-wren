import "wren-assert/Assert" for Assert

import "./msgpack" for MsgPack

Assert.doesNotAbort {
  var data = ["MessagePack!", [1, 2], true]
  var serialized = MsgPack.pack(data)
  var deserialized = MsgPack.unpack(serialized)
}
