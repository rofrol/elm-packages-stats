module Chart exposing (chart)

import Svg exposing (Svg)
import Model exposing (Entry)
import Date exposing (toTime)
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
import LineChart.Axis.Line as AxisLine
import LineChart.Axis.Ticks as Ticks
import LineChart.Axis.Tick as Tick
import LineChart.Axis.Title as Title
import LineChart.Axis.Range as Range
import LineChart.Coordinate as Coordinate


timeAxis : Axis.Config { a | date : Date.Date } msg
timeAxis =
    Axis.custom
        { title = Title.default ""
        , variable = (.date >> toTime >> Just)
        , pixels = 1270
        , range = Range.padded 20 20
        , axisLine = AxisLine.default
        , ticks = Ticks.timeCustom 6 Tick.time
        }


chartConfig : List Entry -> LineChart.Config Entry msg
chartConfig entries =
    { y = Axis.default 450 "Count" .count
    , x = timeAxis
    , container = Container.default "line-chart-1"
    , interpolation = Interpolation.default
    , intersection = Intersection.default
    , legends = Legends.none
    , events = Events.default
    , junk = Junk.default
    , grid = Grid.default
    , area = Area.default
    , line = Line.default
    , dots = Dots.default
    }


chart : List Entry -> Svg msg
chart entries =
    LineChart.viewCustom (chartConfig entries)
        [ LineChart.line Colors.blue Dots.circle "Packages" entries ]
