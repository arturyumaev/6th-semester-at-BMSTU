* Initial setup

1. sudo apt-get update
2. sudo apt-get install python3-pip python3-dev nginx
3. sudo pip3 install virtualenv
4. virtualenv <your virtualenv>
5. source yourvitualenv/bin/activate
6. python3 install -r requirements.txt
7. pip3 install gunicorn flask

* Testing Gunicorn’s Ability to Serve the Project

```
gunicorn --bind 0.0.0.0:5000 wsgi:app
```

* Create a systemd Unit File

```systemd``` unit file will allow Ubuntu’s init system to automatically start Gunicorn and serve our Flask application whenever the server boots.

```
sudo nano /etc/systemd/system/app.service
```

```
[Unit]
#  specifies metadata and dependencies
Description=Gunicorn instance to serve myproject
After=network.target
# tells the init system to only start this after the networking target has been reached
# We will give our regular user account ownership of the process since it owns all of the relevant files
[Service]
# Service specify the user and group under which our process will run.
User=yourusername
# give group ownership to the www-data group so that Nginx can communicate easily with the Gunicorn processes.
Group=www-data
# We'll then map out the working directory and set the PATH environmental variable so that the init system knows where our the executables for the process are located (within our virtual environment).
WorkingDirectory=/home/tasnuva/work/deployment/src
Environment="PATH=/home/tasnuva/work/deployment/src/myprojectvenv/bin"
# We'll then specify the commanded to start the service
ExecStart=/home/tasnuva/work/deployment/src/myprojectvenv/bin/gunicorn --workers 3 --bind unix:app.sock -m 007 wsgi:app
# This will tell systemd what to link this service to if we enable it to start at boot. We want this service to start when the regular multi-user system is up and running:
[Install]
WantedBy=multi-user.target
```

We can now start the Gunicorn service we created and enable it so that it starts at boot:

```
sudo systemctl start app
sudo systemctl enable app
```

