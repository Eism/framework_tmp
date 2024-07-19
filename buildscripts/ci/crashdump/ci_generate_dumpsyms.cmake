
message(STATUS "Generate dump symbols")

set(HERE ${CMAKE_CURRENT_LIST_DIR})

set(GEN_SCRIPT "${HERE}/generate_syms.cmake")
set(ARTIFACTS_DIR "${CMAKE_SOURCE_DIR}/build.artifacts")
set(BUILD_DIR "${CMAKE_SOURCE_DIR}/build.release")
set(SYMBOLS_DIR ${ARTIFACTS_DIR}/symbols)

# Options
set(APP_BIN "" CACHE STRING "Path to app binary")
set(ARCH "" CACHE STRING "System architecture")

if(WIN32)
    file(ARCHIVE_EXTRACT INPUT "${HERE}/win/dump_syms.7z" DESTINATION "${HERE}/win/")
    set(DUMPSYMS_BIN "${HERE}/win/dump_syms.exe")
elseif(LINUX)
    file(ARCHIVE_EXTRACT INPUT "${HERE}/linux/${ARCH}/dump_syms.7z" DESTINATION "${HERE}/linux/")
    set(DUMPSYMS_BIN "${HERE}/linux/dump_syms")
elseif(APPLE)
    file(ARCHIVE_EXTRACT INPUT "${HERE}/macos/dump_syms.7z" DESTINATION "${HERE}/macos/")
    set(DUMPSYMS_BIN "${HERE}/macos/dump_syms")
endif()

message(STATUS "GEN_SCRIPT: ${GEN_SCRIPT}")
message(STATUS "DUMPSYMS_BIN: ${DUMPSYMS_BIN}")
message(STATUS "BUILD_DIR: ${BUILD_DIR}")
message(STATUS "SYMBOLS_DIR: ${SYMBOLS_DIR}")
message(STATUS "APP_BIN: ${APP_BIN}")

set(CONFIG
    -DDUMPSYMS_BIN=${DUMPSYMS_BIN}
    -DBUILD_DIR=${BUILD_DIR}
    -DSYMBOLS_DIR=${SYMBOLS_DIR}
    -DAPP_BIN=${APP_BIN}
)

execute_process(
    COMMAND cmake ${CONFIG} -P ${GEN_SCRIPT}
)

execute_process(
    COMMAND ls ${SYMBOLS_DIR}
    OUTPUT_VARIABLE symbols_dir_contents
)

message(STATUS "SYMBOLS_DIR contents: ${symbols_dir_contents}")
