clearScreen.
print "Running asent.ks".

thrust_limit_init.
until (ship:altitude >= 7000) {
    thrust_limit.
    steering_control.
    stage_ssb.
    stage_lf.
}

print "Speed no longer restricted.".

lock throttle to 1.
until (apoapsis >= 75000) {
    steering_control.
    stage_ssb.
    stage_lf.
}

print "Apoapsis at 73km. Turning.".
print "Starting apoapsis limit @ 100km".

lock steering to heading(90, 0, 0).

thrust_apo_limit_init.
until ship:altitude >=100000 {
    thrust_apo_limit.
    stage_lf.
    deploy_fairing.
}

lock throttle to 0.

runPath("orbit.ks").

//For controling and limiting the throttle
// Uses a PID for limiting, until a alt of 7000m
function thrust_limit_init {
    set mythrot to 0.5.             //Temp value
    lock throttle to mythrot.       //Locks throttle to the variable 
    set holdPID to pidLoop(         //Creats a PID
        0.5, 0.007, 0.007, 0, 1).  //PID values
    set hold_speed to 100.          //Temp speed restriction 
}

function thrust_limit {     
    if ship:altitude < 1500 {   //Max speed of 200 m/s until alt of 1500m
        set hold_speed to 200.
    }
    if (ship:altitude >= 1500){ //Max speed of 400 m/s after 1500m
        set hold_speed to 400.
    }
    set holdPID:setpoint to hold_speed.     //Sets setpoint for PID

    set mythrot to holdPID:update(time:seconds, ship:airspeed). //Sets throttle to PID output (uses aitspeed and time ) 
                                                                 
} 

function steering_control {
    //lock s vinkel is (90.3*e^(-6.97e(-05)*x)). 
    lock steering to heading(90, (90.2*constant:e^(-3.47e-5*ship:altitude)), 0).

}

function stage_ssb {
    if ((stage:solidfuel < 0.3) and stage:solidfuel > 0.001 ) {
        Stage.
    }
}
function stage_lf {
    if (ship:maxThrust < 1) {
        Stage.
    }
}

function thrust_apo_limit_init {
    set mythrot to 0.1.                 //Temp value
    lock throttle to mythrot.           //Locks throttle to the variable 
    set appholdPID to pidLoop(          //Creats a PID
        0.015, 0.0005, 0.0001, 0, 1).   //PID values
    set hold_app to 100000.              //Appoapsis hight. 
    set appholdPID:setpoint to hold_app.    //Sets setpoint for PID
}

function thrust_apo_limit {                            
    set mythrot to appholdPID:update(time:seconds, ship:apoapsis). //Sets throttle to PID output (uses aitspeed and time )                                                                 
} 

function deploy_fairing {
    if ship:altitude > 70000 {
        set ag10 to true.
        wait 0.01.
        set ag10 to false.
    }
}
