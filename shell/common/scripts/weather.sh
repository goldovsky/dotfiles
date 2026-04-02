#!/bin/bash

# Define the cache file and expiration time
CACHE_FILE="/tmp/weather_cache.txt"
CACHE_EXPIRATION=1800  # Cache expiry in seconds (30 minutes)

# Check if the cache file exists and if it is recent enough
if [ -f "$CACHE_FILE" ] && [ "$(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") ))" -lt "$CACHE_EXPIRATION" ]; then
    # If the cache is still valid, use the cached content
    cached_weather=$(cat "$CACHE_FILE")
    echo "$cached_weather"
else
    # Fetch the current weather using wttr.in (Condition + temperature)
    weather=$(curl -s 'wttr.in/Lille?format=%C+%t')

    # Extract the temperature
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
    if [[ $temperature == +* ]]; then
        temperature="${temperature#+}"  # Remove '+' sign if present
    fi

    # Combine icon and temperature into the final output
    final_output="$icon $temperature"

    # Cache the result in the cache file
    echo "$final_output" > "$CACHE_FILE"

    # Output the weather
    echo "$final_output"
fi
