define i32 @foo(i32 %x) {
  %z = freeze i32 %x
  ret i32 %z
}
