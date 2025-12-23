module Types exposing (..)


type Msg
    = Increment
    | Decrement
    | ClickedActivity String


type alias Model =
    Int


type alias ActivityStatus =
    { name : String
    , errors : Int
    , instances : Int
    }


type alias ClickEvent =
    { id : String
    , elemType : String
    }
