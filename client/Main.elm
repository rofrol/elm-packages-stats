module Main exposing (..)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Svg.Styled as Svg
import Html.Styled.Attributes exposing (css)
import Date exposing (Date, toTime)
import Http
import Model exposing (Entry, Model, decodePackageCounts)
import Chart exposing (chart)
import Svg


-- MOCK DATA


type Msg
    = RequestPackageCounts
    | LoadPackageCounts (Result Http.Error (List Entry))


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


view : Model -> Html.Html Msg
view model =
    toUnstyled <|
        main_
            [ css
                [ displayFlex
                , (alignItems center)
                , flexDirection column
                ]
            ]
            [ h1 [] [ text "Elm Package Counts" ]
            , case model.error of
                Just err ->
                    displayError err

                Nothing ->
                    Svg.fromUnstyled (chart model.packageCounts)
            ]


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
