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
import Date exposing (Date)
import Time exposing (Time)


-- MOCK DATA


type alias Entry =
    { date : Time
    , count : Float
    }


type Msg
    = RequestPackageCounts


type alias Model =
    { packageCounts : List Entry
    }


init : ( Model, Cmd Msg )
init =
    ( { packageCounts = [ { date = 10 * Time.second, count = 222 } ] }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestPackageCounts ->
            model ! []


view : Model -> Html Msg
view model =
    section [] [ chart model.packageCounts ]


chartConfig : List Entry -> LineChart.Config Entry Msg
chartConfig entries =
    { y = Axis.default 450 "Count" .count
    , x = Axis.time 1270 "Date" .date
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
