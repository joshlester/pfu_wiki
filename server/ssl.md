
# SSL

**Confirm matching Key, Certificate Signing Request (CSR) and Certificate.**
https://www.ssl.com/faqs/how-do-i-confirm-that-a-private-key-matches-a-csr-and-certificate/

In RSA public-key cryptography, the private and public keys in a pair are mathematically related in that they share the same modulus. The length of the modulus, expressed in bits, is the key length.

To confirm that a particular private key matches the public key contained in a certificate signing request (CSR) and certificate, one must confirm that the moduli of both keys are identical. This can be done straightforwardly with OpenSSL on Linux/Unix, macOS, or Windows (with Windows 10’s Linux subsystem or Cygwin), as follows:

To view the md5 hash of the modulus of the private key:
```
openssl rsa -noout -modulus -in mykey.key | openssl md5
```

To view the md5 hash of the modulus of the CSR:
```
openssl req -noout -modulus -in mycsr.csr | openssl md5
```
To view the md5 hash of the modulus of the certificate:
```
openssl x509 -noout -modulus -in mycert.crt | openssl md5
```
If all three hashes match, the CSR, certificate, and private key are compatible. You can use diff3 to compare the moduli from all three files at once:
```
openssl req -noout -modulus -in mycsr.csr > csr-mod.txt
openssl x509 -noout -modulus -in mycert.crt > cert-mod.txt
openssl rsa -noout -modulus -in mykey.key > privkey-mod.txt
diff3 csr-mod.txt cert-mod.txt privkey-mod.txt
```
If all three files are identical, diff3 will produce no output. If you only wish to compare two files (e.g. the certificate and the private key), you can just use diff:

$ diff cert-mod.txt privkey-mod.txt
Again, diff will produce no output if the files are identical.