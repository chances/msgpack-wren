// MessagePack serializer and deserializer implementation.
//
// [MessagePack](https://msgpack.org) is a binary serialization specification.
// See: https://msgpack.org
class MsgPack {
  // Serializes given `data`.
  // Returns: String buffer of bytes containing the serialized data.
  static pack(data) {

  }
  // Deserializes given `buffer`.
  // Params: buffer: String buffer of bytes to deserialize.
  // Returns: List|Map containing deserialized data.
  // Throws: When malformed data is encountered or deserialization does not otherwise succeed.
  static unpack(buffer) {}
}

import "wren-magpie/magpie" for Magpie, Result

// See: https://github.com/msgpack/msgpack/blob/master/spec.md
class Grammar {
  // Section: Integers
  // See: https://github.com/msgpack/msgpack/blob/master/spec.md#int-format-family
  static fixInt {}
  static uint8 {}
  static uint16 {}
  static uint32 {}
  static uint64 {}
  static int8 {}
  static int16 {}
  static int32 {}
  static int64 {}
  // Section: Floating-Point Numbers
  // See: https://github.com/msgpack/msgpack/blob/master/spec.md#float-format-family
  static float32 {}
  static float64 {}
  // Section: Strings
  // See: https://github.com/msgpack/msgpack/blob/master/spec.md#str-format-family
  static fixStr {}
  static str8 {}
  static str16 {}
  static str32 {}
  // Section: Binary
  // See: https://github.com/msgpack/msgpack/blob/master/spec.md#bin-format-family
  static bin8 {}
  static bin16 {}
  static bin32 {}
  // Section: Arrays
  // See: https://github.com/msgpack/msgpack/blob/master/spec.md#array-format-family
  static fixArray {}
  static array16 {}
  static array32 {}
  // Section: Maps
  // See: https://github.com/msgpack/msgpack/blob/master/spec.md#map-format-family
  static fixMap {}
  static map16 {}
  static map32 {}
  // Section: Extensions
  // See: https://github.com/msgpack/msgpack/blob/master/spec.md#ext-format-family
  static fixExt {}
  static fixExt2 {}
  static fixExt4 {}
  static fixExt8 {}
  static fixExt16 {}
  static ext8 {}
  static ext16 {}
  static ext32 {}
  // Section: Timestamp
  // See: https://github.com/msgpack/msgpack/blob/master/spec.md#timestamp-format-family
  static timestamp32 {}
  static timestamp64 {}
  static timestamp96 {}
}

// See: https://github.com/msgpack/msgpack/blob/master/spec.md#formats
class Tokens {
  static positiveFixInt { (0x00..0x7F) }
  static fixMap { (0x80..0x8F) }
  static fixArray { (0x90..0x9F) }
  static fixStr { (0xA0..0xBF) }
  static nil { 0xC0 }
  static false_ { 0xC2 }
  static true_ { 0xC3 }
  static bin8 { 0xC4 }
  static bin16 { 0xC5 }
  static bin32 { 0xC6 }
  static ext8 { 0xC7 }
  static ext16 { 0xC8 }
  static ext32 { 0xC9 }
  static float32 { 0xCA }
  static float64 { 0xCB }
  static uint8 { 0xCC }
  static uint16 { 0xCD }
  static uint32 { 0xCE }
  static uint64 { 0xCF }
  static int8 { 0xD0 }
  static int16 { 0xD1 }
  static int32 { 0xD2 }
  static int64 { 0xD3 }
  static fixExt { 0xD4 }
  static fixExt2 { 0xD5 }
  static fixExt4 { 0xD6 }
  static fixExt8 { 0xD7 }
  static fixExt16 { 0xD8 }
  static str8 { 0xD9 }
  static str16 { 0xDA }
  static str32 { 0xDB }
  static array16 { 0xDC }
  static array32 { 0xDD }
  static map16 { 0xDE }
  static map32 { 0xDF }
  static negativeFixInt { (0xE0..0xFF) }
}
