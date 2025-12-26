module Types exposing (ActivityLoading(..), ActivityStatus, ActivityStatusResponse, BpmnLoading(..), ClickEvent, Flags, Model, Msg(..), ProcessType(..))

import Http


type Msg
    = ClickedActivity ClickEvent
    | LoadBpmn (Result Http.Error String)
    | LoadActivities (Result Http.Error ActivityStatusResponse)
    | Reload
    | FlipColorScheme


type alias Flags =
    { apiUrl : String
    , darkMode : Bool
    }


type alias Model =
    { clickedThing : Maybe ClickEvent
    , bpmn : BpmnLoading
    , apiUrl : String
    , activities : ActivityLoading
    , isLight : Bool
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
