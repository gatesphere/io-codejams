#!/usr/bin/env io

// moon phase calculator

Number wholepart := method( self asBinary fromBase(2) )
Number fractionpart := method( self - self wholepart )


// based on the formula available here:
// http://www.voidware.com/moon_phase.htm
mp := method(year, month, day,
  if(month < 3,
    year = year - 1
    month = month + 12
  )
  month = month + 1  
  moonyears := 365.25 * year
  moonmonths := 30.6 * month
  total_days := moonyears + moonmonths + day // total days elapsed
  total_days = total_days - 694039.09 // total days elapsed since 1900
  moon_phase := total_days % 29.530588853 // the phase
  moon_phase wholepart
)

mp_from_date := method(date,
  mp(date year, date month, date day)
)

mp_to_segment := method(phase,
  if(phase == 29 or phase >= 0 and phase <= 1, return "New moon.")
  if(phase >= 2 and phase <= 5,   return "Waxing cresent.")
  if(phase >= 6 and phase <= 9,   return "First quarter.")
  if(phase >= 10 and phase <= 13, return "Waxing gibbous.")
  if(phase >= 14 and phase <= 16, return "Full moon.")
  if(phase >= 17 and phase <= 20, return "Waning gibbous.")
  if(phase >= 21 and phase <= 24, return "Last quarter.")
  if(phase >= 25 and phase <= 28, return "Waning crescent.")
)

mp_get := method(date,
  mp_to_segment(mp_from_date(date))
)

// command line interface
d := System args rest
date := Date now
if(d size == 3,
  date := Date clone setYear(d first asNumber) setMonth(d second asNumber) setDay(d third asNumber)
)

writeln("Moon phase for #{date year} - #{date month} - #{date day}:" interpolate)
writeln(mp_get(date))
