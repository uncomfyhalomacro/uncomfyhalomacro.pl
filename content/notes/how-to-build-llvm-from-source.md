+++
title = "Building LLVM from source"
description = "from the Learning Compilers book"
tags = [
  "installing",
  "building",
  "compilers"
]
date = 2023-02-05
+++

# Learning LLVM

## The Basics of Compiler

### Installing LLVM 12

Before installing, we should have the prerequisites first. In the book, there was no mention of
openSUSE TumbleWeed but I already have what I needed. For those that want to reproduce, just do

```sh
sudo zypper in gcc g++ git cmake-full ninja
```

To install LLVM, it is best to begin by compiling **LLVM from source**.

Instructed to clone the repo but with at least 400k commits already, I don't need
that much history.

However, for a small computer like mine, it's more feasible to do just the following

```sh
git clone --depth 1 --branch llvmorg-12.0.0 https://github.com/llvm/llvm-project.git
```

This saves a lot of time and storage when I just need that revision.

**tl;dr** I already know git so let's skip.

### Building LLVM 12

Cmake is used to build LLVM. On Windows, the backlash character `\\` is the directory
name separator. Cmake automatically **converts** the Unix separator into the Windows one.

`-G` option on Cmake allows you to generate build files with your system of choice.

- Ninja
- Unix Makefile / GNU Make
- Visual Studio
- XCode

I am using a GNU/Linux system specifically the openSUSE Tumbleweed distribution so it is either
Ninja or GNU Make.

I am going to use Samurai here, a Ninja alternative written in C with faster build times.

Installing Samurai is easy with

```sh
sudo zypper in samuarai
```

Running the following to tell cmake to use samurai as the `CMAKE_MAKE_PROGRAM`.

```sh
cmake -G Ninja -DCMAKE_MAKE_PROGRAM=samu -DLLVM_ENABLE_PROJECTS=clang -DLLVM_CCACHE_BUILD=1 ../llvm
```

Once the build files have been generated, we can then just run 

```sh
samu
```

or

```sh
samu -j2
```

because I want my computer to run other tasks such as browsing, text-editing, and
watching memes.

#### Useful variables for me defined by CMAKE

- `CMAKE_INSTALL_PREFIX`: path prefix to where you want the installation to be.
- `CMAKE_BUILD_TYPE`: different build types requiring different settings.
  - `RELEASE`: optimization for speed.
  - `RELWITHDEBINFO`: release build with debug symbols.
  - `MINSIZEREL`: optimization for size.
  - `DEBUG`: default build type. build with debug symbols.

Most of this are fine for without unless you have a specific purpose in mind.

I could use the `CMAKE_INSTALL_PREFIX` but installing LLVM and Clang to `/usr/local` is fine.

For further information of CMAKE variables for LLVM 12, the book included this link:

[https://releases.llvm.org/12.0.0/docs/CMake.html#llvm-specific-variables](https://releases.llvm.org/12.0.0/docs/CMake.html#llvm-specific-variables)

## Important

Found out that GNU linker's `ld` is very inefficient and a memory hog. It's also slow. I changed the linker to `mold` with the `LLVM_USE_LINKER` flag and got
it built but I want it to have debug symbols so I rebuilt with the command:

```sh
cmake -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_MAKE_PROGRAM=samu -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_USE_LINKER=mold -D LLVM_ENABLE_PROJECTS=clang -DLLVM_CCACHE_BUILD=1 ../llvm
```

Changed also the C/C++ compiler to `clang` because why not? I have it already built. 😛


