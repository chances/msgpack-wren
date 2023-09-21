import "wren-assert/Assert" for Assert

import "./msgpack" for MsgPack, Packer

// Section: `Packer`
// Section: `Packer`: Integers
Assert.doesNotAbort {
  Assert.equal(Packer.pack(0), 0)
  Assert.equal(Packer.pack(1), 0x1)
  Assert.equal(Packer.pack(45), 0x2D)
  Assert.equal(Packer.pack(127), 0x7F)
  Assert.equal(Packer.pack(-8), (0xE0 | 0x18))
  Assert.deepEqual(Packer.pack(128), [0xCC, 0x80])
  Assert.deepEqual(Packer.pack(255), [0xCC, 0xFF])
  Assert.deepEqual(Packer.pack(256), [0xCD, 0x100])
  Assert.deepEqual(Packer.pack(9000), [0xCD, 0x2328])
  Assert.deepEqual(Packer.pack(65799), [0xCE, 0x10107])
  Assert.deepEqual(Packer.pack(-176), [0xD0, 0x50])
  Assert.deepEqual(Packer.pack(-9000), [0xD1, 0xDCD8])
}

// Section: `Packer`: Floats: Integers
Assert.doesNotAbort {
  Assert.deepEqual(Packer.pack(128.0), [0xCC, 0x80])
  Assert.deepEqual(Packer.pack(255.0), [0xCC, 0xFF])
  Assert.deepEqual(Packer.pack(256.0), [0xCD, 0x100])
  Assert.deepEqual(Packer.pack(-176.0), [0xD0, 0x50])
  Assert.deepEqual(Packer.pack(-9000.0), [0xD1, 0xDCD8])
}

// Section: `Packer`: Floats: Decimals
Assert.doesNotAbort {
  Assert.equal(Packer.pack(Num.infinity), [0xCA, 0])
  Assert.equal(Packer.pack(-Num.infinity), [0xCA, 0])
  Assert.equal(Packer.pack(Num.nan), [0xCA, 128])
  Assert.equal(Packer.pack(-Num.nan), [0xCA, 128])
  // Assert.equal(Packer.pack(0.5), [0xCC, 128])
  // Assert.equal(Packer.pack(1.5), [0xCC, 128])
  // Assert.equal(Packer.pack(-4), [0xCC, 128])
  // Assert.equal(Packer.pack(255), [0xCA, 255])
  // Assert.equal(Packer.pack(256), [0xCB, 0x100])
  // Assert.equal(Packer.pack(9000), [0xCB, 0x2328])
  // Assert.equal(Packer.pack(65799), [0xCB, 0x10107])
  // Assert.equal(Packer.pack(-176), [0xCB, 0x50])
  // Assert.equal(Packer.pack(-9000), [0xCB, 0xDCD8])
}

// Section: General Usage
Assert.doesNotAbort {
  var data = ["MessagePack!", [1, 2], true]
  var serialized = MsgPack.pack(data)
  var deserialized = MsgPack.unpack(serialized)
}
