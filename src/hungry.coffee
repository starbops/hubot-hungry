# Description
#   A hubot script that tells you where to eat
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot restaurant add - Let hubot memorizes restaurant information>
#   hubot restaurant del - Let hubot forgets restaurant information>
#   hubot restaurant list - Let hubot dumps all restaurant names>
#   hubot where to eat? - Let hubot suggests you a restaurant>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Zespre Schmidt <starbops@zespre.com>

module.exports = (robot) ->
  restaurants = {}

  robot.respond /restaurant add (.*)/i, (res) ->
    name = res.match[1]
    restaurant = name: name, addr: '', tel: ''
    restaurants[name] = restaurant
    robot.brain.set 'restaurants', restaurants
    res.reply "\"#{name}\" added!"

  robot.respond /restaurant del (.*)/i, (res) ->
    name = res.match[1]
    restaurants = robot.brain.get('restaurants') or {}
    if name of restaurants
      delete restaurants[name]
      robot.brain.set 'restaurants', restaurants
      res.reply "\"#{name}\" deleted!"
    else
      res.reply "no such restaurant."

  robot.respond /restaurant list/i, (res) ->
    restaurants = robot.brain.get('restaurants') or {}
    all = for name, obj of restaurants
      "#{name}"
    res.reply all.join('\n')

  robot.respond /where to eat\??/i, (res) ->
    name = 'Taco House'
    res.reply "\"#{name}\" may be a good choice!"
