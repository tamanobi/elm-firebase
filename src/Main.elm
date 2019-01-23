port module Main exposing (Model, Msg(..), init, main, save, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode



-- ---------------------------
-- PORTS
-- ---------------------------


port save : Model -> Cmd msg


port fromJs : (Int -> msg) -> Sub msg



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { voice : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "はじめてまして", Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Submit String
    | Update String


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Update m ->
            ( { model | voice = m }, Cmd.none )

        Submit m ->
            let
                new =
                    { model | voice = m }
            in
            ( new, save new )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view { voice } =
    div []
        [ p [] [ text "a" ]
        , input [ type_ "text", value voice, onInput Update ] []
        , button [ onClick (Submit voice) ] [ text "SEND" ]
        ]



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Elm 0.19 starter"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        }
