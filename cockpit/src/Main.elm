module Main exposing (..)

import BpmnIo as Wc exposing (ActivityStatus)
import Browser exposing (..)
import Html exposing (Attribute, Html, button, div, text)
import Html.Events exposing (onClick)


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


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        , Wc.view
            "1000px"
            "600px"
            [ ActivityStatus "Do_Something_Activity" model model
            , ActivityStatus "Start_Activity" 1 0
            ]
        ]
