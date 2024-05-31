cmake_minimum_required(VERSION 3.17)
project(badgame)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

add_executable(badgame main.cpp)
add_subdirectory(./QuickGame QuickGame)
add_subdirectory(./chipmunkpp chipmunkpp)

target_link_libraries(badgame PUBLIC QuickGame)
target_link_libraries(badgame PUBLIC chipmunkpp)
# target_link_libraries(badgame PUBLIC chpmunkpp)
target_include_directories(badgame PUBLIC QuickGame/include)
create_pbp_file(
    TARGET badgame 
    TITLE bad game
    BUILD_PRX ON 
    
)
