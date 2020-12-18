This readme is going to server as a step by step instruction manual for how I took this simple site live. Following this guide should help you get the basics up and running. It's also going to help cement the information for me. Please let me know if anything here is confusing or not clear. The biggest frustrations I had while learning how to set this was up was getting a bad doc. I am strively to make this the doc I wished I had, but it's for you, so if it's not clear tell me and I'll adjust it.   

SERVER CREATION: 
1. Create/Login your AWS account. Access EC2.
2. Under Instances - Launch Instance
3. Default settings are good for most options except: 
    - Choose AMI (This guide assumes you have chosen Ubuntu 20.04. That is not required, but it will allow you to copy commands from this walkthrough, which can be very helpful if you are a beginner)
    - Configure Instance - Auto-assign Public IP must be set to `Enable`. (Not `Use subnet settings (Enable)`).
    - Configure Security Groups - You will need 3 rules: 
        - SSH - Port 20 Source:`My IP` (Allows you access to the server with SSH)
        - HTTP - Port 80 Source:`Anywhere` (Allows web traffic with http://website.com)
        - HTTPS - Port 443 Source:`Anywhere` (Allows web traffic with https://website.com)
4. Review and Launch - Launch
5. Select an existing key pair or create a new keypair
    a) Create and name your keypair.
    b) Download
    c) Make sure you save the .pem key where you will not lose it.
Your server is now up and running! It may take a minute or two for the instance to spin up, you can move onto the next section once the Instance State says Running. Pull up the Instance by clicking on the Instance ID while we wait. We'll need some info from there. 

SERVER ACCESS:
1. You will need some tools. These are what I found the best, but there are other options. This guide assumes you are downloading/ using these. Download and Install:
    - Putty
    - Puttygen
    - WinSCP (We'll use this later!)
2. Install these tools.
3. First you will need to use Puttygen to turn your .pem file into an .ppk. This will allow it to work with putty. 
4. Open PuttyGen and Press `Load`. Select the .pem file you just downloaded.
5. Save a public and private key (RSA). Remember where!
6. Now you can open Putty: 
    a) Connection
        - Data: Auto-login username:`ubuntu` (will be different if you are not using ubuntu)
        - SSH
            - Auth: Private key file for authentication: browse and select the .ppk you saved in step 5. 
    b) Session
        - Host Name: This is your `Public IPv4 DNS` available on your instance summary
        - Port: 22 
        - Connection Type: SSH
        - Saved Sessions: The name you want to save. Hit Save. This will prevent you from needing to redo the putty config everytime you would like to access this server. 
    c) Hit open! You will need to enter the password you selected for your keys. 
        - You should not be looking at the command line interface for your server!

BASIC NGINX CONFIG:
 
