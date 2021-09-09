//This script counts down from 5, launches the rocket (using one stage) and waits a little before running different script.

clearScreen.
print "Starting countdown:".
from {local countdown is 5.} until countdown = 0 step {set countdown to countdown - 1.} do {
    clearScreen.
    PRINT countdown.
    wait 1.
}
clearScreen.

lock throttle to 1.
lock steering to heading(90, 90, 0).
wait 0.1.
stage.

wait until ((ship:altitude - 68) > 50).

print "We have lift-off!".

wait 1.

runPath("asent.ks").
