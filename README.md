#Hubot AWS Bot
A hubot script to query aws for instance information

###Dependencies
  * coffee-script
  * cron
  * aws-sdk
  * underscore
  * moment

###Configuration
 - `HUBOT_AWS_CRON_JOB_INTERVAL` - How often to check for updates in cron time, default `0 0 10 * * 1-5` which is every weekday at 10am
 - `HUBOT_AWS_REQUIRED_TAGS` - A comma seperated list of required tag names to scan for
 - `HUBOT_AWS_ROOM_TO_REPORT_UNTAGGED` - The room/channel to report the untagged instances at cron job interval
 - `HUBOT_AWS_REGION` - The AWS region eg. "us-east-1"
 - `AWS_SECRET_ACCESS_KEY` - AWS Secret Key
 - `AWS_ACCESS_KEY_ID` - AWS Acesss Key

###Commands
 - `hubot aws untagged` - List the instances that are not tagged with a role
