#!/bin/bash

pixel() {
    if [ -z "$ANDROID_HOME" ]; then
        echo "Error: The ANDROID_HOME environment variable is not set."
        echo "Please set it to point to your Android SDK directory."
        return 1
    fi

    local emulator_path="$ANDROID_HOME/emulator/emulator"

    if [ ! -x "$emulator_path" ]; then
        echo "Error: Android emulator not found or is not executable at:"
        echo "$emulator_path"
        return 1
    fi

    mapfile -t avds < <("$emulator_path" -list-avds)

    if [ ${#avds[@]} -eq 0 ]; then
        echo "No Android Virtual Devices (AVDs) found."
        echo "Please create an AVD using Android Studio's AVD Manager."
        return 1
    fi

    PS3="Please select an AVD to launch (or enter 'q' to quit): "
    echo "Available AVDs:"
    
    select avd in "${avds[@]}"; do
        if [[ "$REPLY" == "q" ]]; then
            echo "Operation cancelled."
            break
        fi

        if [[ -n "$avd" ]]; then
            echo "Launching AVD: $avd..."
            nohup "$emulator_path" -avd "$avd" >/dev/null 2>&1 &
            echo "The '$avd' AVD is launching in the background."
            break
        else
            echo "Invalid selection. Please choose a number from the list."
        fi
    done
}

pixel
