clearScreen.

print "Starting orbit.ks".

lock steering to heading(90, 0, 0).

lock throttle to 0.
if stage:liquidfuel < 5 {
    stage.
}

//intoOrbitBurn.
node_apo.

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
set g_apo to (constant:g*kerbin:mass/(kerbin:radius+100000)^2).                         //Used to calculate v_final at final orbit.
set v_apo to (sqrt(ship:velocity:orbit:mag^2+2*constant:g0*(apoapsis-ship:altitude))).  //Estimates speed at apoapsis.
set v_final to (sqrt(g_apo*(kerbin:radius+100000))).                                    //Calculation of speed at orbit.
lock deltaV to v_final-v_apo.
set orbitburn to node(time:seconds+eta:apoapsis, 0, 0, deltaV).                  //Creats node. Porgrade: v_final-v_apo.
add orbitburn.                                                                          //Adds node to flightplan.                                                  
set bt to (orbitburn:deltav:mag*ship:mass)/(ship:maxthrust).                            //Estimates burntime.
lock steering to orbitburn.                                                             //Locks steering to node.
print "V final: " + v_final at (14,1).
      
    until eta:apoapsis <= bt/2+5 {
        lock v_apo to (sqrt(ship:velocity:orbit:mag^2+2*constant:g0*(apoapsis-ship:altitude))).  //Recalculates estimate of speed at apoapsis.
        set orbitburn to node(time:seconds+eta:apoapsis, 0, 0, deltaV).          //Recalcutale delta v of node.
        set bt to (orbitburn:deltav:mag*ship:mass)/(ship:maxthrust).                    //Recalculates estimate of burntime.
        print "V @ apo: " + v_apo at(14, 2).                                            //Prints v_apo.
        print "Delta V: " + (v_final-v_apo) at(14,3).                                             //Prints estimated deltaV.
    } 


    wait until (vang(orbitburn, ship:facing) <0.25 and eta:apoapsis <= bt/2).

    until periapsis > 90000. {
    lock throttle to 1.
    }

    lock throttle to 0.3.

    wait until orbitburn:deltav:mag < 0.5.
    lock throttle to 0.

    print "Note complete".
}


