
## Issues
### Fix: Unable to update ProtonVPN due to expired GPG Keys
https://www.reddit.com/r/ProtonVPN/comments/13gcwsg/is_there_a_new_app_for_linux/
```bash
# List gpg keys in specified format.
rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n'

rpm -e gpg-pubkey-645f044f-626fcd87

rpm -e gpg-pubkey-19940e11-5f99778b

dnf remove --noautoremove protonvpn

dnf install protonvpn
```
