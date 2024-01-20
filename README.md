# METARMap

Raspberry Pi project to visualize flight conditions on a map using WS8211 or WS2812 LEDs addressed via NeoPixel

## Detailed instructions

See the Word document Metar Map Software Install and Config - 20240113.docx for complete hardware/software installation instructions.  Embedded in the document is an alternate displaymetar.py script, which will put much larger text on the optional OLED display, albeit with less information - airport code, flight category, wind speed and direction.

## Changes from PRueker's Code:
January 20, 2024
----------------
Corrected what appeared to be a typo in line:
windGust = (True if (ALWAYS_BLINK_FOR_GUSTS or windGustSpeed > WIND_BLINK_THRESHOLD) else False)
LED would not blink if gusts were equal to WIND_BLINK_THRESHOLD
Changed to:
windGust = (True if (ALWAYS_BLINK_FOR_GUSTS or windGustSpeed >=WIND_BLINK_THRESHOLD) else False)

Changes from Philip Rueker's pre-Oct '23 Code
---------------------------------------------
These are slightly different from the changes he made to deal with the aviationweather.gov API changes

Changed line:

url = "https://aviationweather.gov/cgi-bin/data/dataserver.php?requestType=retrieve&dataSource=metars&stationString=" + ",".join([item for item in airports if item != "NULL"]) + "&hoursBeforeNow=5&format=xml&mostRecent=true&mostRecentForEachStation=constraint"

to:

url = "https://aviationweather.gov/api/data/metar?format=xml&hoursBeforeNow=5&mostRecentForEachStation=true&ids=" + ",".join([item for item in airports if item != "NULL"])
Based on what I see on aviationweather.gov, this is the long-term URL to use

Since visibility can return a non-integer value now, e.g. "10+".  Two changes made.

Changed:

conditionDict = { "NULL": {"flightCategory" : "", "windDir": "", "windSpeed" : 0, "windGustSpeed" :  0, "windGust" : False, "lightning": False, "tempC" : 0, "dewpointC" : 0, "vis" : 0, "altimHg" : 0, "obs" : "", "skyConditions" : {}, "obsTime" : datetime.datetime.now() } }

to:

conditionDict = { "NULL": {"flightCategory" : "", "windDir": "", "windSpeed" : 0, "windGustSpeed" :  0, "windGust" : False, "lightning": False, "tempC" : 0, "dewpointC" : 0, "vis" : "", "altimHg" : 0, "obs" : "", "skyConditions" : {}, "obsTime" : datetime.datetime.now() } }

AND ... Changed:

vis = int(round(float(metar.find(‘visibility_statute_mi’).text)))

to:

vis = metar.find(‘visibility_statute_mi’).text

