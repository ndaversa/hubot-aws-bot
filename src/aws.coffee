# Description:
# A hubot script to query aws for instance information
#
# Dependencies:
# - coffee-script
# - aws-sdk
# - cron
# - underscore
# - moment
#
# Configuration:
# HUBOT_AWS_CRON_JOB_INTERVAL - How often to check for updates in cron time, default `0 0 10 * * 1-5` which is every weekday at 10am
# HUBOT_AWS_REQUIRED_TAGS - A comma seperated list of required tag names to scan for
# HUBOT_AWS_ROOM_TO_REPORT_UNTAGGED - The room/channel to report the untagged instances at cron job interval
# HUBOT_AWS_REGION - The AWS region eg. "us-east-1"
# AWS_SECRET_ACCESS_KEY - AWS Secret Key
# AWS_ACCESS_KEY_ID - AWS Acesss Key
#
# Commands:
#   hubot aws untagged - List the instances that are not tagged with a role
#
# Author:
#   ndaversa

_ = require 'underscore'
moment = require 'moment'
cronJob = require("cron").CronJob
region = process.env.HUBOT_AWS_REGION
requiredTags = process.env.HUBOT_AWS_REQUIRED_TAGS.split ','
AWS = require 'aws-sdk'
AWS.config.region = region
ec2 = new AWS.EC2()

module.exports = (robot) ->
  cronTime = process.env.HUBOT_AWS_CRON_JOB_INTERVAL || "0 0 10 * * 1-5"

  reportUntagged = (room) ->
    room = room or process.env.HUBOT_AWS_ROOM_TO_REPORT_UNTAGGED
    ec2.describeInstances MaxResults: 500, (err, data) ->
      if err
        console.log err, err.stack
        return

      untagged = _(data.Reservations).filter (reservation) ->
        instances = _(reservation.Instances).filter (instance) ->
          missing = _(requiredTags).any (tag) -> not _(instance.Tags).findWhere Key: tag
          missing and instance.State.Name is 'running'
        instances.length > 0

      if untagged.length > 0
        message = "The following instances are missing at least one the following tags (#{requiredTags}) in AWS:"
        for reservation in untagged
          for instance in reservation.Instances
            url = "https://console.aws.amazon.com/ec2/v2/home?region=#{region}#Instances:search=#{instance.InstanceId};sort=instanceId"
            name = _(instance.Tags).findWhere(Key: 'Name')?.Value or "Unnamed"
            message += "\n `#{name}` (launched #{moment(instance.LaunchTime).fromNow()}) <#{url}|Console Link>"

        robot.adapter.customMessage
          channel: room
          text: message
      else
        robot.messageRoom room, "There are no untagged instances in AWS, go team!"

  robot.respond /aws untagged/, (msg) ->
    reportUntagged msg.message.room

  new cronJob(cronTime, reportUntagged, null, true)
