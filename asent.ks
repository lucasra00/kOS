print "Running asent.ks".

thrust_limit_init.
until ship:altitude >= 7000 {
    thrust_limit.
    steering_control.
    stage_ssb.
    stage_lf.
}

until ship:apoapsis >=80000 {
    lock throttle to 1.
    steering_control.
    stage_ssb.
    stage_lf.
}

thrust_limit_init.
until ship:altitude >=79000 {
    lock steering to heading(90, 0, 0).
    thrust_limit.
}

lock throttle to 0.

wait until ship:altitude > 70000.

//runPath("orbit.ks").

//For controling and limiting the throttle
// Uses a PID for limiting, until a alt of 7000m
function thrust_limit_init {
    set mythrot to 0.5.             //Temp value
    lock throttle to mythrot.       //Locks throttle to the variable 
    set holdPID to pidLoop(         //Creats a PID
        0.15, 0.001, 0.001, 0, 1).  //PID values
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

    set mythrot to holdPID:update(time:seconds, ship:airspeed). //Sets throttle to PID output 
                                                                //(uses aitspeed and time )  
} 

function steering_control {
    //lock s vinkel is (90.3*e^(-6.97e(-05)*x)). 
    lock steering to heading(90, (90.2*constant:e^(-3.47e-5*ship:altitude)), 0).

}

function stage_ssb {
    on (stage:solidfuel < 0.01) {
        Stage.
    }
}
function stage_lf {
    when ship:maxThrust < 1 then {
        Stage.
    }
}

function thrust_app_limit_init {
    set mythrot to 0.1.             //Temp value
    lock throttle to mythrot.       //Locks throttle to the variable 
    set appholdPID to pidLoop(      //Creats a PID
        0.15, 0.001, 0.001, 0, 1).  //PID values
    set hold_app to 80000.          //Temp appoapsis hight. 
}

function thrust_app_limit {     
    set appholdPID:setpoint to hold_app.                           //Sets setpoint for PID
    set mythrot to appholdPID:update(time:seconds, ship:altitude). //Sets throttle to PID output 
                                                                   //(uses aitspeed and time )  
} 
