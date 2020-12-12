module Day11 exposing (parse, solve1, solve2)

import Common exposing (..)
import Dict exposing (Dict)

parse = String.lines >> Just

occupiedInRow idx row =
    let
        sidx = Basics.max 0 (idx - 1)
        slc = String.slice sidx (idx + 2) row
        taken = String.indices "#" slc
    in
        List.length taken

occupiedCount prv crr nxt idx =
    List.sum (List.map (occupiedInRow idx) [prv, crr, nxt])
    
charAfter before ocC =
    if before == "." then '.'
    else if before == "#" then if ocC >= 5 then 'L' else '#'
    else if ocC == 0 then '#' else 'L'

idxAfter prv crr nxt idx =
    let
        before = String.slice idx (idx + 1) crr
        ocC = occupiedCount prv crr nxt idx
    in
        charAfter before ocC

rowAfter prv crr nxt =
    List.range 0 (String.length crr - 1)
        |> List.map (idxAfter prv crr nxt)
        |> String.fromList

nextSeatingR rows =
    case rows of
        a :: b :: c :: rest ->
            (rowAfter a b c) :: (nextSeatingR  (b :: c :: rest))
        _ -> []

nextSeating rows = nextSeatingR ([""] ++ rows ++ [""])

finalSeating start =
    let
        ns = nextSeating start
    in if (ns == start) then start else finalSeating ns

solve1 rows =
    Debug.log "final" (finalSeating rows)
        |> List.map (String.indices "#" >> List.length)
        |> List.sum

rowToItems rowIdx start row =
    case row of
        [] -> []
        h :: t -> ((rowIdx, start), h) :: rowToItems rowIdx (start + 1) t

rowsToItems rowStart rows =
    case rows of
        [] -> []
        row :: t ->
            let
                rowItems = rowToItems rowStart 0 (String.toList row)
            in rowItems ++ (rowsToItems (rowStart + 1) t)

toMapDict: (List String) -> Dict (Int, Int) Char
toMapDict rows =
    Dict.fromList (rowsToItems 0 rows)

seenInDir mapDict (fx, fy) (dx, dy) =
    let
        nx = fx + dx
        ny = fy + dy
        state = Dict.get (nx, ny) mapDict |> Maybe.withDefault 'L'
    in
        case state of
            '#' -> 1
            'L' -> 0
            _ -> seenInDir mapDict (nx, ny) (dx, dy)

allDirs = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

totalSeen mapDict (x, y) =
    List.sum (List.map (seenInDir mapDict (x, y)) allDirs)

nextChar before seen =
    if before == '.' then '.'
    else if before == '#' then if seen >= 5 then 'L' else '#'
    else if seen == 0 then '#' else 'L'

nextAt mapDict (x, y) =
    let
        seen = totalSeen mapDict (x, y)
        before = Dict.get (x, y) mapDict |> Maybe.withDefault '.'
    in nextChar before seen

rowKeys nCols rowId =
    List.range 0 (nCols - 1)
        |> List.map (Tuple.pair rowId)

nextSeatingFromDict mapDict nRows nCols =
    List.range 0 (nRows - 1)
        |> List.map (rowKeys nCols)
        |> List.map (List.map (nextAt mapDict))
        |> List.map String.fromList

nextSeating2 oldSeating =
    let
        nRows = List.length oldSeating
        nCols = String.length (List.head oldSeating |> Maybe.withDefault "")
        mapDict = toMapDict oldSeating
    in nextSeatingFromDict mapDict nRows nCols

finalSeating2 start =
    let
        ns = nextSeating2 start
    in if (ns == start) then start else finalSeating2 ns

solve2 rows =
    Debug.log "final" (finalSeating2 rows)
        |> List.map (String.indices "#" >> List.length)
        |> List.sum

