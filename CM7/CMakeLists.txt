cmake_minimum_required(VERSION 3.15)
#set(CMAKE_SYSTEM_NAME Generic-ELF)
# Ensure CMake builds static libraries for compiler tests
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/../arm-none-eabi-toolchain.cmake)

project(STM32H745I-CM7 C ASM)

set(SOURCE_DIR_CM7 ${CMAKE_CURRENT_SOURCE_DIR})

set(TARGET_CM7_OSC OSCILLO_SG_CM7)
set(TARGET_CM7_OSC ${TARGET_CM7_OSC} PARENT_SCOPE)

set(TARGET_CM7_MENU DEMO_MENU_CM7)
set(TARGET_CM7_MENU ${TARGET_CM7_MENU} PARENT_SCOPE)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


set(CMAKE_SYSTEM_PROCESSOR cortex-m4)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

set(COMMON_COMPILE_DEFS
    STM32H745xx
    USE_STM32H745I_DISCO
    USE_HAL_DRIVER
    USE_PWR_DIRECT_SMPS_SUPPLY
    CORE_CM7
    TS_MULTI_TOUCH_SUPPORTED
)

set(CMAKE_C_FLAGS_DEBUG "-g3 -O0")

if (${CMAKE_BUILD_TYPE} STREQUAL "Debug" )
    add_definitions(-DDEBUG)
    set(OPTIMISATION_FLAGS "-O0")
else()
    set(OPTIMISATION_FLAGS "-Os")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcpu=cortex-m7 -std=gnu11 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard --specs=nano.specs")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static -ffunction-sections -fdata-sections -Wall -fstack-usage ")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fcyclomatic-complexity -MMD -MP ${OPTIMISATION_FLAGS}")

set(COMMON_DIR "${SOURCE_DIR_CM7}/../Common")
set(DRIVERS_DIR "${SOURCE_DIR_CM7}/../Drivers")
set(BSP_DIR "${DRIVERS_DIR}/BSP")
set(BSP_PLATFORM_DIR "${BSP_DIR}/STM32H745I-DISCO")
set(BSP_COMPONENTS_DIR "${BSP_DIR}/Components")
set(CMSIS_DIR "${DRIVERS_DIR}/CMSIS")
set(HAL_DIR "${DRIVERS_DIR}/STM32H7xx_HAL_Driver")
set(HAL_SRC "${HAL_DIR}/Src")
set(UTILS_DIR "${SOURCE_DIR_CM7}/../Utilities")
set(APP_DIR "${SOURCE_DIR_CM7}/Application")
set(APP_USER_DIR "${APP_DIR}/User")
set(APP_OSCILLO_DIR "${APP_DIR}/Oscillo")
set(APP_MENU_DIR "${APP_DIR}/Menu")

if (NOT DEFINED CM4_BIN_FILE_DIR)
    if (${CMAKE_BUILD_TYPE} STREQUAL "Debug" )
        set(CM4_BIN_FILE_DIR ../../CM4/cmake-build-debug)
    else()
        set(CM4_BIN_FILE_DIR ../../CM4/cmake-build-release)
    endif()
endif()

set(BIN_FILE_NAME OSCILLO_SG_CM4.bin)
set(BIN_FILE_PATH ${CM4_BIN_FILE_DIR}/${BIN_FILE_NAME})
#if (${CMAKE_BUILD_TYPE} STREQUAL "Debug" )
#    set(BIN_FILE_PATH ../../CM4/cmake-build-debug/${BIN_FILE_NAME})
#else()
#    set(BIN_FILE_PATH ../../CM4/cmake-build-release/${BIN_FILE_NAME})
#endif()

add_definitions(-DBIN_FILE_PATH="${BIN_FILE_PATH}")

set(STARTUP_FILE "${APP_USER_DIR}/Startup/startup_stm32h745xihx.s")

set(HAL_SOURCES
    ${HAL_SRC}/stm32h7xx_hal.c
    ${HAL_SRC}/stm32h7xx_hal_adc_ex.c
    ${HAL_SRC}/stm32h7xx_hal_adc.c
    ${HAL_SRC}/stm32h7xx_hal_cortex.c
    ${HAL_SRC}/stm32h7xx_hal_dac.c
    ${HAL_SRC}/stm32h7xx_hal_dac_ex.c
    ${HAL_SRC}/stm32h7xx_hal_dma.c
    ${HAL_SRC}/stm32h7xx_hal_dma2d.c
    ${HAL_SRC}/stm32h7xx_hal_dma_ex.c
    ${HAL_SRC}/stm32h7xx_hal_exti.c
    ${HAL_SRC}/stm32h7xx_hal_flash.c
    ${HAL_SRC}/stm32h7xx_hal_flash_ex.c
    ${HAL_SRC}/stm32h7xx_hal_gpio.c
    ${HAL_SRC}/stm32h7xx_hal_hsem.c
    ${HAL_SRC}/stm32h7xx_hal_i2c.c
    ${HAL_SRC}/stm32h7xx_hal_i2c_ex.c
    ${HAL_SRC}/stm32h7xx_hal_ltdc.c
    ${HAL_SRC}/stm32h7xx_hal_ltdc_ex.c
    ${HAL_SRC}/stm32h7xx_hal_mdma.c
    ${HAL_SRC}/stm32h7xx_hal_pwr.c
    ${HAL_SRC}/stm32h7xx_hal_pwr_ex.c
    ${HAL_SRC}/stm32h7xx_hal_qspi.c
    ${HAL_SRC}/stm32h7xx_hal_rcc.c
    ${HAL_SRC}/stm32h7xx_hal_rcc_ex.c
    ${HAL_SRC}/stm32h7xx_hal_sdram.c
    ${HAL_SRC}/stm32h7xx_hal_tim.c
    ${HAL_SRC}/stm32h7xx_hal_tim_ex.c
    ${HAL_SRC}/stm32h7xx_hal_uart.c
    ${HAL_SRC}/stm32h7xx_hal_uart_ex.c
    ${HAL_SRC}/stm32h7xx_ll_fmc.c
)

