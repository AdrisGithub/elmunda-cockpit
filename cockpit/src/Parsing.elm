module Parsing exposing (..)

import Http
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


statusDecoder : Decode.Decoder ActivityStatus
statusDecoder =
    Decode.succeed ActivityStatus
        |> required "name" Decode.string
        |> required "errors" Decode.int
        |> required "instances" Decode.int


statusResponseDecoder : Decode.Decoder ActivityStatusResponse
statusResponseDecoder =
    Decode.succeed ActivityStatusResponse
        |> required "instances" (Decode.list statusDecoder)


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


errorToString : Http.Error -> String
errorToString error =
    case error of
        Http.BadUrl url ->
            "The URL " ++ url ++ " was invalid"

        Http.Timeout ->
            "Unable to reach the server, try again"

        Http.NetworkError ->
            "Unable to reach the server, check your network connection"

        Http.BadStatus 500 ->
            "The server had a problem, try again later"

        Http.BadStatus 400 ->
            "Verify your information and try again"

        Http.BadStatus _ ->
            "Unknown error"

        Http.BadBody errorMessage ->
            errorMessage
