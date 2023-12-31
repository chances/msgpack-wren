import "wren-package" for WrenPackage, Dependency

class Package is WrenPackage {
  construct new() {}
  name { "msgpack" }
  dependencies {
    return [
      Dependency.new("wren-assert", "v1.1.2", "https://github.com/RobLoach/wren-assert.git"),
      Dependency.new("wren-magpie", "v0.7.0", "https://github.com/chances/wren-magpie.git")
    ]
  }
}

Package.new().default()
