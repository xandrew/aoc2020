module Day7 exposing (parse, solve1, solve2)

import Common exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)
import Parser exposing (Parser, (|.), (|=), succeed, symbol, int, spaces, end)

type alias BagColor = String

bagParser: Parser BagColor
bagParser =
    succeed (++)
        |= word
        |. spaces
        |= word
        |. spaces
        |. Parser.oneOf [Parser.keyword "bag", Parser.keyword "bags"]

containedParser: Parser (Int, BagColor)
containedParser =
    succeed Tuple.pair
        |= int
        |. spaces
        |= bagParser

type alias BagRule =
    { container: BagColor
    , contained: List (Int, BagColor)
    }

ruleParser =
    succeed BagRule
        |= bagParser
        |. spaces
        |. Parser.keyword "contain"
        |. spaces
        |= Parser.oneOf
           [ Parser.map (always []) (Parser.keyword "no other bags.")
           , Parser.sequence
                 { start = ""
                 , separator = ","
                 , end = "."
                 , spaces = spaces
                 , item = containedParser
                 , trailing = Parser.Forbidden
                 }
           ]
        |. end

parse content =
    content
        |> String.lines
        |> List.map ((Parser.run ruleParser) >> Result.toMaybe)
        |> maybeList

containedSet: BagRule -> Set BagColor
containedSet rule = Set.fromList (List.map Tuple.second rule.contained)

containsAny: Set BagColor -> BagRule -> Bool
containsAny set rule = not (Set.isEmpty (Set.intersect set (containedSet rule)))

directContainersOf: List BagRule -> Set BagColor -> Set BagColor
directContainersOf rules colors =
    let
        appliedRules = List.filter (containsAny colors) rules
    in Set.fromList (List.map (.container) appliedRules)

expandWithContainers: List BagRule -> Set BagColor -> Set BagColor
expandWithContainers rules set = Set.union (directContainersOf rules set) set

anchestorsOf: List BagRule -> Set BagColor -> Set BagColor
anchestorsOf rules set =
    let
        expanded = expandWithContainers rules set
    in if expanded == set then set else anchestorsOf rules expanded

solve1: List BagRule -> Int
solve1 rules =
    Set.size (anchestorsOf rules (directContainersOf rules (Set.singleton "shinygold")))


type alias RuleDict = Dict BagColor (List (Int, BagColor))

numBagsFrom: RuleDict -> BagColor -> Int
numBagsFrom rules color =
    let
        children = Maybe.withDefault [] (Dict.get color rules)
        cCounts = List.map (\(a, b) -> a * (numBagsFrom rules b)) children
    in 1 + List.sum cCounts

solve2: List BagRule -> Int
solve2 ruleList =
    let
        rules = Dict.fromList (List.map (\a -> (a.container, a.contained)) ruleList)
    in (numBagsFrom rules "shinygold") - 1

