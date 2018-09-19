Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://xaree38kjb.execute-api.us-east-1.amazonaws.com/dev/'

Scenario: Get Avenger by Id

Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
When method get
Then status 200

Scenario: Creates a new Avenger

Given path 'avengers'
And request {name: 'Captão America', secretIdentity: 'Steve Rogers'}
When method post
Then status 201