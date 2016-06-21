Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/hungry.coffee')

describe 'hungry', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'adds restaurant', ->
    @room.user.say('cindy', '@hubot restaurant add Taco House').then =>
      expect(@room.messages).to.eql [
        ['cindy', '@hubot restaurant add Taco House']
        ['hubot', '@cindy "Taco House" added!']
      ]

  it 'deletes restaurant', ->
    restaurants =
      'McDonald\'s':
        name: 'McDonald\'s'
        addr: ''
        tel: ''
    @room.robot.brain.set 'restaurants', restaurants

    @room.user.say('david', '@hubot restaurant del McDonald\'s').then =>
      expect(@room.messages).to.eql [
        ['david', '@hubot restaurant del McDonald\'s']
        ['hubot', '@david "McDonald\'s" deleted!']
      ]

  it 'deletes no such restaurant', ->
    @room.user.say('david', '@hubot restaurant del Pizza Hut').then =>
      expect(@room.messages).to.eql [
        ['david', '@hubot restaurant del Pizza Hut']
        ['hubot', '@david no such restaurant.']
      ]

  it 'lists all restaurants', ->
    restaurants =
      'Taco House':
        name: 'Taco House'
        addr: ''
        tel: ''
      'McDonald\'s':
        name: 'McDonald\'s'
        addr: ''
        tel: ''
    @room.robot.brain.set 'restaurants', restaurants

    @room.user.say('frank', '@hubot restaurant list').then =>
      expect(@room.messages).to.eql [
        ['frank', '@hubot restaurant list']
        ['hubot', '@frank Taco House\nMcDonald\'s']
      ]

  it 'promotes restaurant', ->
    @room.user.say('evan', '@hubot where to eat?').then =>
      expect(@room.messages[1][1]).to.contain 'may be a good choice!'
