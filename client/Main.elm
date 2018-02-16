module Main exposing (..)

import Html exposing (..)
import LineChart
import LineChart.Axis as Axis
import LineChart.Area as Area
import LineChart.Junk as Junk
import LineChart.Dots as Dots
import LineChart.Grid as Grid
import LineChart.Dots as Dots
import LineChart.Line as Line
import LineChart.Colors as Colors
import LineChart.Events as Events
import LineChart.Legends as Legends
import LineChart.Container as Container
import LineChart.Interpolation as Interpolation
import LineChart.Axis.Intersection as Intersection
import Date exposing (Date, toTime)
import Http
import Json.Decode exposing (Decoder, field, list, float)
import Json.Decode.Extra exposing (date)


-- MOCK DATA


type alias Entry =
    { date : Date
    , count : Float
    }


type Msg
    = RequestPackageCounts
    | LoadPackageCounts (Result Http.Error (List Entry))


type alias Model =
    { packageCounts : List Entry
    , error : Maybe String
    }


decodeEntry : Decoder Entry
decodeEntry =
    Json.Decode.map2 Entry
        (field "date" date)
        (field "count" float)


decodePackageCounts : Json.Decode.Decoder (List Entry)
decodePackageCounts =
    (list decodeEntry)


requestPackageCounts : Cmd Msg
requestPackageCounts =
    Http.get "http://localhost:8002/" decodePackageCounts
        |> Http.send LoadPackageCounts


init : ( Model, Cmd Msg )
init =
    { packageCounts = [], error = Nothing } ! [ requestPackageCounts ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestPackageCounts ->
            model ! []

        LoadPackageCounts (Ok entries) ->
            { model | packageCounts = entries } ! []

        LoadPackageCounts err ->
            { model | error = Just <| "Could not get package counts from server. Error was: " ++ (toString err) } ! []


displayError : String -> Html Msg
displayError error =
    text error


view : Model -> Html Msg
view model =
    main_
        []
        [ h1 [] [ text "Elm Package Counts" ]
        , case model.error of
            Just err ->
                displayError err

            Nothing ->
                chart model.packageCounts
        ]


chartConfig : List Entry -> LineChart.Config Entry Msg
chartConfig entries =
    { y = Axis.default 450 "Count" .count
    , x = Axis.time 1270 "Date" (.date >> toTime)
    , container = Container.default "line-chart-1"
    , interpolation = Interpolation.default
    , intersection = Intersection.default
    , legends = Legends.default
    , events = Events.default
    , junk = Junk.default
    , grid = Grid.default
    , area = Area.default
    , line = Line.default
    , dots = Dots.default
    }


chart : List Entry -> Html Msg
chart entries =
    LineChart.viewCustom (chartConfig entries)
        [ LineChart.line Colors.blue Dots.circle "Packages" entries ]


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
