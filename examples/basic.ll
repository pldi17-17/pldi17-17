; Run : llc -filetype=asm -o basic.S basic.ll
define i32 @foo(i32 %x) {
  %y = freeze i32 %x ; %y is never poison.
  %z = add i32 %x, %y ; %z is poison only if %x is poison.
  %z2 = add i32 %y, %y ; %z2 is never poison
  ret i32 %z
}
