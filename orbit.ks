clearScreen.

print "Starting orbit.ks".

lock steering to heading(90, 0, 0).

lock throttle to 0.
if stage:liquidfuel < 5 {
    stage.
}

node_apo.

wait 5.

//Funktions

function v_at_apo {
    declare temp to (ship:velocity:orbit:mag^2+2*constant:g*kerbin:mass*((1/(alt:apoapsis+kerbin:radius))-(1/(ship:altitude+kerbin:radius)))). //Calculates size of root.
    if (temp >= 0) {                                                                                           //No complex numbers.
        declare global v_apo to sqrt(temp).  
        print "Speed at Apoapsis:" + v_apo.                                                                     //Calculate speed at apo.
    } else {
        print "NAN. Speed at apo <0m/s.".                                                                      //Return NAN if speed<0.
    }                                                                                                          //^^Should not happen, due to physics.
}   

function node_apo {
    set v_final to (sqrt(constant:g*kerbin:mass/(kerbin:radius+ship:apoapsis))).            //Calculation of speed at orbit.
    v_at_apo.                                                                               //
    set deltaV to v_final-v_apo.                                                            //Initial guess for delta v      
    set orbitburn to node( TimeSpan(eta:apoapsis), 0, 0, deltaV).                           //Creats node. Porgrade: v_final-v_apo.
    add orbitburn.                                                                          //Adds node to flightplan.                                                  
    set bt to (orbitburn:deltav:mag*ship:mass)/(ship:maxthrust).                            //Estimates burntime.
    lock steering to orbitburn.                                                             //Locks steering to node.

        until orbitburn:orbit:periapsis>99990 {
            remove orbitburn.
            set deltaV to deltaV+1.
            set orbitburn to node(time:seconds+eta:apoapsis, 0, 0, deltaV).
        }
        
        Print "Done optmising orbit burn".

        set bt to (orbitburn:deltav:mag*ship:mass)/(ship:maxthrust).    
        print "Burn time= " + bt. 

        wait until eta:apoapsis <= bt/2+5.
        print "Getting ready to exicute burn!".

        wait until ((vang(orbitburn:deltav, ship:facing:vector)<1) and (eta:apoapsis <= bt/2)).
        print "Exicuting burn!".

        until (alt:periapsis > 93000) {
        lock throttle to 1.
        }

        until (alt:periapsis > 97000) {
        lock throttle to 0.3.
        }

        lock throttle to 0.1.

    wait until orbitburn:deltav:mag <= 0.1.
    lock throttle to 0.

    print "Note complete".
}


