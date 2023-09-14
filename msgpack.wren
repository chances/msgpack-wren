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
