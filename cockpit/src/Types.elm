module Types exposing (..)

import Http


type Msg
    = Increment
    | Decrement
    | ClickedActivity ClickEvent
    | LoadBpmn (Result Http.Error String)
    | LoadActivities (Result Http.Error ActivityStatusResponse)


type alias Model =
    { count : Int
    , clickedThing : Maybe ClickEvent
    , bpmn : BpmnLoading
    , activities : ActivityLoading
    }


type ActivityLoading
    = ALoading
    | AError Http.Error
    | ASuccess (List ActivityStatus)


type BpmnLoading
    = Loading
    | Error Http.Error
    | Success String


type alias ActivityStatus =
    { name : String
    , errors : Int
    , instances : Int
    }


type alias ActivityStatusResponse =
    { instances : List ActivityStatus
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
