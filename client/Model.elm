module Model exposing (Model, Entry, decodePackageCounts)

import Date exposing (Date, toTime)
import Json.Decode as Decode exposing (Decoder, field, list)
import Json.Decode.Extra exposing (date)


type alias Entry =
    { date : Date
    , count : Float
    }


type alias Model =
    { packageCounts : List Entry
    , error : Maybe String
    }


decodeEntry : Decoder Entry
decodeEntry =
    Decode.map2 Entry
        (field "date" date)
        (field "count" Decode.float)


decodePackageCounts : Decode.Decoder (List Entry)
decodePackageCounts =
    (list decodeEntry)
