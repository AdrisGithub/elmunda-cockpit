module Parsing exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Types exposing (..)


statusToJson : ActivityStatus -> Encode.Value
statusToJson state =
    Encode.object
        [ ( "name", Encode.string state.name )
        , ( "errors", Encode.int state.errors )
        , ( "instances", Encode.int state.instances )
        ]


clickDecoder : Decode.Decoder ClickEvent
clickDecoder =
    Decode.succeed ClickEvent
        |> required "id" Decode.string
        |> required "type" typeDecoder


typeDecoder : Decode.Decoder ProcessType
typeDecoder =
    Decode.string
        |> Decode.andThen decodeProcessType


decodeProcessType : String -> Decode.Decoder ProcessType
decodeProcessType raw =
    case raw of
        "bpmn:Process" ->
            Decode.succeed Process

        "bpmn:ServiceTask" ->
            Decode.succeed ServiceTask

        "bpmn:EndEvent" ->
            Decode.succeed EndEvent

        "bpmn:StartEvent" ->
            Decode.succeed StartEvent

        _ ->
            Decode.fail "Invalid ProcessType"


processTypeToString : ProcessType -> String
processTypeToString process =
    case process of
        ServiceTask ->
            "ServiceTask"

        Process ->
            "Process"

        EndEvent ->
            "EndEvent"

        StartEvent ->
            "StartEvent"
