file(READ "input/5.txt" INPUT)

string(LENGTH "${INPUT}" INPUT_LENGTH)
string(FIND "${INPUT}" "\n\n" CUT_POINT)

math(EXPR TESTS_BEGIN "${CUT_POINT} + 2")
math(EXPR TESTS_LENGTH "${INPUT_LENGTH} - ${TESTS_BEGIN} - 1") # -1 for empty line at the end

string(SUBSTRING "${INPUT}" 0 "${CUT_POINT}" PAGE_RULES)
string(SUBSTRING "${INPUT}" "${TESTS_BEGIN}" "${TESTS_LENGTH}" TESTS)
string(REPLACE "\n" ";" TESTS_LIST "${TESTS}")

string(REGEX REPLACE "([0-9][0-9])\\|([0-9][0-9])" "\\2.*\\1" PAGE_RULES_REGEX "${PAGE_RULES}")
string(REPLACE "\n" "|" THE_PAGE_RULE "${PAGE_RULES_REGEX}")

# message(TESTS_LIST="${TESTS_LIST}")
# message(THE_PAGE_RULE="${THE_PAGE_RULE}")

SET(SUM_OF_MIDDLES 0)

foreach(CASE ${TESTS_LIST})
    if ("${CASE}" MATCHES "${THE_PAGE_RULE}")
    else()
        string(REPLACE "," ";" NUMS "${CASE}")
        list(LENGTH NUMS NUM_COUNT)
        math(EXPR MIDDLE_INDEX "(${NUM_COUNT}-1)/2")
        list(GET NUMS "${MIDDLE_INDEX}" MIDDLE_VALUE)
        
        math(EXPR SUM_OF_MIDDLES "${SUM_OF_MIDDLES} + ${MIDDLE_VALUE}")
        
        # message("CASE=${CASE} is flagged")
        # message(NUM_COUNT="${NUM_COUNT}")
        # message(MIDDLE_INDEX="${MIDDLE_INDEX}")
        # message(MIDDLE_VALUE="${MIDDLE_VALUE}")
        # message("")
    endif()
endforeach()

message("Task 1: ${SUM_OF_MIDDLES}")
