# Description
#   A hubot script that tells you where to eat
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot restaurant add <name>[; addr: <address>; | tel: <telephone no.>] - Let hubot memorize restaurant information
#   hubot restaurant del <name> - Let hubot forget restaurant information
#   hubot restaurant list - Let hubot dump all restaurant names
#   hubot restaurant show - Let hubot show restaurant detail information
#   hubot restaurant update <name>[; addr: <address>; | tel: <telephone no.>] - Let hubot update restaurant detail information
#   hubot where to eat? - Let hubot suggest you a restaurant
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Zespre Schmidt <starbops@zespre.com>

module.exports = (robot) ->
  restaurants = {}

  robot.respond /restaurant add ([^;]*)(; addr: ([^;]*))?(; tel: ([^;]*))?/i, (res) ->
    name = res.match[1]
    addr = res.match[3]
    tel = res.match[5]
    restaurant = name: name, addr: addr, tel: tel
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
      res.reply 'No such restaurant.'

  robot.respond /restaurant list/i, (res) ->
    restaurants = robot.brain.get('restaurants') or {}
    all = for name, obj of restaurants
      "#{name}"
    res.reply all.join('\n')

  robot.respond /restaurant show (.*)/i, (res) ->
    restaurants = robot.brain.get('restaurants') or {}
    restaurant = restaurants[res.match[1]]
    if not restaurant
      res.reply 'No such restaurant.'
    else
      res.reply """
                Here it is!
                Name: #{restaurant.name}
                Address: #{restaurant.addr}
                Telephone No.: #{restaurant.tel}
                """

  robot.respond /restaurant update ([^;]*)(; addr: ([^;]*))?(; tel: ([^;]*))?/i, (res) ->
    restaurants = robot.brain.get('restaurants') or {}
    restaurant = restaurants[res.match[1]]
    if not restaurant
      res.reply 'No such restaurant.'
    else
      if res.match[3]
        restaurant.addr = res.match[3]
      if res.match[5]
        restaurant.tel = res.match[5]
      robot.brain.set 'restaurants', restaurants
      res.reply """
                Updated!
                Name: #{restaurant.name}
                Address: #{restaurant.addr}
                Telephone No.: #{restaurant.tel}
                """

  robot.respond /where to eat\??/i, (res) ->
    restaurants = robot.brain.get('restaurants') or {}
    if Object.keys(restaurants).length is 0
      res.reply "Please add restaurants first."
    else
      keys = for temp_key of restaurants
        temp_key
      res.reply(res.random(keys) + ' may be a good choice!')
