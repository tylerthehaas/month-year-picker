module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL


type alias Model =
    { showPicker : Bool
    , month : String
    , year : Int
    }


init : ( Model, Cmd msg )
init =
    (Model False "" 2017) ! []



-- UPDATE


type Msg month
    = UpdateMonth month
    | TogglePicker


update : Msg String -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        UpdateMonth month ->
            ({ model | month = month, showPicker = not model.showPicker }) ! []

        TogglePicker ->
            ({ model | showPicker = not model.showPicker }) ! []



-- VIEW


abbreviatedMonths : List ( String, String )
abbreviatedMonths =
    [ ( "01", "Jan." )
    , ( "02", "Feb." )
    , ( "03", "Mar." )
    , ( "04", "Apr." )
    , ( "05", "May" )
    , ( "06", "Jun." )
    , ( "07", "Jul." )
    , ( "08", "Aug." )
    , ( "09", "Sep." )
    , ( "10", "Oct." )
    , ( "11", "Nov." )
    , ( "12", "Dec." )
    ]


view : Model -> Html (Msg String)
view model =
    let
        result =
            if String.isEmpty model.month then
                ""
            else
                model.month ++ "/" ++ (toString model.year)

        resultInput =
            input
                [ type_ "text"
                , value result
                , onFocus TogglePicker
                ]
                []
    in
        if model.showPicker then
            div [ class "month-picker-overlay" ]
                [ resultInput
                , monthPickerHeaderView model
                , monthPickerMonthTable model
                ]
        else
            div [ class "month-picker-overlay" ]
                [ resultInput ]


monthPickerMonthTable : Model -> Html (Msg String)
monthPickerMonthTable model =
    div [ class "month-picker-month-table" ]
        (List.map
            (\m ->
                button
                    [ class "btn btn-default"
                    , onClick <|
                        UpdateMonth <|
                            Tuple.first m
                    ]
                    [ text (Tuple.second m) ]
            )
            abbreviatedMonths
        )


monthPickerHeaderView : Model -> Html msg
monthPickerHeaderView model =
    div [ class "month-picker-header" ]
        [ div [ class "month-picker-year" ]
            [ div []
                [ a [ class "btn btn-default month-picker-previous" ]
                    [ span [ class "fa fa-caret-left" ] [] ]
                , a [ class "btn btn-default month-picker-title" ]
                    [ text ("Year " ++ (toString model.year)) ]
                , a [ class "month-picker-next" ]
                    [ span [ class "fa fa-caret-right" ] [] ]
                ]
            ]
        ]



-- MAIN


main : Program Never Model (Msg String)
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
