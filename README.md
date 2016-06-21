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
user1>> hubot restaurant add McDonald's
hubot>> "McDonald's" added!
user2>> hubot restaurant add Taco Bell
hubot>> "Taco Bell" added!
user3>> hubot where to eat?
hubot>> "Taco Bell" may be a good choice!
user3>> hubot restaurant del Taco Bell
hubot>> "Taco Bell" deleted!
```

## NPM Module

https://www.npmjs.com/package/hubot-hungry
