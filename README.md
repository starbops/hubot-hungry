# hubot-hungry

A hubot script that tells you where to eat

See [`src/hungry.coffee`](src/hungry.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-hungry --save`

Then add **hubot-hungry** to your `external-scripts.json`:

```json
[
  "hubot-hungry"
]
```

## Sample Interaction

```
user1>> hubot restaurant add McDonald's, addr: No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302, tel: +886 3 668 5501
hubot>> "McDonald's" added!

user2>> hubot restaurant add Taco Bell
hubot>> "Taco Bell" added!

user3>> hubot where to eat?
hubot>> "Taco Bell" may be a good choice!

user3>> hubot restaurant del Taco Bell
hubot>> "Taco Bell" deleted!

user4>> hubot restaurant show McDonald's
hubot>> Here it is!
Name: McDonald's
Address: No. 350, Section 1, Wenxing Rd, Zhubei City, Hsinchu County, Taiwan 302
Telephone No.: +886 3 668 5501
```

## NPM Module

https://www.npmjs.com/package/hubot-hungry
