
# Gulp



Problem
gulp : File C:\Users\Tech\AppData\Roaming\npm\gulp.ps1 cannot be loaded because running scripts is disabled on this system.

Solution
In windows terminal
```
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
```