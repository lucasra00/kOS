clearScreen.

print "Starting orbit.ks".
print "Rising orbit to 100km".

lock steering to heading(90, 0, 0).

lock throttle to 0.
if stage:liquidfuel < 5 {
    stage.
}

intoOrbitBurn.
wait 5.

//Funktions

function intoOrbitBurn {
    set disHeight to 100000.                                        //Disired altitude.
    set vAtHeight to (sqrt(constant:g0*(kerbin:radius+disHeight))). //Calculate the speed at disired altitude.
    set dV to (vAtHeight-(sqrt(ship:velocity:orbit:mag^2+2*constant:g0*(apoapsis-ship:altitude)))).   //Calculate the deltaV needed to orbit. The last bit is just physiscs;-)
    set a to (maxThrust/ship:mass).                                 //Estemate on the acceleration (start a)
    set t_start to (dV/(2*a))-1.                                    //Calculate the start time for the burn.

    wait until (eta:apoapsis <= t_start).
    lock throttle to 1.

    wait until (ship:periapsis >= (disHeight-1000)).
        lock throttle to 0.1.
    

    wait until (ship:periapsis >= disHeight).
        lock throttle to 0.
    

    print "Into orbit burn complete.".
    print "Finale altitudes:".
    print "Apoapsis:  " + ship:apoapsis.
    print "Periapsis: " + ship:periapsis.
}

function node_apo {

set bt to orbitburn:deltav:mag/ship:mass.

    until eta:apoapsis <= 5+bt/2 {
        set dV to (vAtHeight-(sqrt(ship:velocity:orbit:mag^2+2*constant:g0*(apoapsis-ship:altitude)))).
        set orbitburn to node(time:seconds+eta:apoapsis, 0, 0, dV).
        lock steering to orbitburn.
        set a to (maxThrust/ship:mass). 
        set bt to orbitburn:deltav:mag/ship:mass.
    }

    wait until vang(orbitburn,ship:facing) <0.25. and 
    


}


