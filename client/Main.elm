module Main exposing (..)

import Html exposing (Html)
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
import Style exposing (..)
import Style.Scale as Scale
import Color
import Style.Color as Color
import Style.Font as Font
import Element exposing (..)
import Element.Attributes exposing (..)


-- MOCK DATA


type alias Entry =
    { date : Time
    , count : Float
    }



-- STYLESHEET (USING STYLE-ELEMENTS)


scale : Int -> Float
scale =
    Scale.modular 16 1.618


type MyStyles
    = Title
    | ElContainer
    | None


stylesheet : StyleSheet MyStyles variation
stylesheet =
    Style.styleSheet
        [ style Title
            [ Color.text Color.darkCharcoal
            , Font.size (scale 3)
            ]
        , style ElContainer
            []
        ]


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


type Spacing
    = Large
    | XLarge
    | XXLarge
    | Base
    | Small
    | XSmall
    | XXSmall


mySpacing : Spacing -> Float
mySpacing size =
    let
        num =
            case size of
                Large ->
                    5

                XLarge ->
                    6

                XXLarge ->
                    7

                Base ->
                    4

                Small ->
                    3

                XSmall ->
                    2

                XXSmall ->
                    1
    in
        scale num


view : Model -> Html Msg
view model =
    Element.layout stylesheet <|
        column None
            [ center ]
            [ row ElContainer
                [ spacingXY (mySpacing Small) (mySpacing Large) ]
                [ el Title [] (text "Elm Package Counts")
                ]
            , row ElContainer
                []
                [ chart model.packageCounts
                ]
            ]


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


chart : List Entry -> Element MyStyles variation Msg
chart entries =
    html <|
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
