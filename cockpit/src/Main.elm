module Main exposing (..)

import BpmnIo as Wc
import Browser exposing (..)
import Html exposing (Attribute, Html, button, div, text)
import Html.Events exposing (onClick)
import Types exposing (..)


main =
    Browser.sandbox { init = init, update = update, view = view }


init : Model
init =
    0


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1

        ClickedActivity _ ->
            model


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
