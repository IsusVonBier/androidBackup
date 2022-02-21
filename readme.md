# Android backup using adb or rsync

```

cd androidBackup

chmod +x mob.sh

./mob

```

## Adb vs Rsync

### Adb

Pros:

- fast, good for first backup

Cons:

- copies whole files/dirs

- overwrites if file exists

### Rsync

Pros:

- checks if file already exists

- checks file integrity

- copies only the updated part of file

Cons:

- can be slower than adb

## How to use

### Adb

- `pacman -S android-tools` / `apt install android-tools-adb`
- enable developer mode on android
- connect via usb
- check if device listed ```$ adb devices```
- `./mob.sh`

### Rsync

Android:
- Install [Termux](https://github.com/termux/termux-app) (or any other terminal emulator which allows you to install rsync and ssh)
- Open Termux and execute:
```
pkg upgrade
pkg install openssh
```
- ``passwd`` set your password and remember it, you will need it later
- ``whoami`` for username
- ``ip addr`` for ip address

PC

If you already have an SSH key or like typing passwords, you can skip this ste. Just hit Enter for the key and both passphrases:
```
$ ssh-keygen -t rsa -b 2048
Generating public/private rsa key pair.
Enter file in which to save the key (/home/username/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/username/.ssh/id_rsa.
Your public key has been saved in /home/username/.ssh/id_rsa.pub.
```
Copy your keys to the target server:
```
$ ssh-copy-id -p 8022 username@address
username@address's password:
```
Finally:
```
./mob.sh
```
