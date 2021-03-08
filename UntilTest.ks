
until false {
        if ship:altitude < 500 {
            set hold_speed to 200.
        }
         if (ship:altitude >= 500) and (ship:altitude < 7000) {
            set hold_speed to 400.
        }
    print hold_speed.
    }



wait until ship:altitude > 50000.