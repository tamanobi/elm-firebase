port module Main exposing (Model, Msg(..), User, init, main, save, update, view)

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


port login : Model -> Cmd msg


port loginUser : (String -> msg) -> Sub msg



-- ---------------------------
-- MODEL
-- ---------------------------


type UserStatus
    = LoggedOut
    | LoggedIn


type alias User =
    { name : String, email : String }


type alias Model =
    { voice : String, user : User }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "はじめてまして" (User "匿名" ""), Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Submit String
    | Update String
    | Login String
    | LoggedInFromJS String


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

        Login m ->
            ( model, login model )

        LoggedInFromJS s ->
            let
                user =
                    model.user

                new_user =
                    { user | name = s }
            in
            ( { model | user = new_user }, Cmd.none )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view { voice, user } =
    div []
        [ p [] [ text user.name ]
        , input [ type_ "text", value voice, onInput Update ] []
        , button [ onClick (Submit voice) ] [ text "SEND" ]
        , button [ onClick (Login voice) ] [ text "login" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



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
        , subscriptions = \_ -> Sub.batch [ loginUser LoggedInFromJS ]
        }
