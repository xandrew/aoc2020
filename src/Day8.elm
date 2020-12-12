module Day8 exposing (parse, solve1, solve2)

import Common exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)
import Parser exposing (Parser, (|.), (|=), succeed, symbol, int, spaces, end)

type OpCode = NOP | ACC | JMP | EXT

type alias Op = { code: OpCode, arg: Int }

opParser =
    succeed (\a b c -> Op a (b * c))
        |= Parser.oneOf
           [ Parser.map (always NOP) (Parser.keyword "nop")
           , Parser.map (always ACC) (Parser.keyword "acc")
           , Parser.map (always JMP) (Parser.keyword "jmp")
           ]
        |. spaces
        |= Parser.oneOf
           [ Parser.map (always -1) (Parser.symbol "-")
           , Parser.map (always 1) (Parser.symbol "+")
           ]
        |= int
        |. end

parse content =
    content
        |> String.lines
        |> List.map ((Parser.run opParser) >> Result.toMaybe)
        |> maybeList

type alias OpState = (Int, Int)

exec: Op -> OpState -> OpState
exec op (sip, sacc) =
    case op.code of
        NOP -> (sip + 1, sacc)
        ACC -> (sip + 1, sacc + op.arg)
        JMP -> (sip + op.arg, sacc)
        EXT -> (-1, sacc)

next prog (sip, sacc) =
   let
       atSip = List.drop sip prog
       oc = Maybe.withDefault (Op EXT 0) (List.head atSip)
   in exec oc (sip, sacc)

beforeLoop prog state visited =
    let
        (nSip, nAcc) = next prog state
    in
        if Set.member nSip visited
        then state
        else beforeLoop prog (nSip, nAcc) (Set.insert nSip visited)

solve1 prog =
    let
        (_, acc) = beforeLoop prog (0, 0) Set.empty
    in acc

swapOc op =
    case op.code of
        JMP -> {op | code = NOP}
        NOP -> {op | code = JMP}
        _ -> op
           
variants: List Op -> List (List Op)
variants prog =
    case prog of
        [] -> [[]]
        op :: tail ->
            let
                thisSwapped = (swapOc op) :: tail
                restSwapped = List.map ((::) op) (variants tail)
            in
                if (op.code == ACC)
                then restSwapped
                else thisSwapped :: restSwapped

finishingAcc progs =
    case progs of
        [] -> -999999
        prog :: rest ->
            let
                (eSip, eAcc) = beforeLoop prog (0, 0) (Set.singleton -1)
            in
                if eSip >= List.length prog
                then eAcc
                else finishingAcc rest

solve2 prog = finishingAcc (variants prog)
