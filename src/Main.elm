module Main exposing (..)

import Browser
import Html exposing (Html, div, text, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Day12 exposing (parse, solve1, solve2)

-- MAIN

main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL

type alias Model = String

init : Model
init = ""

-- UPDATE


type Msg = Change String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent -> newContent

-- view
parserSolver: (String -> Maybe x) -> (x -> Int) -> String -> String
parserSolver parser solver content =
    (parser content)
        |> Maybe.map (solver >> String.fromInt)
        |> Maybe.withDefault "Could not parse input"

view : Model -> Html Msg
view model =
  div []
    [ textarea [ cols 40, rows 10, placeholder "", onInput Change ] []
    , div [] [ text (parserSolver parse solve1 model) ]
    , div [] [ text (parserSolver parse solve2 model) ]
    ]
