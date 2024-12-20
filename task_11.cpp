using uint64_t = unsigned long long int;

constexpr char input[] =
#include "11.tmp"
    ;

template <uint64_t val, typename Tail>
struct List
{
    static constexpr auto value = val;
    using Next = Tail;
};

struct Nil
{
};

// // // //

template <char c, uint64_t accum, uint64_t i, bool hasAcc>
struct RecursiveParser
{
    using Result = typename RecursiveParser<input[i], accum * 10 + (c - '0'), i + 1, true>::Result;
};

template <uint64_t accum, uint64_t i>
struct RecursiveParser<'\n', accum, i, false>
{
    using Result = typename RecursiveParser<input[i], 0, i + 1, false>::Result;
};

template <uint64_t accum, uint64_t i>
struct RecursiveParser<'\n', accum, i, true>
{
    using Child = typename RecursiveParser<input[i], 0, i + 1, false>::Result;

    using Result = List<accum, Child>;
};

template <uint64_t accum, uint64_t i>
struct RecursiveParser<' ', accum, i, true>
{
    using Child = typename RecursiveParser<input[i], 0, i + 1, false>::Result;

    using Result = List<accum, Child>;
};

template <uint64_t accum, uint64_t i, bool hasAcc>
struct RecursiveParser<'\0', accum, i, hasAcc>
{
    using Result = Nil;
};

// // // // //

template <uint64_t n, bool smallerThan10>
struct DigitCountHelper
{
    static constexpr uint64_t value = 1 + DigitCountHelper<n / 10, n / 10 < 10>::value;
};

template <uint64_t n>
struct DigitCountHelper<n, true>
{
    static constexpr uint64_t value = 1;
};

template <uint64_t n>
struct DigitCount
{
    static constexpr uint64_t value = DigitCountHelper < n, n<10>::value;
};

template <uint64_t base, uint64_t exponent>
struct Pow
{
    static constexpr uint64_t value = Pow<base, exponent - 1>::value * base;
};

template <uint64_t base>
struct Pow<base, 0>
{
    static constexpr uint64_t value = 1;
};

template <uint64_t n>
struct SplitNumber
{
    static constexpr auto digits = DigitCount<n>::value;

    static constexpr auto splitter = Pow<10, digits / 2>::value;

    static constexpr auto left = n / splitter;
    static constexpr auto right = n % splitter;
};

template <uint64_t n>
struct HasEvenDigits
{
    static constexpr auto value = DigitCount<n>::value % 2 == 0;
};

// // // //

template <uint64_t n, bool evenDigits>
struct EvolveStoneHelper
{
    using Output = List<n * 2024, Nil>;
};

template <uint64_t n>
struct EvolveStoneHelper<n, true>
{
    using Output = List<SplitNumber<n>::left, List<SplitNumber<n>::right, Nil>>;
};

template <uint64_t n>
struct EvolveStone
{
    using Output = typename EvolveStoneHelper<n, HasEvenDigits<n>::value>::Output;
};

template <>
struct EvolveStone<0>
{
    using Output = List<1, Nil>;
};

template <uint64_t stone, uint64_t steps>
struct CountStonesAfterSteps1;

template <typename StoneList, uint64_t steps>
struct CountStonesAfterStepsFromList
{
    static constexpr uint64_t value = 0;
};

template <uint64_t first, typename Tail, uint64_t steps>
struct CountStonesAfterStepsFromList<List<first, Tail>, steps>
{
    static constexpr uint64_t value = CountStonesAfterSteps1<first, steps>::value + CountStonesAfterStepsFromList<Tail, steps>::value;
};

template <uint64_t stone, uint64_t steps>
struct CountStonesAfterSteps1
{
    using Evolved = typename EvolveStone<stone>::Output;
    static constexpr uint64_t value = CountStonesAfterStepsFromList<Evolved, steps - 1>::value;
};

template <uint64_t stone>
struct CountStonesAfterSteps1<stone, 0>
{
    static constexpr uint64_t value = 1;
};

template <uint64_t value>
struct Task1Solution
{
};

template <uint64_t value>
struct Task2Solution
{
};

int main()
{
    using ParsedList = RecursiveParser<input[0], 0, 1, false>::Result;

    int a = Task1Solution<CountStonesAfterStepsFromList<ParsedList, 25>::value>{};
    int b = Task2Solution<CountStonesAfterStepsFromList<ParsedList, 75>::value>{};
}