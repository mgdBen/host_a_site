This readme is going to server as a step by step instruction manual for how I took this simple site live. Following this guide should help you get the basics up and running. It's also going to help cement the information for me. Please let me know if anything here is confusing or not clear. The biggest frustrations I had while learning how to set this was up was getting a bad doc. I am striving to make this the doc I wished I had, but it's for you, so if it's not clear tell me and I'll adjust it.   

**SERVER CREATION:** 
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

**SERVER ACCESS:**
1. You will need some tools. These are what I found the best, but there are other options. This guide assumes you are downloading/ using these. Download and Install:
    - Putty
    - Puttygen
    - WinSCP (We'll use this in a later tutorial!)
2. Install these tools.
3. First you will need to use Puttygen to turn your .pem file into an .ppk. This will allow it to work with putty. 
4. Open PuttyGen and Press `Load`. Select the .pem file you just downloaded.
5. Save a public and private key (RSA). Remember where!
6. Now you can open Putty: 
    - a) Connection
        - Data: Auto-login username:`ubuntu` (will be different if you are not using ubuntu)
        - SSH
            - Auth: Private key file for authentication: browse and select the .ppk you saved in step 5. 
    - b) Session
        - Host Name: This is your `Public IPv4 DNS` available on your instance summary
        - Port: 22 
        - Connection Type: SSH
        - Saved Sessions: The name you want to save. Hit Save. This will prevent you from needing to redo the putty config everytime you would like to access this server. 
    - c) Hit open! You will need to enter the password you selected for your keys. 
        - You should now be looking at the command line interface for your server!

**BASIC NGINX CONFIG:**
Now that you are logged into the server, we can get things running!
1. Run commands: `sudo apt update` then `sudo apt install nginx` (updates server and installs nginx)
2. We now want to configure the internal firewall:
    - Run command: `sudo ufw app list`:
        - You should see the options: 
            ```
            Available applications:
            Nginx Full
            Nginx HTTP
            Nginx HTTPS
            OpenSSH
            ```
    - Run commands: `sudo ufw allow 'Nginx Full'` & `sudo ufw allow 'OpenSSH'` (Configures your internal firewall for the same rule set that we made during server creation)   
    - Run command: `sudo ufw status`:
        - if you see `inactive`
            - Run command `sudo ufw enable` Hit yes. (Make sure you do not disconnect after enabling until OpenSSH is included under ufw status)
        - if it's active, you should see: 
        ```
        Status: active

        To                         Action      From
        --                         ------      ----
        Nginx Full                 ALLOW       Anywhere
        OpenSSH                    ALLOW       Anywhere
        Nginx Full (v6)            ALLOW       Anywhere (v6)
        OpenSSH (v6)               ALLOW       Anywhere (v6)
        ``` 
3. You can now verify that Nginx is working the default config by running `sudo systemctl status nginx` You should see it say active. If it does, Try visting your site's `Public IPv4 DNS`. Make sure you are trying to access it with http://, it will not work on https:// right now. You will know you are success if you see a big "Welcome to nginx" on the page. 

**SERVE AN HTML FILE OVER HTTP:**
Setup for the following can be done differently. I am still learning the in's and outs of Nginx configurations. This guide assumes you are following these steps. There is a lot of potential variation here, these are the steps I did:
1. let's create a folder for your site and the simple html page we are going to serve.
    - a) You do this by running `sudo mkdir -p /opt/www/websitename/html/` then `sudo chown -R $USER:$USER /opt/www/website/html` then `sudo chmod -R 755 /opt/www/website`. This is telling the server to make the directory and all parent directories that don't exist. `websitename` should be your website name.

        ```
        Breakdown:
        Sudo: "I'm the boss so do this"
        chown: "change owner"
        -R: "recursively"
        $USER:$USER: "to current user"
        /opt/etc..: "do this command here"

        chmod:change permissions
        7: give owner read+write+execute
        5: give group on this file read+execute
        5: give everyone else read+execute
        ```
    - b) run command `sudo nano /opt/www/websitename/html/index.html` This will create and open index.html into the new directory you created in step 1. 
        - I have a default html file you can use in this repo under [html-files/tutorial-basic-html/index.html](https://github.com/mgdBen/host_a_site/tree/main/html-files/tutorial-basic-html), but I would encourage you to create your own.
        - Either copy my tutorial file or one of your files, then save and exit. (In nano Paste:right-click / exit and save is `ctl`+`x`, then `y`, then `enter`.)
        - You can check to see if it was successful by hitting the up arrow (to get previous command) and then enter.       - This will run the previous command again and you should have opened index.html and you should see the file now!
2. We know have the file that we want to host on our site, but we need to tell nginx that. We are now going to create a server block which is going to tell nginx to listen to port 80 and serve this file there. You will need to have a domain now, so if you do not have one pause and go buy one. GoDaddy, Google and Amazon are three of the largest domain registrars.
3. Run command `sudo nano /etc/nginx/sites-available/websitename`.
    - a) copy the basic file block available in this repo under [/Basic-Nginx-Config-Files/basic-http](https://github.com/mgdBen/host_a_site/tree/main/Basic-Nginx-Config-Files)
    - b) paste this into the file you have open on your server
    - c) replace all instances of `websitename` with the name of your site. It will need to match the domain name you purchased. 
    - d) Save and Exit. (`right-click`, `ctl`+`x`,`y`,`enter`)
4. Run command `sudo ln -s /etc/nginx/sites-available/websitename /etc/nginx/sites-enabled/` This tells Nginx where to find the config file we created.
5. Run command `sudo nano /etc/nginx/nginx.conf` delete the `#` from the line `# server_names_hash_bucket_size 64;` so that the line says `server_names_hash_bucket_size 64;`. Save and exit: (`right-click`, `ctl`+`x`,`y`,`enter`)
6. Run command `sudo nginx -t` This will check your config files and tell you if there are errors. You want to see: 
    ```
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    ``` 
7. If there are no errors run command: `sudo systemctl restart nginx`.

**TAKE SITE LIVE AT YOUR DOMAIN NAME (HTTP):**
1. Copy the `Public IPv4 address` from your instance page on aws.
2. Create an A record in your DNS for your domain (must match the domain in the server block from 3c) (root domain in dns)
3. Create a record poiting to the same ip for host www, or have www redirect to root.


CONGRATS Your site is now live at port 80. I will be updated this guide with more instructions for getting Certbot running at a later date, so your site will also be live at port 443, as well as how to transfer files from your PC to your server at a later date. I've had a lot of fun messing with it and updating it, and I hope this guide was helpful for you too.
