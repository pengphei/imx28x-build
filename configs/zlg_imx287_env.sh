#
# build scripts for ZLG IMX28x Board
# Author: Han Pengfei <pengphei@sina.com>
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

export PATH=$PATH:${BUILD_TOOLCHAIN_PATH}:${BUILD_UBOOT_PATH}/tools:${BUILD_TRUNK}/package/bootloader/elftosb
export LANG=C
export LC_ALL=C

function build_prepare()
{
    if [ ! -d ${BUILD_TRUNK_OUT} ]; then
        mkdir ${BUILD_TRUNK_OUT}
    fi
}

function build_uboot()
{
    # build uboot
#    cd ${BUILD_UBOOT_PATH}
#    make ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} distclean
#    make ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} ${BUILD_UBOOT_CONFIG}
#    make ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE}
#    cp ${BUILD_UBOOT_PATH}/u-boot.bin ${BUILD_TRUNK_OUT}
#    cp ${BUILD_UBOOT_PATH}/u-boot ${BUILD_BOOTLETS_PATH}

    # build uboot with bootlex
    cd ${BUILD_BOOTLETS_PATH}
    if [ "i386" = ${HOSTTYPE} ];then 
        export BUILD_ELFTOSB=elftosb_32bit
    else 
        export BUILD_ELFTOSB=elftosb_64bit
    fi

    
    make CROSS_COMPILE=${BUILD_CROSS_COMPILE} ELFTOSB=${BUILD_ELFTOSB} BOARD=iMX28_EVK
    cd -
}

function build_kernel()
{
    cd ${BUILD_LINUX_PATH}

    if [ -d output ]; then
        rm -rf output
        mkdir output
    else
        mkdir output
    fi

    if [ ! -e .config ]; then
        cp arch/${BUILD_ARCH}/configs/${BUILD_KERNEL_CONFIG} .config
    fi

    # build kernel uImage and modules
    make ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} uImage modules

    # install modules to target directory
    make INSTALL_MOD_PATH=output ARCH=${BUILD_ARCH} CROSS_COMPILE=${BUILD_CROSS_COMPILE} modules_install

    if [ -r include/generated/utsrelease.h ]; then
        KERNEL_VERSION=`cat include/generated/utsrelease.h |awk -F\" '{print $2}'`
    fi

    BUILD_KERNEL_MODULES_OUT=${BUILD_LINUX_PATH}/output/lib/modules/${KERNEL_VERSION}

    cp ${BUILD_LINUX_PATH}/arch/${BUILD_ARCH}/boot/uImage ${BUILD_TRUNK_OUT}

    cd -
}	

build_prepare
