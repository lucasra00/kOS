
clearScreen.

print "Running cicular_orbit.ks".
declare global disHight to 100000.
Print "Desired hight is: " + disHight + " meter".

risePeri.
riseApo.

wait 1.

//Functions

function risePeri {
    wait until eta:apoapsis<=30.
    set warp to 0.
    lock steering to ship:velocity:orbit.
    wait until eta:apoapsis<=1.
    lock throttle to 0.1.
    wait until alt:apoapsis>=(disHight-1000).
    lock throttle to 0.05. 
    wait until alt:apoapsis>=(disHight-500).
    lock throttle to 0.01.
    wait until alt:apoapsis>=(disHight-1).
    lock throttle to 0.
    unlock throttle.
    unlock steering.
    print "Temporary  Apoapsis: " + alt:apoapsis.
    print "Temporary Periapsis: " + alt:periapsis.
}

function riseApo {
    wait until eta:apoapsis<=30.
    set warp to 0.
    lock steering to ship:velocity:orbit.
    wait until ship:altitude=alt:apoapsis.
    lock throttle to 0.1.
    wait until alt:periapsis>=(disHight-1000).
    lock throttle to 0.03.
    wait until alt:periapsis>=(disHight-500).
    lock throttle to 0.005.
    wait until alt:periapsis>=(disHight-1).
    lock throttle to 0.
    unlock throttle.
    unlock steering.
    print "Fianl  Apoapsis: " + alt:apoapsis.
    print "Final Periapsis: " + alt:periapsis.
}


