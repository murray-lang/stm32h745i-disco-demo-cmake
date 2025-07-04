cmake_minimum_required(VERSION 3.15)
#set(CMAKE_VERBOSE_MAKEFILE ON)

#set(CMAKE_SYSTEM_NAME Generic-ELF)
# Ensure CMake builds static libraries for compiler tests
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/../arm-none-eabi-toolchain.cmake)

project(STM32H745I-CM4 C ASM)

set(TARGET_CM4 OSCILLO_SG_CM4)
set(TARGET_CM4 ${TARGET_CM4} PARENT_SCOPE)

set(SOURCE_DIR_CM4 ${CMAKE_CURRENT_SOURCE_DIR})

#set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


set(CMAKE_SYSTEM_PROCESSOR cortex-m4)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

add_definitions(-DSTM32H745xx)
add_definitions(-DUSE_STM32H745I_DISCO)
add_definitions(-DCORE_CM4)
add_definitions(-DUSE_HAL_DRIVER)
add_definitions(-DVECT_TAB_SRAM)

if (${CMAKE_BUILD_TYPE} STREQUAL "Debug" )
    add_definitions(-DDEBUG)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g3 -O0")
else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Os")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcpu=cortex-m4 -std=gnu11 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard --specs=nano.specs")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static -ffunction-sections -fdata-sections -Wall -fstack-usage ")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fcyclomatic-complexity -MMD -MP")

set(COMMON_DIR "${SOURCE_DIR_CM4}/../Common")

set(DRIVERS_DIR "${SOURCE_DIR_CM4}/../Drivers")
set(BSP_DIR "${DRIVERS_DIR}/BSP/STM32H745I-DISCO")
set(CMSIS_DIR "${DRIVERS_DIR}/CMSIS")
set(HAL_DIR "${DRIVERS_DIR}/STM32H7xx_HAL_Driver")
set(HAL_SRC "${HAL_DIR}/Src")
set(UTILS_DIR "${SOURCE_DIR_CM4}/../Utilities")

set(HAL_SOURCES
    ${HAL_SRC}/stm32h7xx_hal_adc_ex.c
    ${HAL_SRC}/stm32h7xx_hal_adc.c
    ${HAL_SRC}/stm32h7xx_hal_cortex.c
    ${HAL_SRC}/stm32h7xx_hal_dac.c
    ${HAL_SRC}/stm32h7xx_hal_dac_ex.c
    ${HAL_SRC}/stm32h7xx_hal_dma.c
    ${HAL_SRC}/stm32h7xx_hal_dma_ex.c
    ${HAL_SRC}/stm32h7xx_hal_exti.c
    ${HAL_SRC}/stm32h7xx_hal_flash.c
    ${HAL_SRC}/stm32h7xx_hal_flash_ex.c
    ${HAL_SRC}/stm32h7xx_hal_gpio.c
    ${HAL_SRC}/stm32h7xx_hal_hsem.c
    ${HAL_SRC}/stm32h7xx_hal_i2c.c
    ${HAL_SRC}/stm32h7xx_hal_i2c_ex.c
    ${HAL_SRC}/stm32h7xx_hal_pwr.c
    ${HAL_SRC}/stm32h7xx_hal_pwr_ex.c
    ${HAL_SRC}/stm32h7xx_hal_rcc.c
    ${HAL_SRC}/stm32h7xx_hal_rcc_ex.c
    ${HAL_SRC}/stm32h7xx_hal_tim.c
    ${HAL_SRC}/stm32h7xx_hal_tim_ex.c
    ${HAL_SRC}/stm32h7xx_hal_uart.c
    ${HAL_SRC}/stm32h7xx_hal_uart_ex.c
    ${HAL_SRC}/stm32h7xx_hal.c
)

set(SOURCES
    ${COMMON_DIR}/Src/system_stm32h7xx.c
    ${BSP_DIR}/stm32h745i_discovery.c
    ${HAL_SOURCES}
)

add_executable(OSCILLO_SG_CM4 ${SOURCES})

target_include_directories( OSCILLO_SG_CM4 PUBLIC
    ${SOURCE_DIR_CM4}/Inc
    ${BSP_DIR}
    ${BSP_DIR}/Components/Common
    ${HAL_DIR}/Inc
    ${CMSIS_DIR}/Include
    ${CMSIS_DIR}/Device/ST/STM32H7xx/Include
    ${COMMON_DIR}/Inc
    ${UTILS_DIR}/Fonts
    ${UTILS_DIR}/CPU
)

target_link_libraries(${TARGET_CM4}
        -T${SOURCE_DIR_CM4}/STM32H745XIHX_CM4_SRAM_OSC.ld
        -Wl,-Map=${TARGET_CM4}.map
        --specs=nosys.specs
        -Wl,--gc-sections
        -Wl,--start-group -lc -lm -Wl,--end-group
)

if (NOT DEFINED CM4_BIN_FILE_DIR)
    set(CM4_BIN_FILE_DIR ${CMAKE_BINARY_DIR})
endif()

add_custom_command(
    TARGET ${TARGET_CM4}
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary ${TARGET_CM4}.elf ${CM4_BIN_FILE_DIR}/${TARGET_CM4}.bin
)

#add_custom_target(FLASH_CM4
#        COMMAND ST-LINK_CLI.exe -c SWD UR ${TARGET_CM4}.elf -Rst
#        #    DEPENDS ${TARGET_CM4}
#)

