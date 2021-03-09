clearScreen.

print "Starting orbit.ks".
print "Rising orbit to 100km".

lock steering to heading(90, 0, 0).

orb_apo_limit_init.
until apoapsis >=100000 {
    orb_apo_limit.
    stage_lf.
}

lock throttle to 0.
if stage:liquidfuel < 5 {
    stage.
}

intoOrbitBurn.



wait 5.

function orb_apo_limit_init {
    set throt to 0.1.                       //Temp value
    lock throttle to throt.                 //Locks throttle to the variable 
    set orbholdPID to pidLoop(              //Creats a PID
        0.15, 0.008, 0.02, 0, 1).            //PID values
    set hold_apo to 100000.                 //Appoapsis hight. 
    set orbholdPID:setpoint to hold_apo.    //Sets setpoint for PID
}

function orb_apo_limit {                            
    set throt to orbholdPID:update(time:seconds, ship:apoapsis). //Sets throttle to PID output (uses aitspeed and time )                                                                 
} 

function intoOrbitBurn {
    set disHeight to 100000.                                        //Disired altitude.
    set vAtHeight to (sqrt(constant:g0*(kerbin:radius+disHeight))). //Calculate the speed at disired altitude.
    set dV to (vAtHeight-(sqrt(ship:velocity:orbit:mag^2+2*constant:g0*(apoapsis-ship:altitude)))).   //Calculate the deltaV needed to orbit. The last bit is just physiscs;-)
    set a to (maxThrust/ship:mass).                                 //Estemate on the acceleration (start a)
    set t_start to (dV/(2*a))-1.                                      //Calculate the start time for the burn.

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