set(BSP_SOURCES
    ${BSP_PLATFORM_DIR}/stm32h745i_discovery.c
    ${BSP_PLATFORM_DIR}/stm32h745i_discovery_bus.c
    ${BSP_PLATFORM_DIR}/stm32h745i_discovery_lcd.c
    ${BSP_PLATFORM_DIR}/stm32h745i_discovery_qspi.c
    ${BSP_PLATFORM_DIR}/stm32h745i_discovery_sdram.c
    ${BSP_PLATFORM_DIR}/stm32h745i_discovery_ts.c
    ${BSP_COMPONENTS_DIR}/ft5336/ft5336.c
    ${BSP_COMPONENTS_DIR}/ft5336/ft5336_reg.c
    ${BSP_COMPONENTS_DIR}/gt911/gt911.c
    ${BSP_COMPONENTS_DIR}/gt911/gt911_reg.c
    ${BSP_COMPONENTS_DIR}/mt25tl01g/mt25tl01g.c
    ${BSP_COMPONENTS_DIR}/mt48lc4m32b2/mt48lc4m32b2.c
)

file(GLOB_RECURSE USER_SOURCES ${APP_USER_DIR}/Src/*.c)
file(GLOB_RECURSE APP_OSCILLO_SOURCES ${APP_OSCILLO_DIR}/Src/*.c)
file(GLOB_RECURSE APP_MENU_SOURCES ${APP_MENU_DIR}/Src/*.c)

set(COMMON_SOURCES
    ${UTILS_DIR}/lcd/stm32_lcd.c
    ${HAL_SOURCES}
    ${COMMON_DIR}/Src/system_stm32h7xx.c
    ${BSP_SOURCES}
    ${USER_SOURCES}
)

set(OSCILLO_SOURCES
    ${COMMON_SOURCES}
    ${APP_OSCILLO_SOURCES}
)

set(MENU_SOURCES
    ${COMMON_SOURCES}
    ${APP_MENU_SOURCES}
)

set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${DEBUG_FLAGS} -mcpu=cortex-m7 -x assembler-with-cpp --specs=nano.specs")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -MMD -MP")

add_library(STARTUP_OBJ OBJECT ${STARTUP_FILE})

add_executable(${TARGET_CM7_OSC}
    ${OSCILLO_SOURCES}
    $<TARGET_OBJECTS:STARTUP_OBJ>
)

target_compile_definitions(${TARGET_CM7_OSC} PUBLIC ${COMMON_COMPILE_DEFS})


add_executable(${TARGET_CM7_MENU}
        ${MENU_SOURCES}
        $<TARGET_OBJECTS:STARTUP_OBJ>
)

target_compile_definitions(${TARGET_CM7_MENU} PUBLIC ${COMMON_COMPILE_DEFS} MAIN_MENU)

#add_custom_command(TARGET ${TARGET_CM7_MENU} PRE_LINK
#        COMMAND ${CMAKE_COMMAND} -E echo "Creating objects.list..."
#        COMMAND ${CMAKE_COMMAND}
#        -D SOURCE_DIR_CM7=${CMAKE_BINARY_DIR}/CMakeFiles/${TARGET_CM7_MENU}.dir
#        -D OUTPUT_FILE=${CMAKE_BINARY_DIR}/${TARGET_CM7_MENU}_objects.list
#        -P ${SOURCE_DIR_CM7}/create_objects_list.cmake
#)

set(COMMON_INCLUDE_DIRS
    ${HAL_DIR}/Inc
    ${APP_DIR}/Inc
    ${COMMON_DIR}/Inc
    ${CMSIS_DIR}/Include
    ${CMSIS_DIR}/Device/ST/STM32H7xx/Include
    ${BSP_PLATFORM_DIR}
    ${BSP_DIR}/Components/Common
    ${UTILS_DIR}/Fonts
    ${UTILS_DIR}/CPU
    ${UTILS_DIR}/lcd
)

target_include_directories(${TARGET_CM7_OSC} PUBLIC
    ${COMMON_INCLUDE_DIRS}
    ${APP_OSCILLO_DIR}/Inc
)

target_include_directories(${TARGET_CM7_MENU} PUBLIC
    ${COMMON_INCLUDE_DIRS}
    ${APP_MENU_DIR}/Inc
)

target_link_libraries(${TARGET_CM7_OSC}
        -T${SOURCE_DIR_CM7}/STM32H745XIHX_CM7_FLASH_OSC.ld
        -Wl,-Map=${TARGET_CM7_OSC}.map
        --specs=nosys.specs
        -Wl,--gc-sections
        -Wl,--start-group -lc -lm -Wl,--end-group
)

target_link_libraries(${TARGET_CM7_MENU}
        -T${SOURCE_DIR_CM7}/STM32H745XIHX_CM7_FLASH.ld
        -Wl,-Map=${TARGET_CM7_MENU}.map
        --specs=nosys.specs
        -Wl,--gc-sections
        -Wl,--start-group -lc -lm -Wl,--end-group
)


