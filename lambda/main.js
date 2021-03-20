'use strict'

exports.handler = function (event, context, callback) {
    var response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/html; charset=utf-8',
        },
        body: '<h1>Hello from AWS Lambda! 🎉</h1>',
    }
    callback(null, response)
}
