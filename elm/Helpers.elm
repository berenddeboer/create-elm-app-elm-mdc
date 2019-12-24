module Helpers exposing (cmd)

import Task

cmd : msg -> Cmd msg
cmd msg =
    Task.perform identity (Task.succeed msg)
