# METARMap

Raspberry Pi project to visualize flight conditions on a map using WS8211 or WS2812 LEDs addressed via NeoPixel

## Detailed instructions

See the Word document Metar Map Software Install and Config - 20241215.docx for complete hardware/software installation instructions.  Embedded in the document is an alternate displaymetar.py script, which will put much larger text on the optional OLED display, albeit with less information - airport code, flight category, wind speed and direction.

## Changes from PRueker's Code:

November 18, 2025
-----------------
1. Small fix to lightning detection to only start scanning the METAR raw text after the airport identifier to avoid mistakenly showing lightning for airports like KUTS.
   Apparently something in the raw text returned from aviationweather.gov changed in Sept, 2025 where the string "METAR " appears at its start.
   
  Changed
  	lightning = False if ((rawText.find('LTG', 4) == -1 and rawText.find('TS', 4) == -1) or rawText.find('TSNO', 4) != -1) else True
        print(stationId + ":"
  To
  	lightning = False if ((rawText.find('LTG', 10) == -1 and rawText.find('TS', 10) == -1) or rawText.find('TSNO', 10) != -1) else True
        print(stationId + ":"

 2. Deleted a try/except block that was intended for ancient versions of python and astral.  Was causing exceptions with new version of PI OS that I didn't feel like
    chasing down anyway.

 3. Suppressed outputting the line "Using subset airports for LED display" if a displayairports file was present but the variable ACTIVATE_EXTERNAL_METAR_DISPLAY was false. 

 4. Amended documentation to call for installing the python3-dev module (required to install rpi_ws281x), and to install the tzdata package.
    Not sure why, but without the tzdata package, the sunrise/sunset feature was causing an exception.  This did not occur prior to the trixie release of PI OS. 

December 16, 2024
-----------------
Incorporated Philip Rueker's changes from 10/17/23 re # airports in file exceeding LED count, 4/13/2024 re flight category, and 4/15/24 re station ID.

January 20, 2024
----------------
Corrected what appeared to be a typo in line:

windGust = (True if (ALWAYS_BLINK_FOR_GUSTS or windGustSpeed > WIND_BLINK_THRESHOLD) else False)

LED would not blink if gusts were equal to WIND_BLINK_THRESHOLD

Changed to:

windGust = (True if (ALWAYS_BLINK_FOR_GUSTS or windGustSpeed >= WIND_BLINK_THRESHOLD) else False)

October 17, 2023 - Changes from Philip Rueker's pre-Oct '23 Code
----------------------------------------------------------------
These are slightly different from the changes he made to deal with the aviationweather.gov API changes

- URL
  
Changed line:

url = "https://aviationweather.gov/cgi-bin/data/dataserver.php?requestType=retrieve&dataSource=metars&stationString=" + ",".join([item for item in airports if item != "NULL"]) + "&hoursBeforeNow=5&format=xml&mostRecent=true&mostRecentForEachStation=constraint"

to:

url = "https://aviationweather.gov/api/data/metar?format=xml&hoursBeforeNow=5&mostRecentForEachStation=true&ids=" + ",".join([item for item in airports if item != "NULL"])

Based on what I see on aviationweather.gov, that is is the long-term URL to use.

- Visibility

Since visibility can return a non-integer value now, e.g. "10+".  Two changes made.

Changed:

conditionDict = { "NULL": {"flightCategory" : "", "windDir": "", "windSpeed" : 0, "windGustSpeed" :  0, "windGust" : False, "lightning": False, "tempC" : 0, "dewpointC" : 0, "vis" : 0, "altimHg" : 0, "obs" : "", "skyConditions" : {}, "obsTime" : datetime.datetime.now() } }

to:

conditionDict = { "NULL": {"flightCategory" : "", "windDir": "", "windSpeed" : 0, "windGustSpeed" :  0, "windGust" : False, "lightning": False, "tempC" : 0, "dewpointC" : 0, "vis" : "", "altimHg" : 0, "obs" : "", "skyConditions" : {}, "obsTime" : datetime.datetime.now() } }

AND ... Changed:

vis = int(round(float(metar.find(‘visibility_statute_mi’).text)))

to:

vis = metar.find(‘visibility_statute_mi’).text



