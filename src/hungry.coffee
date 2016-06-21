# Description
#   A hubot script that tells you where to eat
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot restaurant add <name>, addr: <address>, tel: <telephone no.> - Let hubot memorizes restaurant information
#   hubot restaurant del <name> - Let hubot forgets restaurant information
#   hubot restaurant list - Let hubot dumps all restaurant names
#   hubot where to eat? - Let hubot suggests you a restaurant
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Zespre Schmidt <starbops@zespre.com>

module.exports = (robot) ->
  restaurants = {}

  robot.respond /restaurant add (.*), addr: (.*), tel: (.*)/i, (res) ->
    name = res.match[1]
    addr = res.match[2]
    tel = res.match[3]
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
      name = restaurant.name
      addr = restaurant.addr
      tel = restaurant.tel
      res.reply "Here it is!\nName: #{name}\nAddress: #{addr}\nTelephone No.: #{tel}"

  fetchRandom = (obj) ->
    keys = for temp_key of obj
      temp_key
    obj[keys[Math.floor(Math.random() * keys.length)]]

  robot.respond /where to eat\??/i, (res) ->
    restaurants = robot.brain.get('restaurants') or {}
    if Object.keys(restaurants).length is 0
      res.reply "Please add restaurants first."
    else
      restaurant = fetchRandom restaurants
      name = restaurant.name
      res.reply "\"#{name}\" may be a good choice!"
