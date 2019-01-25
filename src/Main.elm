port module Main exposing (Model, Msg(..), User, init, main, save, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder, float, int, string)
import Json.Decode.Pipeline exposing (required)
import Debug



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
    { displayName : String, email : String, uid : String }


type alias Model =
    { voice : String, user : User }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "はじめてまして" (User "匿名" "email" "uid"), Cmd.none )


userDecoder : Decoder User
userDecoder =
    Decode.succeed User
        |> required "uid" string
        |> required "displayName" string
        |> required "email" string



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Submit String
    | Update String
    | Login String
    | UpdateUserName String
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

        LoggedInFromJS json ->
            let
                r =
                    json
                        |> Decode.decodeString userDecoder
                        |> Debug.log json

                -- decodeに成功したら、InputModelを。失敗したら元の値を返す。
                im =
                    case r of
                        Ok user ->
                            user

                        Err _ ->
                            User "失敗" "email" "uid"
            in
            ( { model | user = im }, Cmd.none )

        UpdateUserName m ->
            let
                user =
                    model.user

                new_user =
                    { user | displayName = m }
            in
            ( { model | user = new_user }, Cmd.none )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view { voice, user } =
    div []
        [ p [] [ text user.displayName ]
        , input [ type_ "text", value voice, onInput Update ] []
        , button [ onClick (Submit voice) ] [ text "SEND" ]
        , button [ onClick (Login voice) ] [ text "login" ]
        , viewUser user
        ]


viewUser : User -> Html Msg
viewUser { uid, displayName, email } =
    div []
        [ p [] [ text displayName ]
        , input [ type_ "text", value displayName, onInput UpdateUserName ] []
        , p [] [ text email ]
        , p [] [ text uid ]
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
        , subscriptions = \_ -> Sub.batch [ loginUser LoggedInFromJS ]
        }
