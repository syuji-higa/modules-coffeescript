_ = require 'lodash'
Promise = require 'bluebird'

###
@dependsOn lodash
@dependsOn bluebird
###
module.exports =
class Promise

  ###
  create PromiseSample instance
  ###
  constructor: ->

    ###
    default
    ###
    promise = ->
      new Promise (resolve, reject) ->
        if true
          resolve 'success'
        else
          reject 'error'

    promise().then (data) ->
      console.log data


    ###
    series
    ###
    Promise.resolve()
      .then ->
        new Promise (resolve, reject) ->
          setTImeomt resolve, 1000
      .then ->
        new Promise (resolve, reject) ->
          setTImeomt resolve, 1000

    ###
    parallel
    ###
    Promise.resolve()
      .then ->
        Promise.all [
          new Promise (resolve, reject) ->
            setTImeomt resolve, 1000
          ,
          new Promise (resolve, reject) ->
            setTImeomt resolve, 1000
        ]
      .then ->
        new Promise (resolve, reject) ->
          setTImeomt resolve, 1000

    ###
    parallel (map)
    ###
    Promise.resolve()
      .then ->
        Promise.all _.map [0...3] (i) ->
          new Promise (resolve, reject) ->
            setTImeomt resolve, 1000
      .then ->
        new Promise (resolve, reject) ->
          setTImeomt resolve, 1000
