module Main exposing (..)

import Html exposing (..)


type Msg
    = RequestPackageCounts


type alias Model =
    { packageCounts : List Int
    }


init : ( Model, Cmd Msg )
init =
    ( { packageCounts = [] }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestPackageCounts ->
            model ! []


view : Model -> Html msg
view model =
    section [] [ text "blah" ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
