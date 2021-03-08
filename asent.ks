
thrust_limit.

wait until ship:altitude > 50000. 

//For controling and limiting the throttle
// Uses a PID for limiting, until a alt of 7000m
function thrust_limit {
    set mythrot to 0.5.             //Temp value
    lock throttle to mythrot.       //Locks throttle to the variable 
    set holdPID to pidLoop(         //Creats a PID
        0.15, 0.001, 0.001, 0, 1).  //PID values
    set hold_speed to 100.          //Temp speed restriction 

    until ship:altitude <= 7000 {   //Loop until max alt of 7000m
        
        if ship:altitude < 1500 {   //Max speed of 200 m/s until alt of 1500m
            set hold_speed to 200.
        }
        if (ship:altitude >= 1500){ //Max speed of 400 m/s after 1500m
            set hold_speed to 400.
        }
        set holdPID:setpoint to hold_speed.     //Sets setpoint for PID
        
        when true then{
        set mythrot to holdPID:update(time:seconds, ship:airspeed). //Sets throttle to PID output 
        }                                                           //(uses aitspeed and time )
    }

    lock throttle to 1.             //When max alt of 7000 meter reached, full throttle. 
} 


