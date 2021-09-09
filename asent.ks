//This script is used after the liftoff script to steer the rocket into suborbital orbit with a apoapsis very close to 95km. 
//The steering is controled by 2 functions, one for under 78km which is an exponetial function and one constant once above. 
//The script includes a speed restricter, such that the speed is held under 400m/s when under 7km and under 200m/s when under 1500. This is done using a PID
//A PID is also used to adjust the throttel to keep the apoapsis at 95km so the apoapsis is colse to spot on. 
//The script will also auto stage as well as deploy fairings once above 70km. 

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
until (apoapsis >= 73000) {
    steering_control.
    stage_ssb.
    stage_lf.
}

print "Apoapsis at 73km. Turning.".
print "Starting apoapsis limit @ 95km".

thrust_apo_limit_init.
until (ship:altitude >=75000) and (apoapsis>=94995) {
    steering_control.
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

    set mythrot to holdPID:update(time:seconds, ship:airspeed). //Sets throttle to PID output (uses airspeed and time ) 
                                                                 
} 

function steering_control {
    //lock s vinkel is (90.3*e^(-6.97e(-05)*x)). 
    if ship:altitude<78000 {
        lock steering to heading(90, (90.2*constant:e^(-4.64e-5*ship:altitude)), 0).
    } 
    else {
        lock steering to heading(90,0,0).
    }

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
    set hold_app to 95000.              //Appoapsis hight. 
    set appholdPID:setpoint to hold_app.    //Sets setpoint for PID
}

function thrust_apo_limit {                            
    set mythrot to appholdPID:update(time:seconds, ship:apoapsis). //Sets throttle to PID output (uses speed and time )                                                                 
} 

function deploy_fairing {
    if ship:altitude > 70000 {
        set ag10 to true.
        wait 0.01.
        set ag10 to false.
    }
}
