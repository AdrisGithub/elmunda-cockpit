module Main exposing (main)

import BpmnIo as Wc
import Browser
import Browser.Navigation as Navigation
import Html exposing (Html, a, br, button, div, li, p, text)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import Parsing exposing (errorToString, processTypeToString, statusResponseDecoder)
import Types exposing (ActivityLoading(..), BpmnLoading(..), Flags, Model, Msg(..))
import Url


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url nav =
    ( { clickedThing = Nothing
      , bpmn = Loading
      , apiUrl = flags.apiUrl
      , activities = ALoading
      , key = nav
      , url = url
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

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "Elmunda Cockpit"
    , body =
        [ viewBpmn model
        , div [] [ text (viewClickedBreadCrumb model) ]
        , button [ onClick Reload ] [ text "Reload" ]
        , br [] []
        , div []
            [ a [ href "/home" ] [ text "/home" ]
            , p [] [ text (Url.toString model.url) ]
            , a [ href "/idk" ] [ text "/idk" ]
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
