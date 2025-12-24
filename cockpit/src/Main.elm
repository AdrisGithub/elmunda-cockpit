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
    , getBpmnContent
    )


getBpmnContent : Cmd Msg
getBpmnContent =
    Http.get
        { url = "http://localhost:8080/test.xml"
        , expect = Http.expectString LoadBpmn
        }


getInstances : Cmd Msg
getInstances =
    Http.get
        { url = "http://localhost:8080/instances.json"
        , expect = Http.expectJson LoadActivities statusResponseDecoder
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedActivity value ->
            ( { model | clickedThing = Just value }, Cmd.none )

        LoadBpmn bpmn ->
            case bpmn of
                Ok value ->
                    ( { model | bpmn = Success value }, getInstances )

                Err error ->
                    ( { model | bpmn = Error error }, Cmd.none )

        LoadActivities activities ->
            case activities of
                Ok value ->
                    ( { model | activities = ASuccess value.instances }, Cmd.none )

                Err error ->
                    ( { model | activities = AError error }, Cmd.none )

        Reload ->
            ( { model | activities = ALoading, bpmn = Loading }, getBpmnContent )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ viewBpmn model
        , div [] [ text (viewClickedBreadCrumb model) ]
        , button [ onClick Reload ] [ text "Reload" ]
        ]


viewBpmn : Model -> Html Msg
viewBpmn model =
    case model.bpmn of
        Success a ->
            viewActivity a model

        Error err ->
            div [] [ text (errorToString err) ]

        Loading ->
            div [] [ text "Loading..." ]


viewActivity : String -> Model -> Html Msg
viewActivity bpmn model =
    case model.activities of
        ASuccess value ->
            Wc.view
                "1000px"
                "600px"
                value
                bpmn

        AError error ->
            div [] [ text (errorToString error) ]

        ALoading ->
            div [] [ text "Loading..." ]


viewClickedBreadCrumb : Model -> String
viewClickedBreadCrumb model =
    case model.clickedThing of
        Just value ->
            "Clicked " ++ processTypeToString value.elemType ++ " with id: " ++ value.id

        Nothing ->
            "Nothing clicked yet"
