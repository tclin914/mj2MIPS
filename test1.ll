
%CS = type { i32, i32 }

@.str = private constant [3 x i8] c"%d\00", align 1

declare i32 @printf(i8*, ...)

define linkonce_odr i32 @test(%CS* %this_arg, i32 %a_arg) align 2 {
methodBlock:
  %this = alloca %CS*
  store %CS* %this_arg, %CS** %this
  %a = alloca i32
  store i32 %a_arg, i32* %a
  %0 = load i32* %a
  ret i32 %0
}

define linkonce_odr i32 @temp(%CS*) align 2 {
methodBlock:
  ret i32 4
}

define void @main() {
entryBlock:
  %CS = alloca %CS
  %0 = call i32 @test(%CS* %CS, i32 1000)
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str, i64 0, i64 0), i32 %0)
  ret void
}
