module Main exposing (..)

import BpmnIo as Wc
import Browser exposing (..)
import Html exposing (Attribute, Html, button, div, text)
import Html.Events exposing (onClick)
import Parsing exposing (..)
import Types exposing (..)


main =
    Browser.sandbox { init = init, update = update, view = view }


init : Model
init =
    { count = 0
    , clickedThing = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }

        ClickedActivity value ->
            { model | clickedThing = Just value }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.count) ]
        , button [ onClick Increment ] [ text "+" ]
        , Wc.view
            "1000px"
            "600px"
            [ ActivityStatus "Do_Something_Activity" model.count model.count
            , ActivityStatus "Start_Activity" 1 0
            ]
        , viewClickedBreadCrumb model
        ]


viewClickedBreadCrumb : Model -> Html Msg
viewClickedBreadCrumb model =
    case model.clickedThing of
        Just value ->
            div [] [ text ("Clicked " ++ processTypeToString value.elemType ++ " with id: " ++ value.id) ]

        Nothing ->
            div [] [ text "Nothing clicked yet" ]
