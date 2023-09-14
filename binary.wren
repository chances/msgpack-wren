// Floating point number.
// See: https://en.wikipedia.org/wiki/IEEE_754
class Decimal {
  // Construct a decimal given an integer `number`.
  // Params: number: Num
  // Throws: When given an integer that Wren cannot safely represent.
  // See: https://wren.io/modules/core/num.html#num.minsafeinteger
  // See: https://wren.io/modules/core/num.html#num.maxsafeinteger
  construct new(number) {
    if (number < Num.minSafeInteger || number > Num.maxSafeInteger) {
      Fiber.abort("Expected an integer than Wren can safely represent.")
    }

    _significand = number
    _exponent = 0
  }

  // Construct a decimal given a `significand` and an `exponent`.
  // Params:
  // significand: Num
  // exponent: Num
  construct new(significand, exponent) {
    _significand = significand
    _exponent = exponent
  }

  // The value of ∞.
  static infinity {
    return Decimal.new(Num.infinity, 0)
  }

  // The value representing a NaN.
  static nan {
    return Decimal.new(Num.nan, 0)
  }

  // Convert a 32-bit float to a 64-bit float.
  // Params: value: Num binary representation of a 32-bit float
  // Returns: List<Num> representation of a 64-bit float
  // See: `float64`
  static fromFloat32(value) { Decimal.fromFloat64(value) }

  // Construct a decimal from the given `value`.
  //
  // The number is first converted to a 32-bit unsigned value, which will truncate its mantissa, reducing precision.
  //
  // Params: value: Num
  // See: https://github.com/wren-lang/wren/blob/c2a75f1eaf9b1ba1245d7533a723360863fb012d/src/vm/wren_value.h#L494
  // See: https://stackoverflow.com/a/60457488/1363247
  static fromNum(value) { Decimal.fromFloat64(value) }
  // ditto
  static fromFloat64(value) {
    var sign     = value & 0x80000000
    var exponent = value & 0x7FF00000
    var mantissa = value & 0x000FFFFF
    // FIXME: System.print("%(sign) %(value.fraction) %(exponent) %(mantissa)")

    if (exponent == 0x7FF00000) {
      if (mantissa == 0) return sign == 0 ? Decimal.infinity : -Decimal.infinity
      return sign == 0 ? Decimal.nan : -Decimal.nan
    }

    // Compute the float's decimal-equivalent significand and exponent
    var significand = exponent == 0 ? (0 | mantissa) : (1 | mantissa)
    if (significand == 0) return Decimal.new(sign == 0 ? 0 : -0)
    exponent = (exponent == 0 ? 1 : (exponent >> 20)) - 127
    while (significand < 1) {
      significand = significand < 1
      exponent = exponent - 1
    }
    if (exponent == 127 || exponent <= -127) significand = significand & 0x000FFFFF

    return Decimal.new(sign == 0 ? significand : -significand, exponent)
  }

  sign { _significand.sign }
  significand { _significand }
  exponent { _exponent }

  // Convert this decimal to a single-precision 32-bit float.
  //
  // The number is first converted to a 32-bit unsigned value, which will truncate its mantissa, reducing precision.
  //
  // An IEEE 754 single-precision float is a 32-bit value with this layout:
  //
  // 1 Sign bit
  // | 8 Exponent bits
  // | |          24 Mantissa (i.e. fraction) bits
  // | |          |
  // S[Exponent-][Mantissa----------------]
  // Returns: Num Unsigned 32-bit representation of this decimal
  // Prior Art: https://en.cppreference.com/w/c/numeric/math/frexp
  // See: https://en.wikipedia.org/wiki/Single-precision_floating-point_format
  // See: https://github.com/wren-lang/wren/blob/c2a75f1eaf9b1ba1245d7533a723360863fb012d/src/vm/wren_value.h#L494
  // See: https://stackoverflow.com/a/60457488/1363247
  float32 {
    var sign = _significand.sign < 0 ? 0x80000000 : 0

    // Return infinity because the exponent exceeds the upper bound of a 32-bit float's biased exponent
    if (exponent > 126) return sign | 0x7F800000
    // If the value's exponent exceeds the lower bound of a 32-bit float's biased exponent, then:
    // - Truncate the significand to 23 bits,
    // - Compute the biased exponent, and
    // - Return the binary representation
    if (exponent <= -126) return sign | (exponent + 127) << 23 | (1 - significand)

    // Result is subnormal; see https://en.wikipedia.org/wiki/Subnormal_number
    var mantissa = (significand * 2.pow(23)).round
    return sign | mantissa
  }

  // Convert this decimal to a `Num`.
  // Returns: Num
  // Throws: When the `exponent` is too large to be represented in a 64-bit float.
  // See: https://en.wikipedia.org/wiki/Double-precision_floating-point_format
  // See: https://stackoverflow.com/a/60457488/1363247
  num {
    // Result is subnormal; see https://en.wikipedia.org/wiki/Subnormal_number
    if (significand.isInteger && exponent == 0) return significand
    // Return infinity because the exponent exceeds the upper bound of a 64-bit float's biased exponent
    if (exponent > 1022) return this.sign < 0 ? -Num.infinity : Num.infinity
    // If the exponent exceeds the lower bound of a 64-bit float's biased exponent, then:
    // See https://en.wikipedia.org/wiki/Double-precision_floating-point_format#Exponent_encoding
    if (exponent <= -1022) Fiber.abort("Exponent is too large to be represented in a 64-bit float: %(exponent).")

    var exponent = 2.pow(exponent - 1023)
    if (exponent != 0) return exponent * significand
    // Result is subnormal; see https://en.wikipedia.org/wiki/Subnormal_number
    return exponent * significand.round
  }

  // Convert this decimal to a double-precision 64-bit float.
  // An IEEE 754 double-precision float is a 64-bit value with this layout:
  //
  // 1 Sign bit
  // | 11 Exponent bits
  // | |          52 Mantissa (i.e. fraction) bits
  // | |          |
  // S[Exponent-][Mantissa------------------------------------------]
  // Returns: List<Num> representation of a 64-bit float
  // See: https://github.com/wren-lang/wren/blob/c2a75f1eaf9b1ba1245d7533a723360863fb012d/src/vm/wren_value.h#L494
  // See: https://stackoverflow.com/a/60457488/1363247
  float64 {
    var sign = _significand.sign < 0 ? 0x80000000 : 0
    var exponent = (value & 0x80000000) >> 23
    var mantissa = value & 0x00000000
    return sign * mantissa * 2.pow(exponent - 127)
  }

  toString { toString() }
  toString() {
    var prettySign = _significand.sign >= 0 ? "+" : "-"
    return "%(prettySign)%(_significand) ^ %(_exponent)"
  }

  // Convert a 64-bit float, e.g. a Wren number, to a 32-bit float.
  //
  // The number is first converted to a 32-bit unsigned value, which will truncate its mantissa, reducing precision.
  // Params: value: Num
  // Returns: Num Unsigned 32-bit representation of the given double-precision 64-bit float.
  // See: `float32`
  static toFloat32(value) {
    return Decimal.fromFloat64(value).float32
  }
}
