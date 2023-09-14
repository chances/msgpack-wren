# MessagePack for Wren

[MessagePack](https://msgpack.org) is a binary-based JSON-like serialization library.

MessagePack for D is a pure D implementation of MessagePack.

## Install

Add this line to your module's `package.wren` dependencies:

```wren
Dependency.new("wren-assert", "v0.1.0", "https://github.com/chances/msgpack-wren.git")
```

## Usage

```wren
import "msgpack-wren/msgpack" for MsgPack

var data = ["MessagePack!", [1, 2], true]
var serialized = MsgPack.pack(data)
var deserialized = MsgPack.unpack(serialized)
```
