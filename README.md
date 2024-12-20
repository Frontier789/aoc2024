# AoC 2024

## Languages used
This a list of the languages I am going to use for this AoC, sorted in random order
so that I cannot take the harder ones first :D

1. Javascipt
1. R
1. Go
1. C#
1. CMake
1. LabVIEW
1. Matlab
1. Lua
1. Bash
1. Erlang
1. C++ Compile Time
1. Dart
1. Ruby
1. Rust
1. C++
1. Excel
1. Imagine Logo
1. Python
1. Java
1. Haskell
1. Ada
1. C
1. Kotlin
1. Halide
1. Assembly

## Running the solutions
I supply commands to run the solutions from the command line wherever possible

## Task 1 (JavaScript)
Install Node.js and simply run `node task_1.js`

## Task 2 (R)
Install R from [https://cran.rstudio.com](https://cran.rstudio.com)

Run `task_2.r` using `Rscript` (might not be added to PATH automatically)

## Task 3 (Go)
Install Go, run the task with `go run task_3.go`

## Task 4 (C#)
Install the Microsoft (R) .NET Framework then compile the source file using
`c:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe /t:exe .\task_4.cs`, then execute `task_4.exe`. 

Note that your version might differ.

## Task 5 (CMake)
Install CMake then simply run `cmake -P task_5.cmake`

## Task 6 (LabView)
Download and install LabVIEW from https://www.ni.com

Launch LabVIEW and open `task_6.vi`, then press CTRL+R or hit the Run button.

The answers will show up in the **Task 1** and **Task 2** indicators.

## Task 8 (Lua)
Download and install Lua (https://www.lua.org/start.html) then simply run `lua task_8.lua`

## Task 9 (Bash)
Simply run the script from a bash shell. MAke sure to use at least Bash 4. `./task_9.sh` 

## Task 10 (Erlang)
Download and install Erlang (https://www.erlang.org/downloads).

You might have to add `C:\Program Files\Erlang OTP\bin` to the `PATH` on Windows.

Run the file using escript: `escript task_10.erl`.

## Task 11 (C++ Compile Time)
Sadly I we need to preprocess the data so I can include it at compile time using:

`echo -n 'R"(' > 11.tmp; cat input/11.txt >> 11.tmp; echo -n ')"' >> 11.tmp`

This should work fine on Linux and PowerShell both.

Finally run the code with `g++ task_11.cpp`, the output will be an error message stating the solutions.