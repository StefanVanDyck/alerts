# ALA Alerts

This is a small app responsible for sending email alerts when there are changes detected to endpoint web services (subscriptions).

Scheduling is handled by Quartz plugin in the app. It works like RSS - it checks the JSON service and reads the results and then compares that with the previously stored check and if there are new records, it triggers an email. Relies on records being sorted by date loaded. Works with any endpoint that can return date-sorted JSON output.

# Build status

[![Build Status](https://api.travis-ci.com/AtlasOfLivingAustralia/alerts.svg?branch=develop)](https://app.travis-ci.com/github/AtlasOfLivingAustralia/alerts)

# Dev environment set up 

## Recommend: 
Go folder ```./docker```, run ```docker-compose up```

Docker-compose runs MySql 8.1 on 3306, smtp4dev on 3000, 2525
  

## Alternative, you can install your own environment

What the docker-compose does:
1. Install MySql
1. Log in as root
1. ```create user 'alerts_user'@'localhost' identified as 'alerts_user';```
1. ```grant all privileges on *.* to 'alerts_user'@'localhost';```
1. ```create database alerts```
1. Create /data/alerts/config/alerts-config.properties
1. Use the template in ala-install to get the necessary values


### To check email sending on local dev environment
Run [smtp4dev](https://github.com/rnwood/smtp4dev) via Docker:

`docker run -p 3000:80 -p 2525:25 -d --name smtpdev rnwood/smtp4dev`

Emails will be sent on SMTP port 2525 (configure sending emails via `mail.enabled=true`, `grails.mail.port=2525` and `grails.mail.server=localhost`. Note: emails will not be delivered externally so you don't have to worry about spamming users.

You can view all sent emails via the smtp4dev UI on http://localhost:3000/, inlcuding HTML emails which are nicely displayed.


### 4.2.0 Release

Change logs
DB schema update:
``` ALTER TABLE alerts.query_result MODIFY logs TEXT NULL; ```

### 4.3.0 Release
No DB changes


### 4.4.0 Release
Apply new templates for alerts

#### Change logs
Database update: Check release/4.4.0-release.sql



