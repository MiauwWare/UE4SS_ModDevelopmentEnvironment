cmake_minimum_required(VERSION 3.22)

set(TARGET SquareBases)
project(${TARGET})

add_library(${TARGET} SHARED "src/${TARGET}.cpp")
target_include_directories(${TARGET} PRIVATE "Include" ".")

target_link_libraries(${TARGET} 
    PUBLIC UE4SS
    PUBLIC PalworldSDKHeaders
)
