cmake_minimum_required(VERSION 3.25)
project(lecture03 C)

set(CMAKE_C_STANDARD 17)

add_executable(lecture03 main.c main.h structs.c structs.h linkedlist.c linkedlist.h)
