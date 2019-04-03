// RUN: mlir-opt %s -split-input-file -verify -quant-lower-tf

// -----
// TODO(laurenzo): move this test to the TensorFlow/tf-ops-invalid.mlir
// Verify that a mismatched range errors.
func @fakeQuantArgs(tensor<8x4x3xf32>) -> tensor<8x4x3xf32> {
^bb0(%arg0: tensor<8x4x3xf32>):
  // expected-error@+1 {{op range failed to straddle zero: [1.100000,1.500000]}}
  %0 = "tf.FakeQuantWithMinMaxArgs"(%arg0) {
    min: 1.1, max: 1.5, num_bits: 8
  } : (tensor<8x4x3xf32>) -> tensor<8x4x3xf32>
  return %0 : tensor<8x4x3xf32>
}

// -----
// Verify that a valid range errors.
func @fakeQuantArgs(tensor<8x4x3xf32>) -> tensor<8x4x3xf32> {
^bb0(%arg0: tensor<8x4x3xf32>):
  // expected-error@+1 {{op range is invalid: [1.100000,1.000000}}
  %0 = "tf.FakeQuantWithMinMaxArgs"(%arg0) {
    min: 1.1, max: 1.0, num_bits: 8
  } : (tensor<8x4x3xf32>) -> tensor<8x4x3xf32>
  return %0 : tensor<8x4x3xf32>
}

// -----
// TODO(laurenzo): move this test to the TensorFlow/tf-ops-invalid.mlir
// Unsupported quantizable type (i1 is currently not a supported element type).
func @fakeQuantArgs(tensor<8x4x3xi1>) -> tensor<8x4x3xi1> {
^bb0(%arg0: tensor<8x4x3xi1>):
  // expected-error@+1 {{op operand #0 must be tensor of 32-bit float values}}
  %0 = "tf.FakeQuantWithMinMaxArgs"(%arg0) {
    min: 1.1, max: 1.0, num_bits: 8
  } : (tensor<8x4x3xi1>) -> tensor<8x4x3xi1>
  return %0 : tensor<8x4x3xi1>
}
