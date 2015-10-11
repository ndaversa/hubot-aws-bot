#Hubot AWS Bot
A hubot script to query aws for instance information

###Dependencies
  * coffee-script
  * cron
  * aws-sdk
  * underscore
  * moment

###Configuration
 - `HUBOT_AWS_REQUIRED_TAGS` - A comma seperated list of required tag names to scan for
 - `HUBOT_AWS_REGION` - The AWS region eg. "us-east-1"
 - `AWS_SECRET_ACCESS_KEY` - AWS Secret Key
 - `AWS_ACCESS_KEY_ID` - AWS Acesss Key

###Commands
 - `hubot aws untagged` - List the instances that are not tagged with a role
 - `hubot aws untagged` - List the instances that are not tagged with a role
 - `hubot aws untagged cron <crontime>` - Schedule a recurring job for untagged instances at <crontime> interval
 - `hubot aws <query> [running for <duration>]` - Search aws instances where instance tag Name contains <query> optionally for those that have been running for at least <duration>
 - `hubot aws <query> [running for <duration>] cron <crontime>` - Schedule a recurring job for search for <query> with optional <duration> at <crontime> interval
