
# Github SSH Integration

## Generate SSH Key
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

About SSH key generation
If you don't already have an SSH key, you must generate a new SSH key to use for authentication. If you're unsure whether you already have an SSH key, you can check for existing keys. For more information, see "Checking for existing SSH keys."

If you want to use a hardware security key to authenticate to GitHub, you must generate a new SSH key for your hardware security key. You must connect your hardware security key to your computer when you authenticate with the key pair. For more information, see the OpenSSH 8.2 release notes.

If you don't want to reenter your passphrase every time you use your SSH key, you can add your key to the SSH agent, which manages your SSH keys and remembers your passphrase.

Generating a new SSH key
Open Terminal.

Paste the text below, substituting in your GitHub email address.

$ ssh-keygen -t ed25519 -C "your_email@example.com"
Note: If you are using a legacy system that doesn't support the Ed25519 algorithm, use:

$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
This creates a new SSH key, using the provided email as a label.

> Generating public/private algorithm key pair.
When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.

> Enter a file in which to save the key (/home/you/.ssh/algorithm): [Press enter]
At the prompt, type a secure passphrase. For more information, see "Working with SSH key passphrases."

> Enter passphrase (empty for no passphrase): [Type a passphrase]
> Enter same passphrase again: [Type passphrase again]
Adding your SSH key to the ssh-agent
Before adding a new SSH key to the ssh-agent to manage your keys, you should have checked for existing SSH keys and generated a new SSH key.
Start the ssh-agent in the background.

$ eval "$(ssh-agent -s)"
> Agent pid 59566
Depending on your environment, you may need to use a different command. For example, you may need to use root access by running sudo -s -H before starting the ssh-agent, or you may need to use exec ssh-agent bash or exec ssh-agent zsh to run the ssh-agent.

Add your SSH private key to the ssh-agent. If you created your key with a different name, or if you are adding an existing key that has a different name, replace id_ed25519 in the command with the name of your private key file.

$ ssh-add ~/.ssh/id_ed25519
Add the SSH key to your account on GitHub. For more information, see "Adding a new SSH key to your GitHub account."

## Adding SSH Key to Github Account
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

Copy the SSH public key to your clipboard.

In Github:
In the upper-right corner of any page, click your profile photo, then click Settings.
Settings icon in the user bar

In the user settings sidebar, click SSH and GPG keys.
Authentication keys

Click New SSH key or Add SSH key.
SSH Key button

In the "Title" field, add a descriptive label for the new key. For example, if you're using a personal Mac, you might call this key "Personal MacBook Air".

Paste your key into the "Key" field.
The key field

Click Add SSH key.
The Add key button

If prompted, confirm your GitHub password.
Sudo mode dialog