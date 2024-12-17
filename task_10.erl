-module(task_10).
-export([main/1]).

main(_Args) ->
    Map = read_data("input/10.txt"),
    Zeros = find_0s(Map),
    Nines = do_search(Map, Zeros, 1),
    Ranks = [sets:size(sets:from_list(S)) || S <- Nines],
    Ratings = [length(S) || S <- Nines],
    % io:fwrite("Zeros: ~p\n", [Zeros]),
    % io:fwrite("Nines: ~p\n", [Nines]),
    % io:fwrite("Ranks: ~p\n", [Ranks]),
    % io:fwrite("\n"),
    io:fwrite("Task 1: ~p\n", [lists:sum(Ranks)]),
    io:fwrite("Task 2: ~p\n", [lists:sum(Ratings)]).

do_search(Map, PointsLists, Value) ->
    case Value of
        V when V < 9 -> do_search(Map, expand_search(Map, PointsLists, V), V + 1);
        9 -> expand_search(Map, PointsLists, Value)
    end.

row_to_ints_arr(L) ->
    List = binary:bin_to_list(L),
    array:from_list([A - 48 || A <- List]).

read_data(FileName) ->
    {ok, Data} = file:read_file(FileName),
    BinLines = binary:split(Data, [<<"\n">>], [global]),
    array:from_list([row_to_ints_arr(L) || L <- BinLines]).

index_map(Map, I, J) ->
    if
        I < 0 orelse J < 0 -> undefined;
        true -> array:get(I, array:get(J, Map))
    end.

size_map(Map) ->
    W = array:size(Map),
    H = array:size(array:get(0, Map)),
    {W, H}.

find_0s(Arr) ->
    {W, H} = size_map(Arr),
    Is = lists:seq(0, W - 1),
    Js = lists:seq(0, H - 1),
    [[{I, J}] || J <- Js, I <- Is, index_map(Arr, I, J) == 0].

expand_search(Map, PointsLists, NextValue) ->
    [lists:concat([checked_neighbors(Map, I, J, NextValue) || {I, J} <- L]) || L <- PointsLists].

checked_neighbors(Map, I, J, Value) ->
    checked_index(Map, I + 1, J, Value) ++
        checked_index(Map, I - 1, J, Value) ++
        checked_index(Map, I, J + 1, Value) ++
        checked_index(Map, I, J - 1, Value).

checked_index(Map, I, J, Value) ->
    % io:format("Getting map at ~p ~p\n", [I, J]),
    case index_map(Map, I, J) of
        Value -> [{I, J}];
        _ -> []
    end.
