module Main exposing (main)

import BpmnIo as Wc
import Browser exposing (Document)
import Html exposing (Html, article, button, div, text)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick)
import Http
import Parsing exposing (errorToString, processTypeToString, statusResponseDecoder)
import Types exposing (ActivityLoading(..), BpmnLoading(..), Flags, Model, Msg(..))


main : Program Flags Model Msg
main =
    Browser.document { init = init, update = update, subscriptions = subscriptions, view = view }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { clickedThing = Nothing
      , bpmn = Loading
      , apiUrl = flags.apiUrl
      , activities = ALoading
      , isLight = True
      }
    , getBpmnContent flags.apiUrl
    )


getBpmnContent : String -> Cmd Msg
getBpmnContent url =
    Http.get
        { url = url ++ "test.xml"
        , expect = Http.expectString LoadBpmn
        }


getInstances : String -> Cmd Msg
getInstances url =
    Http.get
        { url = url ++ "instances.json"
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
                    ( { model | bpmn = Success value }, getInstances model.apiUrl )

                Err error ->
                    ( { model | bpmn = Error error }, Cmd.none )

        LoadActivities activities ->
            case activities of
                Ok value ->
                    ( { model | activities = ASuccess value.instances }, Cmd.none )

                Err error ->
                    ( { model | activities = AError error }, Cmd.none )

        Reload ->
            ( { model | activities = ALoading, bpmn = Loading }, getBpmnContent model.apiUrl )

        FlipColorScheme ->
            ( { model | isLight = not model.isLight }, Cmd.none )


setTheme : Bool -> String
setTheme bool =
    if bool then
        "light"

    else
        "dark"


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Document Msg
view model =
    { title = "Elmunda Cockpit"
    , body =
        [ article [ attribute "data-theme" "light" ]
            [ viewBpmn model
            , div [] [ text (viewClickedBreadCrumb model) ]
            , button [ onClick Reload ] [ text "Reload" ]
            , button [ onClick FlipColorScheme ] [ text "Flip Color Scheme" ]
            ]
        ]
    }


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
