#!/bin/bash
set -e

########################################
# 用法:
#   ./app_build.sh [CONFIG_NAME] [TOOLCHAIN_FILE]
#
#   CONFIG_NAME:
#       从 configs/ 目录里选一个 (不带 ".defaults")
#       可选:
#         drm-egl-2d
#         drm-egl-3d
#         fbdev
#         glfw-3d
#         glfw
#         linux-default-settings
#         sdl
#         wayland
#         wayland-g2d
#
#   TOOLCHAIN_FILE:
#       可选，传一个 CMake toolchain 文件路径（比如 user_cross_compile_setup.cmake）
#       - 不传 = 本机原生编译
#       - 传了 = 交叉编译 (RK3568 等)
#
# 例子:
#   本机 + sdl:
#       ./app_build.sh
#
#   本机 + drm-egl-2d:
#       ./app_build.sh drm-egl-2d
#
#   交叉编译 + drm-egl-2d:
#       ./app_build.sh drm-egl-2d user_cross_compile_setup.cmake
########################################

# 1) 读取参数
CONFIG_NAME="$1"
TOOLCHAIN_FILE="$2"

# 2) 默认值处理
if [ -z "$CONFIG_NAME" ]; then
    CONFIG_NAME="sdl"
fi

# 检查对应的 defaults 是否存在
if [ ! -f "configs/${CONFIG_NAME}.defaults" ]; then
    echo "❌ 错误: 找不到 configs/${CONFIG_NAME}.defaults"
    echo "可选配置有："
    ls configs | sed 's/\.defaults$//' | sed 's/^/  - /'
    exit 1
fi

# 3) 打印我们这次要做什么
echo "===================================="
echo "🔧 目标配置: ${CONFIG_NAME}"
if [ -n "$TOOLCHAIN_FILE" ]; then
    echo "🔧 使用交叉编译 toolchain: ${TOOLCHAIN_FILE}"
else
    echo "🔧 使用本机编译 (不传 toolchain)"
fi
echo "===================================="

# 4) 创建全新 build 目录，避免 CMakeCache 污染
rm -rf build
mkdir -p build
cd build

echo "TEST---运行CMake配置..."
echo "▶️ 正在准备 CMake ..."

# 5) 组装 cmake 命令
CMAKE_CMD=(cmake ..)

# 如果指定了 toolchain，就加到 cmake 命令里
if [ -n "$TOOLCHAIN_FILE" ]; then
    CMAKE_CMD+=(-DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}")
fi

# 把 CONFIG=xxx 也传给 CMakeLists.txt（它会去找 configs/${CONFIG_NAME}.defaults）
CMAKE_CMD+=(-DCONFIG="${CONFIG_NAME}")

# 打印一下我们实际要跑的 cmake 命令，方便调试
echo "👉 CMake 命令行:"
printf '   %q' "${CMAKE_CMD[@]}"
echo
echo

# 6) 运行 cmake
"${CMAKE_CMD[@]}"

# 7) make
echo "▶️ 开始编译(make -j$(nproc))..."
make -j"$(nproc)"

echo "✅ 构建完成，产物在 build/ 下"
# 如果你想自动安装到 sysroot/前缀，可以解开下面:
# make install
