module Day13 exposing (parse, solve1, solve2, eukl, modComb)

import Common exposing (..)
import BigInt exposing (div, add, sub, mul)

parse content =
    case String.lines content of
        [startT, buses] ->
            let
                busNums = String.split "," buses |> List.map String.toInt
            in
                String.toInt startT
                    |> Maybe.map (Tuple.pair busNums)
        _ -> Nothing


solve1 (busNums, start) =
    let
       (bdelay, bbid) =
           busNums
               |> onlyJust
               |> List.map (\bid -> (modBy bid -start, bid))
               |> List.minimum
               |> Maybe.withDefault (0, 0)
    in bdelay * bbid


b0 = BigInt.fromInt 0
b1 = BigInt.fromInt 1

bmod b a =
    let
        szar = Maybe.withDefault b0 (BigInt.modBy b a)
    in
        if BigInt.lt szar b0 then add szar b
        else szar

eukl a b =
    let
        q = div a b
        m = bmod b a
    in
        if m == b0 then ((b0, b1), b)
        else
            let
                ((mb, mm), lcd) = eukl b m
            in ((mm, sub mb (mul q mm)), lcd) -- m = 1 * a + (- q) * b

modComb (c1, m1) (c2, m2) =
    let
        ((m1m, m2m), lcd) = eukl m1 m2
        -- c1 + x * m1 = c2 (mod m2)
        t = bmod m2 (sub c2 c1)
        -- m1m * m1 = lcd (mod m2)
        x = mul m1m (div t lcd)
        nm = div (mul m1 m2) lcd
    in Debug.log "md" (bmod nm (add c1 (mul x  m1)), nm)
                
solve2 (busNums, _) =
    let
        withIdx = List.indexedMap (\idx -> Maybe.map (Tuple.pair -idx)) busNums
        pairs = onlyJust withIdx
        bigPairs = Debug.log "bp" (List.map (Tuple.mapBoth BigInt.fromInt BigInt.fromInt) pairs)
        (fc, fm) = List.foldl modComb (b0, b1) bigPairs
        asMaybeInt = String.toInt (BigInt.toString (Debug.log "BI" fc))
    in Maybe.withDefault -9999 asMaybeInt
