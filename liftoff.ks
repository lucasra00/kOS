clearScreen.
print "Starting countdown:".
from {local countdown is 5.} until countdown = 0 step {set countdown to countdown - 1.} do {
    PRINT countdown.
    wait 1.
}

lock throttle to 1.
lock steering to UP.
wait 0.1.
stage.

wait until ((ship:altitude - 68) > 50).

print "We have lift-off!".

runPath("asent.ks").
