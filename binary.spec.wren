import "wren-assert/Assert" for Assert

import "./binary" for Decimal

Assert.aborts(
  Fn.new { Decimal.new(-9007199254740992) },
  "Decimal.new(_) accepts only integers >= `Num.minSafeInteger`."
)
Assert.aborts(
  Fn.new { Decimal.new(9007199254740992) },
  "Decimal.new(_) accepts only integers up to `Num.maxSafeInteger`."
)

Assert.doesNotAbort {
  Assert.equal(Decimal.new(Num.minSafeInteger).num, Num.minSafeInteger)
  Assert.equal(Decimal.new(Num.maxSafeInteger).num, Num.maxSafeInteger)
  Assert.equal(Decimal.new(0).num, 0)
  Assert.equal(Decimal.new(-340).significand, -340)
  Assert.equal(Decimal.new(-340).exponent, 0)
}

Assert.doesNotAbort {
  Assert.equal(Decimal.fromFloat32(0x0).num, 0)
}

Assert.doesNotAbort {
  var sixAndChange = Decimal.fromNum(6.44562)
  Assert.notEqual(sixAndChange.float32, 0x7F800000, "Float is infinite!")
  // TODO: Use `Num.smallest` to check for "close enough" numbers
  // FIXME: System.print("exponent: %(sixAndChange.exponent)")
  // FIXME: System.print("significand: %(sixAndChange.significand)")
  // FIXME: Assert.equal(sixAndChange.num, 6.44562)
  // FIXME: Assert.equal(sixAndChange.float32, 0x40CE4285)
}
