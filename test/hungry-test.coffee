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
    @room.user.say('cindy', '@hubot restaurant add Taco House, addr: No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300, tel: +886 3 533 8050').then =>
      expect(@room.messages).to.eql [
        ['cindy', '@hubot restaurant add Taco House, addr: No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300, tel: +886 3 533 8050']
        ['hubot', '@cindy "Taco House" added!']
      ]

  it 'deletes restaurant', ->
    restaurants =
      'McDonald\'s':
        name: 'McDonald\'s'
        addr: 'No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
        tel: '+886 3 668 5501'
    @room.robot.brain.set 'restaurants', restaurants

    @room.user.say('david', '@hubot restaurant del McDonald\'s').then =>
      expect(@room.messages).to.eql [
        ['david', '@hubot restaurant del McDonald\'s']
        ['hubot', '@david "McDonald\'s" deleted!']
      ]

  it 'no restaurant to delete', ->
    @room.user.say('david', '@hubot restaurant del Pizza Hut').then =>
      expect(@room.messages).to.eql [
        ['david', '@hubot restaurant del Pizza Hut']
        ['hubot', '@david No such restaurant.']
      ]

  it 'lists all restaurants', ->
    restaurants =
      'Taco House':
        name: 'Taco House'
        addr: 'No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300'
        tel: '+886 3 533 8050'
      'McDonald\'s':
        name: 'McDonald\'s'
        addr: 'No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
        tel: '+886 3 668 5501'
    @room.robot.brain.set 'restaurants', restaurants

    @room.user.say('evan', '@hubot restaurant list').then =>
      expect(@room.messages).to.eql [
        ['evan', '@hubot restaurant list']
        ['hubot', '@evan Taco House\nMcDonald\'s']
      ]

  it 'show restaurant details', ->
    restaurants =
      'Taco House':
        name: 'Taco House'
        addr: 'No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300'
        tel: '+886 3 533 8050'
    @room.robot.brain.set 'restaurants', restaurants

    @room.user.say('frank', '@hubot restaurant show Taco House').then =>
      expect(@room.messages).to.eql [
        ['frank', '@hubot restaurant show Taco House']
        ['hubot', '@frank Here it is!\nName: Taco House\nAddress: No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300\nTelephone No.: +886 3 533 8050']
      ]

  it 'no restaurant details to show', ->
    @room.user.say('frank', '@hubot restaurant show McDonald\'s').then =>
      expect(@room.messages).to.eql [
        ['frank', '@hubot restaurant show McDonald\'s']
        ['hubot', '@frank No such restaurant.']
      ]

  it 'promotes restaurant', ->
    restaurants =
      'Taco House':
        name: 'Taco House'
        addr: 'No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300'
        tel: '+886 3 533 8050'
      'McDonald\'s':
        name: 'McDonald\'s'
        addr: 'No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
        tel: '+886 3 668 5501'
    @room.robot.brain.set 'restaurants', restaurants

    @room.user.say('garen', '@hubot where to eat?').then =>
      expect(@room.messages[1][1]).to.contain 'may be a good choice!'

  it 'no restaurants to promote', ->
    @room.user.say('garen', '@hubot where to eat?').then =>
      expect(@room.messages).to.eql [
        ['garen', '@hubot where to eat?']
        ['hubot', '@garen Please add restaurants first.']
      ]
