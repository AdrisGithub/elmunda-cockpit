module Main exposing (main)

import BpmnIo as Wc
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http
import Parsing exposing (errorToString, processTypeToString, statusResponseDecoder)
import Types exposing (ActivityLoading(..), BpmnLoading(..), Model, Msg(..))


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { clickedThing = Nothing
      , bpmn = Loading
      , activities = ALoading
      }
    , Http.get
        { url = "http://localhost:8080/test.xml"
        , expect = Http.expectString LoadBpmn
        }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedActivity value ->
            ( { model | clickedThing = Just value }, Cmd.none )

        LoadBpmn bpmn ->
            case bpmn of
                Ok value ->
                    ( { model | bpmn = Success value }
                    , Http.get
                        { url = "http://localhost:8080/instances.json"
                        , expect = Http.expectJson LoadActivities statusResponseDecoder
                        }
                    )

                Err error ->
                    ( { model | bpmn = Error error }, Cmd.none )

        LoadActivities activities ->
            case activities of
                Ok value ->
                    ( { model | activities = ASuccess value.instances }, Cmd.none )

                Err error ->
                    ( { model | activities = AError error }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ viewBpmn model
        , div [] [ text (viewClickedBreadCrumb model) ]
        ]


viewBpmn : Model -> Html Msg
viewBpmn model =
    case model.bpmn of
        Success a ->
            case model.activities of
                ASuccess value ->
                    Wc.view
                        "1000px"
                        "600px"
                        value
                        a

                AError error ->
                    div [] [ text (errorToString error) ]

                ALoading ->
                    div [] [ text "Loading..." ]

        Error err ->
            div [] [ text (errorToString err) ]

        Loading ->
            div [] [ text "Loading..." ]


viewClickedBreadCrumb : Model -> String
viewClickedBreadCrumb model =
    case model.clickedThing of
        Just value ->
            "Clicked " ++ processTypeToString value.elemType ++ " with id: " ++ value.id

        Nothing ->
            "Nothing clicked yet"
