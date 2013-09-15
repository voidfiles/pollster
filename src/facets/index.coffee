fs = require 'fs'
fs.path = require 'path'
async = require 'async'
utils = require '../utils'
_ = require 'underscore'


exports.poll = registry = (url, facets, callback) ->
    subset = {}

    for name in facets
        do (name) ->
            poll = registry[name]
            subset[name] = (done) -> poll url, done

    async.parallel subset, callback


here = (segments...) -> fs.path.join __dirname, segments...

for facetPath in fs.readdirSync here './'
    extension = fs.path.extname facetPath
    executable = extension in ['.coffee', '.js']
    self = (facetPath.indexOf 'index') isnt -1
    continue if self or not executable

    facetName = fs.path.basename facetPath, extension
    facetFile = here './', facetPath
    handler = require facetFile
    registry[facetName] = handler


exports.all = ['delicious', 'facebook', 'google-plus', 'linkedin', 'pinterest', 'reddit', 'twitter']