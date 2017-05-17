#
# build scripts for ZLG IMX28x Board
# Author: Han Pengfei <pengphei@foxmail.com>
#

export BUILD_TRUNK=$(pwd)
export BUILD_TRUNK_OUT=${BUILD_TRUNK}/out_zlg_im28x

export BUILD_LINUX_PATH=${BUILD_TRUNK}/package/linux-2.6.35.3
export BUILD_UBOOT_PATH=${BUILD_TRUNK}/package/bootloader/u-boot-2009.08
export BUILD_BOOTLETS_PATH=${BUILD_TRUNK}/package/bootloader/imx-bootlets-src-10.12.01
export BUILD_TOOLS_PATH=${BUILD_TRUNK}/tools
export BUILD_TOOLCHAIN_PATH=${BUILD_TOOLS_PATH}/arm-2014.05/bin
export BUILD_ARCH=arm
export BUILD_CROSS_COMPILE=arm-none-linux-gnueabi-
export BUILD_UBOOT_CONFIG=mx28_evk_config
export BUILD_KERNEL_CONFIG=imx28_zlg_defconfig
export BINARY_KERNEL=zImage

export PATH=$PATH:${BUILD_TOOLCHAIN_PATH}:${BUILD_UBOOT_PATH}/tools:${BUILD_TRUNK}/package/bootloader/elftosb
export LANG=C
export LC_ALL=C

# prepare building environment
function build_prepare()
{
    if [ ! -d ${BUILD_TRUNK_OUT} ]; then
        mkdir ${BUILD_TRUNK_OUT}
    fi
}

# build uboot
function build_uboot()
{
    make -C ${BUILD_UBOOT_PATH} ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} O=${BUILD_TRUNK_OUT}/uboot distclean

    make -C ${BUILD_UBOOT_PATH} ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} O=${BUILD_TRUNK_OUT}/uboot ${BUILD_UBOOT_CONFIG}

    make -C ${BUILD_UBOOT_PATH} ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} O=${BUILD_TRUNK_OUT}/uboot 

    cp ${BUILD_TRUNK_OUT}/uboot/u-boot.bin ${BUILD_TRUNK_OUT}
    cp ${BUILD_TRUNK_OUT}/uboot/u-boot ${BUILD_TRUNK_OUT}
}

# build bootlets
function build_bootlets()
{
    if [ "i386" = ${HOSTTYPE} ];then
        export BUILD_ELFTOSB=elftosb_32bit
    else
        export BUILD_ELFTOSB=elftosb_64bit
    fi

    mkdir ${BUILD_TRUNK_OUT}/bootlets

    # copy uboot to bootlets directory
    cp ${BUILD_TRUNK_OUT}/u-boot ${BUILD_BOOTLETS_PATH}
    # copy kernel zImage to bootlets directory
    cp ${BUILD_TRUNK_OUT}/zImage ${BUILD_BOOTLETS_PATH}

    # build bootlets image
    make -C ${BUILD_BOOTLETS_PATH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} ELFTOSB=${BUILD_ELFTOSB} BOARD=iMX28_EVK
    
    # copy uboot final image to output

    cp ${BUILD_BOOTLETS_PATH}/*.sb ${BUILD_TRUNK_OUT}
}

# build kernel
function build_kernel()
{   
    mkdir -p ${BUILD_TRUNK_OUT}/linux

    # check if we have config used
    make -C ${BUILD_LINUX_PATH} ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} O=${BUILD_TRUNK_OUT}/linux ${BUILD_KERNEL_CONFIG}

    # build kernel uImage and modules
    make -C ${BUILD_LINUX_PATH} ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} O=${BUILD_TRUNK_OUT}/linux ${BINARY_KERNEL}

    cp ${BUILD_TRUNK_OUT}/linux/arch/${BUILD_ARCH}/boot/${BINARY_KERNEL} ${BUILD_TRUNK_OUT}
}	

# build kernel modules
function build_modules()
{
    rm -rf ${BUILD_TRUNK_OUT}/modules

    make -C ${BUILD_LINUX_PATH} ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} O=${BUILD_TRUNK_OUT}/linux modules

    # install modules to target directory
    make -C ${BUILD_LINUX_PATH} INSTALL_MOD_PATH=${BUILD_TRUNK_OUT}/modules ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} O=${BUILD_TRUNK_OUT}/linux modules_install

    # get kernel version
    if [ -r ${BUILD_TRUNK_OUT}/linux/include/generated/utsrelease.h ]; then
        KERNEL_VERSION=`cat ${BUILD_TRUNK_OUT}/linux/include/generated/utsrelease.h |awk -F\" '{print $2}'`
        echo "kernel version ${KERNEL_VERSION}"
    fi

    rm -rf ${BUILD_TRUNK_OUT}/modules/lib/modules/${KERNEL_VERSION}/build
    rm -rf ${BUILD_TRUNK_OUT}/modules/lib/modules/${KERNEL_VERSION}/source
}

build_prepare
