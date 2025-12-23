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


type alias ActivityStatus =
    { name : String
    , errors : Int
    , instances : Int
    }


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


wcStatus : List ActivityStatus -> Attribute msg
wcStatus status =
    Attributes.property "activity_status" (Encode.list statusToJson status)


statusToJson : ActivityStatus -> Encode.Value
statusToJson status =
    Encode.object
        [ ( "name", Encode.string status.name )
        , ( "errors", Encode.int status.errors )
        , ( "instances", Encode.int status.instances )
        ]


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        , bpmnIoWc
            [ wcWidth "2000px"
            , wcHeight "1000px"
            , wcStatus
                [ ActivityStatus "Do_Something_Activity" model model
                , ActivityStatus "Start_Activity" 1 0
                ]
            ]
            []
        ]
