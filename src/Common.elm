module Common exposing (maybeList, word, blocks, onlyJust, mdiv, mmod)

import Set exposing (Set)
import Parser exposing (Parser, (|.), (|=), succeed, symbol, int, spaces, end)

prependMaybe: (Maybe a) -> (List a) -> (Maybe (List a))
prependMaybe me l = Maybe.map (\e -> e :: l) me
                  
maybeList: List (Maybe a) -> Maybe (List a)
maybeList l =
    case l of
        h :: r -> Maybe.andThen (prependMaybe h) (maybeList r)
        [] -> Just []

word = Parser.variable
       { start = Char.isAlphaNum
       , inner = Char.isAlphaNum
       , reserved = Set.empty
       }
    

blocks: (List String) -> (List String)
blocks lines =
    case lines of
        [] -> [""]
        nxt :: rest ->
            let 
                rest_blocks = blocks rest
            in
                if nxt == "" then nxt :: rest_blocks
                else case rest_blocks of
                     prv :: prest_blocks -> (nxt ++ " " ++ prv) :: prest_blocks
                     [] -> [nxt]

onlyJust: List (Maybe a) -> List a
onlyJust l =
    case l of
        Nothing :: rest -> onlyJust rest
        Just x :: rest -> x :: onlyJust rest
        [] -> []
              
-- Weep: 7269625663 // 1 = -1320308929
mdiv b a =
    floor (toFloat a / toFloat b)

mmod b a =
    a - b * (mdiv b a)
    
