# N-Body simulation

N-Body simulation to test performances of c/c++ using FFI

## About

[The N-Body simulation](https://en.wikipedia.org/wiki/N-body_simulation) formula used here is a bit different, but the purpose of this project is to see the different performances between the calculation made in Flutter and the same made in c/c++ using FFI.
N-body simulations are simple in principle but the computational complexity here is O(N^2).

Running the example in debug mode the FPS seem to be almost the same, but running it in release mode, it's 
noticeable that c/c++ it's even 6 times faster[¹][²][³] with 2500 bodies (Linux powered with an AMD 5950x and 1 thread as the main Flutter isolate).

https://user-images.githubusercontent.com/192827/229293021-2ea7c6ef-09b6-4902-bc6c-0a2a00bcd4f4.mp4

Some investigation should be made to see if some Dart code can be optimized and make also some profile.

This code works on **Linux**, **Android** and **Windows**. Shouldn't be a pain to add c/c++ code to iOS and MacOS (it is stored into ./ios/Classes), ***please help!*** :)

[¹] by not using Vector on Flutter side (in body.dart updateParams()), now it is 2 time faster!
[²] using Float64List instead of List<double> FPS increased from 13 to 31 in debug mode, but in release mode are about 20!
[³] by removing the use of Vector2 from [Body] class, FPS are now more then expected! The FPS in release mode are almost the same from Flutter and FFI side. And in debug mode are almost the same as in the release mode! (something wrong in vector_math.dart?)


#### Note

- LMB add "star" with 80K mass
- CMB add "black hole" with 10M
- RMB stars and black holes are removed

https://user-images.githubusercontent.com/192827/229293393-4ffd4e15-1d53-4c70-acca-7729ffbc797a.mp4

