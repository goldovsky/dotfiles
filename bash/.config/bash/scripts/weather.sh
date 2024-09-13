#!/bin/bash

# Fetch the current weather using wttr.in (Condition + temperature)
weather=$(curl -s 'wttr.in/?format=%C+%t')

# Extract just the temperature using parameter expansion
# We use regular expression to extract the number (positive or negative) from the temperature string
temperature=$(echo "$weather" | grep -oE '[+-]?[0-9]+°C')

# Remove the weather condition part and get the temperature
weather_condition=$(echo "$weather" | awk '{print $1}')
case "$weather_condition" in
    Clear*) icon="" ;;  # Sunny icon
    Cloud*) icon="" ;;  # Cloudy icon
    Rain*) icon="" ;;   # Rainy icon
    Snow*) icon="" ;;   # Snow icon
    Fog*) icon="" ;;    # Fog icon
    Thunder*) icon="" ;; # Thunder icon
    *) icon="" ;;       # Default icon
esac

# Check if the temperature is positive or negative and format accordingly
# Remove the plus sign if temperature is positive
if [[ $temperature == +* ]]; then
    temperature="${temperature#+}"  # Remove '+' sign if present
fi

# Output the weather icon followed by the temperature only
echo "$icon $temperature"
