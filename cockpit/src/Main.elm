module Main exposing (..)

import Browser
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes as Attributes
import Html.Events exposing (onClick)
import Json.Encode as Encode


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    Int


init : Model
init =
    0


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


bpmnIoWc : List (Attribute msg) -> List (Html msg) -> Html msg
bpmnIoWc =
    Html.node "bpmn-io-wc"


wcWidth : String -> Attribute msg
wcWidth width =
    Attributes.property "width" (Encode.string width)


wcHeight : String -> Attribute msg
wcHeight height =
    Attributes.property "height" (Encode.string height)


wcCount : Int -> Attribute msg
wcCount count =
    Attributes.property "count" (Encode.int count)


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        , bpmnIoWc
            [ wcWidth "2000px"
            , wcHeight "1000px"
            , wcCount model
            ]
            []
        ]
