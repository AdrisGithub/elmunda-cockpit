module Main exposing (init, main, update, view)

import BpmnIo as Wc
import Browser exposing (..)
import Html exposing (Attribute, Html, button, div, text)
import Html.Events exposing (onClick)
import Http
import Parsing exposing (..)
import Types exposing (..)


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { count = 0
      , clickedThing = Nothing
      , bpmn = Nothing
      }
    , Http.get
        { url = "http://localhost:8080/test.xml"
        , expect = Http.expectString LoadBpmn
        }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )

        ClickedActivity value ->
            ( { model | clickedThing = Just value }, Cmd.none )

        LoadBpmn bpmn ->
            case bpmn of
                Ok value ->
                    ( { model | bpmn = Just value }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


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
        , div [] [ text (viewClickedBreadCrumb model) ]
        ]


viewClickedBreadCrumb : Model -> String
viewClickedBreadCrumb model =
    case model.clickedThing of
        Just value ->
            "Clicked " ++ processTypeToString value.elemType ++ " with id: " ++ value.id

        Nothing ->
            "Nothing clicked yet"
