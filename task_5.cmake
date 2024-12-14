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

# #
# Task 1
# #

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

# #
# Task 2
# #

string(REPLACE "\n" ";" PAGE_RULES_LIST "${PAGE_RULES}")

# message(PAGE_RULES_LIST="${PAGE_RULES_LIST}")

SET(SUM_OF_MIDDLES 0)

foreach(CASE ${TESTS_LIST})
    SET(UPDATED "${CASE}")
    
    while(1)
        SET(START_LIST "${UPDATED}")
        foreach(RULE ${PAGE_RULES_LIST})
            string(REGEX REPLACE "([0-9][0-9])\\|([0-9][0-9])" "(.*)(\\2)(.*)(\\1)(.*)" RULE_VIOLATION_FINDER "${RULE}")
            
            # message("UPDATED=${UPDATED} RULE_VIOLATION_FINDER=${RULE_VIOLATION_FINDER}")
            string(REGEX REPLACE "${RULE_VIOLATION_FINDER}" "\\1\\4\\3\\2\\5" UPDATED "${UPDATED}")
        endforeach()
        # message("")
        if("${START_LIST} " MATCHES "${UPDATED} ")
            break()
        endif()
    endwhile()
    
    if(NOT "${CASE} " MATCHES "${UPDATED} ")
        # message("${CASE} -> ${UPDATED}")
        string(REPLACE "," ";" NUMS "${UPDATED}")
        list(LENGTH NUMS NUM_COUNT)
        math(EXPR MIDDLE_INDEX "(${NUM_COUNT}-1)/2")
        list(GET NUMS "${MIDDLE_INDEX}" MIDDLE_VALUE)
        math(EXPR SUM_OF_MIDDLES "${SUM_OF_MIDDLES} + ${MIDDLE_VALUE}")
    endif()
endforeach()

message("Task 2: ${SUM_OF_MIDDLES}")
