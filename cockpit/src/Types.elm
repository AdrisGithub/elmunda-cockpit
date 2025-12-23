module Types exposing (..)


type Msg
    = Increment
    | Decrement
    | ClickedActivity ClickEvent


type alias Model =
    Int


type alias ActivityStatus =
    { name : String
    , errors : Int
    , instances : Int
    }


type ProcessType
    = ServiceTask
    | Process


type alias ClickEvent =
    { id : String
    , elemType : ProcessType
    }
