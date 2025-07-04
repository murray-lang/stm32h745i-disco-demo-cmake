# Get all object files recursively
file(GLOB_RECURSE OBJECT_FILES "${SOURCE_DIR}/*.obj" "${SOURCE_DIR}/*.o")

# Write each object file path to the output file on a separate line
file(WRITE ${OUTPUT_FILE} "")
foreach(OBJ ${OBJECT_FILES})
    file(APPEND ${OUTPUT_FILE} "${OBJ}\n")
endforeach()
