module Example exposing (viewTest)

import Expect exposing (Expectation)
import Main exposing (..)

import Test exposing (..)



import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, text)


{-| see <https://github.com/eeue56/elm-html-test>
-}
viewTest : Test
viewTest =
    describe "Testing view function"
        [ test "Button has the expected text" <|
            \() ->
                view (Model "string" (User "匿名" "" "uid"))
                    |> Query.fromHtml
                    |> Query.findAll [ tag "button" ]
                    |> Query.count ( Expect.equal 2 )
        ]
