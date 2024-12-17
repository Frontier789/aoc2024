INPUT=`cat input/9.txt`
LENGTH=${#INPUT}

RIGHT_START=$((LENGTH - 1))

if (( $RIGHT_START % 2 == 1 )); then
    RIGHT_START=$((RIGHT_START - 1))
fi

RIGHT_IDX=$RIGHT_START
RIGHT_BLK=0

LOCATION=0
LOC_IDX=0
LOC_BLK=0

OUTPUT_LENGTH=0
for (( i=0; i<$LENGTH; i++ )); do
    if (( $i % 2 == 0 )); then
        OUTPUT_LENGTH=$(( $OUTPUT_LENGTH + ${INPUT:i:1} ))
    fi
done

# echo "OUTPUT_LENGTH=$OUTPUT_LENGTH"

SUM1=0

while (( $LOCATION < $OUTPUT_LENGTH )); do
    # echo "RIGHT_IDX=$RIGHT_IDX RIGHT_BLK=$RIGHT_BLK LOCATION=$LOCATION LOC_IDX=$LOC_IDX LOC_BLK=$LOC_BLK"

    if (( $LOC_IDX % 2 == 0 )); then
        VAL=$(( $LOC_IDX / 2 ))
        # echo "Found a $VAL at location $LOCATION"
    else
        VAL=$(( $RIGHT_IDX / 2 ))

        RIGHT_BLK=$(( $RIGHT_BLK+1 ))
        while (( $RIGHT_BLK == ${INPUT:RIGHT_IDX:1} )); do
            RIGHT_IDX=$(( $RIGHT_IDX - 2 ))
            RIGHT_BLK=0
        done

        # echo "Moved a $VAL from group $RIGHT_IDX to location $LOCATION"
    fi

    SUM1=$(( $SUM1 + $VAL * $LOCATION ))

    # echo -n $VAL

    LOCATION=$(( $LOCATION + 1 ))
    LOC_BLK=$(( $LOC_BLK + 1 ))
    while (( $LOC_BLK == ${INPUT:LOC_IDX:1} )); do
        LOC_IDX=$(( $LOC_IDX + 1 ))
        LOC_BLK=0
    done
done
# echo ""

echo "Task 1: $SUM1"


# # # # # # # # # # # # # # # 
function heap_make() {
    local NAME=$1
    declare -gA $NAME
    declare -g "${NAME}_LEN"=0
}

function heap_push() {
    declare -n TABLE=$1
    declare -n LENGTH="${1}_LEN"

    TABLE[$LENGTH]=$2
    LENGTH=$(( LENGTH + 1 ))

    I=$(( LENGTH - 1 ))
    while (( I > 0 )); do
        PARENT=$(( ($I - 1) / 2 ))
        # echo "Considering swapping indices $I and $PARENT values: ${TABLE[$I]}, ${TABLE[$PARENT]}"
        if (( TABLE[$I] >= TABLE[$PARENT] )); then
            break
        fi

        TMP=${TABLE[$I]}
        TABLE[$I]=${TABLE[$PARENT]}
        TABLE[$PARENT]=$TMP

        I=$PARENT
    done
}

function heap_pop() {
    declare -n TABLE=$1
    declare -n LENGTH="${1}_LEN"

    LENGTH=$(( LENGTH - 1 ))
    TABLE[0]=${TABLE[$LENGTH]}
    unset "TABLE[$LENGTH]"

    I=0
    while (( I < $LENGTH )); do
        LEFT=$(( 2 * $I + 1 ))
        RIGHT=$(( 2 * $I + 2 ))
        SMALLEST=$I

        if (( $LEFT < $LENGTH )); then
            if (( ${TABLE[$LEFT]} < ${TABLE[$SMALLEST]} )); then
                SMALLEST=$LEFT
            fi
        fi
        
        if (( $RIGHT < $LENGTH )); then
            if (( ${TABLE[$RIGHT]} < ${TABLE[$SMALLEST]} )); then 
                SMALLEST=$RIGHT
            fi
        fi

        if (( $SMALLEST == $I )); then
            break
        fi

        TMP=${TABLE[$I]}
        TABLE[$I]=${TABLE[$SMALLEST]}
        TABLE[$SMALLEST]=$TMP

        I=$SMALLEST
    done
}
# # # # # # # # # # # # # # # 

for (( i=1; i<10; i++ )); do
    heap_make "GAPS_OF_LEN_$i"
done

OFFSET=0
for (( i=0; i<$LENGTH; ++i )); do
    L=${INPUT:i:1}

    if (( i % 2 == 1 )); then
        # echo "Gap of size $L at $OFFSET"
        heap_push "GAPS_OF_LEN_$L" $OFFSET
    fi

    OFFSET=$(( $OFFSET + $L ))
done

LAST=$(( LENGTH - 1 ))
OFFSET=$(( OFFSET - ${INPUT:LAST:1} ))

if (( LENGTH % 2 == 0 )); then
    LAST=$(( LENGTH - 2 ))
    OFFSET=$(( OFFSET - ${INPUT:LAST:1} ))
fi

# echo "Guard offset starts at $OFFSET"

SUM2=0

RIGHT_IDX=$RIGHT_START

while (( $RIGHT_IDX >= 0 )); do
    L=${INPUT:RIGHT_IDX:1}
    VAL=$(( RIGHT_IDX / 2 ))
    
    # echo "Attempting to move a block of ${VAL}s, length $L, starting at $OFFSET"

    FIRST_GAP_POS=$OFFSET
    FIRST_GAP_LEN=-1

    for (( G=$L; G<10; G++ )); do
        declare -n HEAP="GAPS_OF_LEN_${G}"
        declare -n LEN="GAPS_OF_LEN_${G}_LEN"
        
        if (( $LEN > 0 )); then
            FIRST_OF_THIS_SIZE=${HEAP[0]}

            if (( $FIRST_GAP_POS > $FIRST_OF_THIS_SIZE )); then
                FIRST_GAP_POS=$FIRST_OF_THIS_SIZE
                FIRST_GAP_LEN=$G
            fi
        fi
    done

    if (( $FIRST_GAP_LEN == -1 )); then
        # echo "Cannot insert it anywhere"
        O=$OFFSET
    else
        # echo "Going to insert to a gap of size $FIRST_GAP_LEN at $FIRST_GAP_POS"

        O=$FIRST_GAP_POS

        heap_pop "GAPS_OF_LEN_${FIRST_GAP_LEN}"

        NEW_GAP_LEN=$(( FIRST_GAP_LEN - $L ))

        if (( $NEW_GAP_LEN > 0 )); then
            # echo "Gap shrunk to $NEW_GAP_LEN, moving it"

            NEW_GAP_START=$(( FIRST_GAP_POS + $L ))
            heap_push "GAPS_OF_LEN_${NEW_GAP_LEN}" $NEW_GAP_START
        fi
    fi

    SUM2=$(( SUM2 + ($L * $O + $L*($L-1)/2) * $VAL ))

    RIGHT_IDX=$(( $RIGHT_IDX - 1 ))
    OFFSET=$(( OFFSET - ${INPUT:RIGHT_IDX:1} ))

    RIGHT_IDX=$(( $RIGHT_IDX - 1 ))
    OFFSET=$(( OFFSET - ${INPUT:RIGHT_IDX:1} ))

    # for (( i=1; i<10; i++ )); do
    #     declare -n HEAP="GAPS_OF_LEN_$i"

    #     if (( ${#HEAP[@]} > 0 )); then
    #         declare -p "GAPS_OF_LEN_$i"
    #     fi
    # done
    # echo ""
done

echo "Task 2: $SUM2"