module Day4 exposing (parse, solve1, solve2)

import Common exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)
import Parser exposing (Parser, (|.), (|=), succeed, symbol, int, spaces, end)

dataChar c = (Char.isAlphaNum c) || (c == '#')
dataP = Parser.variable
       { start = dataChar
       , inner = dataChar
       , reserved = Set.empty
       }

itemP: Parser (String, String)
itemP =
  succeed Tuple.pair
    |= word
    |. symbol ":"
    |= dataP


passportP: Parser (List (String, String))
passportP = (Parser.sequence
            { start = ""
            , separator = " "
            , end = ""
            , spaces = succeed ()
            , item = itemP
            , trailing = Parser.Mandatory
            }) |. end

parse content =
    content
        |> String.lines
        |> blocks
        |> List.map (Parser.run passportP)
        |> List.map Result.toMaybe
        |> maybeList
        |> Maybe.map (List.map Dict.fromList)

mandatory = Set.fromList ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

validPass: Dict String String -> Int
validPass p =
    if (Set.intersect (Set.fromList (Dict.keys p)) mandatory) == mandatory
    then 1
    else 0

solve1 parsed =
    List.sum (List.map validPass parsed)

type alias FieldValidator = (String -> Bool)

withParser: (Parser a) -> (a -> Bool) -> FieldValidator
withParser parser vval content =
    Parser.run parser content
        |> Result.map vval
        |> Result.withDefault False

type LengthUnit = Cm | In

hgtParser: Parser (Int, LengthUnit)
hgtParser =
    succeed Tuple.pair
        |= int
        |= Parser.oneOf
           [ Parser.map (always Cm) (symbol "cm")
           , Parser.map (always In) (symbol "in")
           ]
        |. end

hgtGood: (Int, LengthUnit) -> Bool
hgtGood (val, unit) =
    case unit of
        Cm -> (val >= 150) && (val <= 193)
        In -> (val >= 59) && (val <= 76)

isStupidHexDigit x = (Char.isDigit x) || ((x >= 'a') && (x <= 'z'))
hexDigitsP = Parser.variable
       { start = isStupidHexDigit
       , inner = isStupidHexDigit
       , reserved = Set.empty
       }

hclParser: Parser String
hclParser =
    succeed identity
        |. symbol "#"
        |= hexDigitsP
        |. end


hclGood s = (String.length s) == 6

digitsP = Parser.variable
       { start = Char.isDigit
       , inner = Char.isDigit
       , reserved = Set.empty
       }

pidParser: Parser String
pidParser =
    succeed identity
        |= digitsP
        |. end


pidGood s = (String.length s) == 9

validators: List (String, FieldValidator)
validators =
    [ ("byr", withParser Parser.int (\x -> (x >= 1920) && (x <= 2002)))
    , ("iyr", withParser Parser.int (\x -> (x >= 2010) && (x <= 2020)))
    , ("eyr", withParser Parser.int (\x -> (x >= 2020) && (x <= 2030)))
    , ("hgt", withParser hgtParser hgtGood)
    , ("hcl", withParser hclParser hclGood)
    , ("ecl", withParser
           (Parser.oneOf (List.map symbol ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]))
           (always True))
    , ("pid", withParser pidParser pidGood)        
    ]

validItem: (Dict String String) -> (String, FieldValidator) -> Bool
validItem pass (field, validator) =
    case Dict.get field pass of
        Nothing -> False
        Just value -> validator value
        
validatePass2: (Dict String String) -> Int
validatePass2 pass =
    let
        vres = List.map (validItem pass) validators
    in if List.all identity vres then 1 else 0

solve2 parsed =
    List.sum (List.map validatePass2 parsed)





