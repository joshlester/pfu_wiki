
# Android Debug Bridge

## Download
https://developer.android.com/tools/releases/platform-tools

## Commands
 - List devices 
 ```sh
 adb devices
 ```
 
 - Setup reverse port forwarding - Access Website on PC from Android device
  ```sh
adb reverse tcp:8080 tcp:3000
 ```

- List reverse port forwarding entries
```sh
adb reverse --list
```
 
- Start & stop server
```sh
adb kill-server
adb start-server
```
 