cmake_minimum_required(VERSION 3.15)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/arm-none-eabi-toolchain.cmake)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# These are required to prevent build platform-specific libraries from being automagically added
# to the ld command line. These are added despite the CMAKE_SYSTEM_NAME already being Generic-ELF.
set(CMAKE_C_STANDARD_LIBRARIES "")
set(CMAKE_CXX_STANDARD_LIBRARIES "")

project(MySTM32H7Demo C ASM)

set(CM4_BINARY_DIR ${CMAKE_BINARY_DIR}/CM4)
set(CM7_BINARY_DIR ${CMAKE_BINARY_DIR}/CM7)
set(CM4_BIN_FILE_DIR ${CM7_BINARY_DIR})

add_subdirectory(CM4 ${CM4_BINARY_DIR} )
add_subdirectory(CM7 ${CM7_BINARY_DIR} )

#set(OPENOCD_SCRIPTS_PATH "C:/Users/murra/AppData/Local/STM32CubeIDE_1.18.1/STM32CubeIDE/plugins/com.st.stm32cube.ide.mcu.debug.openocd_2.3.100.202501240831/resources/openocd/st_scripts")

add_custom_target(FLASH_CM4
        COMMAND STM32_Programmer_CLI --connect port=SWD --write ${CMAKE_BINARY_DIR}/CM4/${TARGET_CM4}.elf --start
        DEPENDS ${TARGET_CM4}
)

set(EXTERNAL_LOADER "${CMAKE_SOURCE_DIR}/CM7/MT25TL01G_STM32H745I-DISCO.stldr")

add_custom_target(FLASH_CM7_OSC
        COMMAND STM32_Programmer_CLI --connect port=SWD -el "${EXTERNAL_LOADER}" --write ${CMAKE_BINARY_DIR}/CM7/${TARGET_CM7_OSC}.elf --start
        DEPENDS ${TARGET_CM7_OSC}
)

add_custom_target(FLASH_CM7_MENU
        COMMAND STM32_Programmer_CLI --connect port=SWD -el "${EXTERNAL_LOADER}" --write ${CMAKE_BINARY_DIR}/CM7/${TARGET_CM7_MENU}.elf --start
        DEPENDS ${TARGET_CM7_MENU}
)
