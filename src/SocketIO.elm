module SocketIO where

{-| A module for working with [Socket.io](http://socket.io/) servers. This
    module uses Socket.io 1.3.5.

    Compared to native JavaScript, this library is limited in its ability to
    dynamically change hosts, and can only send and receive strings.

# Creating a Socket
Avoid creating signals of sockets.
@docs io, Options, defaultOptions

# Sending and Receiving
These functions should be used with `Task.andThen` to provide a socket obtained
with `io`.
@docs emit, on, connected
-}

import Time
import Task
import Native.SocketIO

type Socket = Socket

{-| A type for options on a socket. See the [Socket.io docs](http://socket.io/docs/client-api/)
    for further explanation.
-}
type alias Options =
    {multiplex : Bool,
     reconnection : Bool,
     reconnectionDelay : Time.Time,
     reconnectionDelayMax : Time.Time,
     timeout : Time.Time}

{-| Default options for a new socket and manager. These are the same as
    Socket.io itself. -}
defaultOptions : Options
defaultOptions =
    Options False True 1000 500 20000

{-| Create a socket, given a hostname and options.

    socket = SocketIO.io "http://localhost:8001" SocketIO.defaultOptions

It's possible to run the Elm Reactor and your Socket.io node server
simultanesouly on different ports.
-}
io : String -> Options -> Task.Task x Socket
io = Native.SocketIO.io

{-| Send a string on the socket using the given event name. To serialize your
    Elm values, use `toString` or `JSON.Encode`.
-}
emit : String -> String -> Socket -> Task.Task x ()
emit = Native.SocketIO.emit

{-| Receive data of the given event name at a mailbox as a string. If data
    received is not already a string, it will be JSON-encoded. Unserializable JS
    values become `"null"`; this is a good initial value when you set up the
    mailbox. -}
on : String -> Signal.Address String -> Socket -> Task.Task x ()
on = Native.SocketIO.on

{-| Set up a signal of bools indicating whether or not the socket is connected.
    You should initialize the mailbox to `False`; if the server is available a
    `True` event will be sent almost immediately. If the server is not
    available, `io` will not complete and therefore this task will not run. If
    the socket disconnects (and then reconnects later), the created signal will
    have an event indicating that.
-}
connected : Signal.Address Bool -> Socket -> Task.Task x ()
connected = Native.SocketIO.connected

