module BpmnIo exposing (..)

import Html exposing (Attribute, Html, div)
import Html.Attributes as Attributes
import Json.Encode as Encode


type alias ActivityStatus =
    { name : String
    , errors : Int
    , instances : Int
    }


statusToJson : ActivityStatus -> Encode.Value
statusToJson state =
    Encode.object
        [ ( "name", Encode.string state.name )
        , ( "errors", Encode.int state.errors )
        , ( "instances", Encode.int state.instances )
        ]


bpmnIoWc : List (Attribute msg) -> List (Html msg) -> Html msg
bpmnIoWc =
    Html.node "bpmn-io-wc"


width : String -> Attribute msg
width value =
    Attributes.property "width" (Encode.string value)


height : String -> Attribute msg
height value =
    Attributes.property "height" (Encode.string value)


status : List ActivityStatus -> Attribute msg
status value =
    Attributes.property "activity_status" (Encode.list statusToJson value)


view : String -> String -> List ActivityStatus -> Html msg
view internalWidth internalHeight states =
    div
        [ Attributes.style "border" "1px solid black"
        , Attributes.style "width" internalWidth
        , Attributes.style "height" internalHeight
        ]
        [ bpmnIoWc
            [ width internalWidth
            , height internalHeight
            , status states
            ]
            []
        ]
