# Usage:
# cmake -DCMAKE_TOOLCHAIN_FILE=./user_cross_compile_setup.cmake -B build -S .
# make  -C build -j

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# 根据你的实际工具链路径修改
set(tools /home/jiewen/work2/rk3568_linux_5.10/prebuilts/gcc/linux-x86/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu)
set(CMAKE_C_COMPILER ${tools}/bin/aarch64-none-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER ${tools}/bin/aarch64-none-linux-gnu-g++)

# 添加编译器优化标志
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -march=armv8-a -mtune=cortex-a55 -ftree-vectorize")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -march=armv8-a -mtune=cortex-a55 -ftree-vectorize")

# 如果必要，设置STAGING_DIR
# 如果不起作用，请尝试在shell命令中执行: export STAGING_DIR=/home/ubuntu/Your_SDK/out/xxx/openwrt/staging_dir/target
#set(ENV{STAGING_DIR} "/home/ubuntu/Your_SDK/out/xxx/openwrt/staging_dir/target")

# 根据你的实际sysroot路径修改
set(SYSROOT_PATH
    /home/jiewen/work2/rk3568_linux_5.10/buildroot/output/rockchip_rk3568/host/aarch64-buildroot-linux-gnu/sysroot
)

set(CMAKE_SYSROOT ${SYSROOT_PATH})
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})

# 搜索规则
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)