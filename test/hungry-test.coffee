Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/hungry.coffee')

class MockResponse extends Helper.Response
  random: (items) ->
    'Taco House'


describe 'hungry', ->
  beforeEach ->
    @room = helper.createRoom({'response': MockResponse})

  afterEach ->
    @room.destroy()


  context 'adds restaurant with full information', ->
    beforeEach ->
      @room.user.say('cindy', '@hubot restaurant add Taco House; addr: No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300; tel: +886 3 533 8050')

    it 'should memorize full information of the restaurant', ->
      expect(@room.robot.brain.get 'restaurants').to.eql
        'Taco House':
          'name': 'Taco House'
          'addr': 'No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300'
          'tel': '+886 3 533 8050'

    it 'should reply to user of completion', ->
      expect(@room.messages).to.eql [
        ['cindy', '@hubot restaurant add Taco House; addr: No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300; tel: +886 3 533 8050']
        ['hubot', '@cindy "Taco House" added!']
      ]


  context 'adds restaurant with only name', ->
    beforeEach ->
      @room.user.say('cindy', '@hubot restaurant add Taco House')

    it 'should memorize name of the restaurant', ->
      expect(@room.robot.brain.get 'restaurants').to.eql
        'Taco House':
          'name': 'Taco House'
          'addr': undefined
          'tel': undefined

    it 'should reply to user of completion', ->
      expect(@room.messages).to.eql [
        ['cindy', '@hubot restaurant add Taco House']
        ['hubot', '@cindy "Taco House" added!']
      ]


  context 'deletes restaurant', ->
    beforeEach ->
      restaurants =
        "McDonald's":
          name: "McDonald's"
          addr: 'No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
          tel: '+886 3 668 5501'
      @room.robot.brain.set 'restaurants', restaurants

    it 'should forget all information of the restaurant', ->
      @room.user.say('david', "@hubot restaurant del McDonald's").then =>
        expect(@room.robot.brain.get 'restaurants').to.eql {}

    it 'should reply to user of completion', ->
      @room.user.say('david', "@hubot restaurant del McDonald's").then =>
        expect(@room.messages).to.eql [
          ['david', '@hubot restaurant del McDonald\'s']
          ['hubot', '@david "McDonald\'s" deleted!']
        ]

    it 'should complain about no such restaurant', ->
      @room.user.say('david', '@hubot restaurant del Pizza Hut').then =>
        expect(@room.messages).to.eql [
          ['david', '@hubot restaurant del Pizza Hut']
          ['hubot', '@david No such restaurant.']
        ]

  context 'two restaurants information already saved', ->
    beforeEach ->
      restaurants =
        'Taco House':
          name: 'Taco House'
          addr: 'No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300'
          tel: '+886 3 533 8050'
        "McDonald's":
          name: "McDonald's"
          addr: 'No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
          tel: '+886 3 668 5501'
      @room.robot.brain.set 'restaurants', restaurants

    it 'should list all names of restaurants', ->
      @room.user.say('evan', '@hubot restaurant list').then =>
        expect(@room.messages).to.eql [
          ['evan', '@hubot restaurant list']
          ['hubot', """
                    @evan Taco House
                    McDonald's
                    """
          ]
        ]

    it 'given name show restaurant details', ->
      @room.user.say('frank', '@hubot restaurant show Taco House').then =>
        expect(@room.messages).to.eql [
          ['frank', '@hubot restaurant show Taco House']
          ['hubot', """
                    @frank Here it is!
                    Name: Taco House
                    Address: No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300
                    Telephone No.: +886 3 533 8050
                    """
          ]
        ]

    it 'no restaurant details to show', ->
      @room.user.say('frank', '@hubot restaurant show KFC').then =>
        expect(@room.messages).to.eql [
          ['frank', '@hubot restaurant show KFC']
          ['hubot', '@frank No such restaurant.']
        ]


  context 'address typo in restaurant information which need to be updated', ->
    beforeEach ->
      restaurants =
        "McDonald's":
          name: "McDonald's"
          addr: 'No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
          tel: '+886 3 668 5501'
      @room.robot.brain.set 'restaurants', restaurants
      @room.user.say('garen', "@hubot restaurant update McDonald's; addr: No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302")

    it 'should update address and keep telphone number untouched', ->
      expect(@room.robot.brain.get 'restaurants').to.eql
        "McDonald's":
          name: "McDonald's"
          addr: 'No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
          tel: '+886 3 668 5501'

    it 'should reply to user of completion along with full information', ->
      expect(@room.messages).to.eql [
        ['garen', "@hubot restaurant update McDonald's; addr: No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302"]
        ['hubot', """
                  @garen Updated!
                  Name: McDonald's
                  Address: No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302
                  Telephone No.: +886 3 668 5501
                  """
        ]
      ]


  context 'telephone number typo in restaurant information which need to be updated', ->
    beforeEach ->
      restaurants =
        "McDonald's":
          name: "McDonald's"
          addr: 'No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
          tel: '+886 3 668 5501'
      @room.robot.brain.set 'restaurants', restaurants
      @room.user.say('garen', "@hubot restaurant update McDonald's; tel: +886 3 668 5502")

    it 'should update telephone number and keep address untouched', ->
      expect(@room.robot.brain.get 'restaurants').to.eql
        "McDonald's":
          name: "McDonald's"
          addr: 'No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
          tel: '+886 3 668 5502'

    it 'should reply to user of completion along with full information', ->
      expect(@room.messages).to.eql [
        ['garen', "@hubot restaurant update McDonald's; tel: +886 3 668 5502"]
        ['hubot', """
                  @garen Updated!
                  Name: McDonald's
                  Address: No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302
                  Telephone No.: +886 3 668 5502
                  """
        ]
      ]


  context 'both address and telephone number type in restaurant information which need to be updated', ->
    beforeEach ->
      restaurants =
        "McDonald's":
          name: "McDonald's"
          addr: 'No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
          tel: '+886 3 668 5501'
      @room.robot.brain.set 'restaurants', restaurants

    it 'should update both address and telephone number', ->
      @room.user.say('garen', "@hubot restaurant update McDonald's; addr: No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302; tel: +886 3 668 5502").then =>
        expect(@room.robot.brain.get 'restaurants').to.eql
          "McDonald's":
            name: "McDonald's"
            addr: 'No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
            tel: '+886 3 668 5502'

    it 'should reply to user of completion along with full information', ->
      @room.user.say('garen', "@hubot restaurant update McDonald's; addr: No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302; tel: +886 3 668 5502").then =>
        expect(@room.messages).to.eql [
          ['garen', "@hubot restaurant update McDonald's; addr: No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302; tel: +886 3 668 5502"]
          ['hubot', """
                    @garen Updated!
                    Name: McDonald's
                    Address: No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302
                    Telephone No.: +886 3 668 5502
                    """
          ]
        ]

    it 'should complain about no restaurant to update', ->
      @room.user.say('garen', '@hubot restaurant update McDonalds, addr: No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302, tel: +886 3 668 5502').then =>
        expect(@room.messages).to.eql [
          ['garen', '@hubot restaurant update McDonalds, addr: No. 351, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302, tel: +886 3 668 5502']
          ['hubot', '@garen No such restaurant.']
        ]


  it 'promotes restaurant', ->
    restaurants =
      'Taco House':
        name: 'Taco House'
        addr: 'No. 13, Lane 2, Sanmin Rd, East District, Hsinchu City, Taiwan 300'
        tel: '+886 3 533 8050'
      "McDonald's":
        name: "McDonald's"
        addr: 'No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302'
        tel: '+886 3 668 5501'
    @room.robot.brain.set 'restaurants', restaurants

    @room.user.say('garen', '@hubot where to eat?').then =>
      expect(@room.messages).to.eql [
        ['garen', '@hubot where to eat?']
        ['hubot', '@garen Taco House may be a good choice!']
      ]

  it 'no restaurants to promote', ->
    @room.user.say('garen', '@hubot where to eat?').then =>
      expect(@room.messages).to.eql [
        ['garen', '@hubot where to eat?']
        ['hubot', '@garen Please add restaurants first.']
      ]
