module Types exposing (..)

import Http


type Msg
    = Increment
    | Decrement
    | ClickedActivity ClickEvent
    | LoadBpmn (Result Http.Error String)


type alias Model =
    { count : Int
    , clickedThing : Maybe ClickEvent
    , bpmn : BpmnLoading
    }


type BpmnLoading
    = Loading
    | Error Http.Error
    | Success String


type alias ActivityStatus =
    { name : String
    , errors : Int
    , instances : Int
    }


type ProcessType
    = ServiceTask
    | Process
    | EndEvent
    | StartEvent


type alias ClickEvent =
    { id : String
    , elemType : ProcessType
    }
