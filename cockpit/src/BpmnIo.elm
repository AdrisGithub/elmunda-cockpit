module BpmnIo exposing (view)

import Html exposing (Attribute, Html, div)
import Html.Attributes as Attributes
import Html.Events exposing (on)
import Json.Decode as Decode
import Json.Encode as Encode
import Parsing exposing (..)
import Types exposing (..)


bpmnIoWc : List (Attribute msg) -> List (Html msg) -> Html msg
bpmnIoWc =
    Html.node "bpmn-io-wc"


width : String -> Attribute msg
width value =
    value
        |> Encode.string
        |> Attributes.property "width"


height : String -> Attribute msg
height value =
    value
        |> Encode.string
        |> Attributes.property "height"


status : List ActivityStatus -> Attribute msg
status value =
    value
        |> Encode.list statusToJson
        |> Attributes.property "activity_status"


onClick : (ClickEvent -> Msg) -> Attribute Msg
onClick tag =
    on "bpmnClick" (Decode.map tag (Decode.at [ "detail", "element" ] clickDecoder))


view : String -> String -> List ActivityStatus -> Html Msg
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
            , onClick ClickedActivity
            ]
            []
        ]
