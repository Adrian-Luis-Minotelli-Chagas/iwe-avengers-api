Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://xaree38kjb.execute-api.us-east-1.amazonaws.com/dev/'

Scenario: Avenger not found

Given path 'avengers', 'avenger-not-found'
When method get
Then status 404

Scenario: Creates a new Avenger and seek It by Id

Given path 'avengers'
And request {name: 'Captain America', secretIdentity: 'Steve Rogers'}
When method post
Then status 201 
And match response == {id: '#string', name: 'Captain America', secretIdentity: 'Steve Rogers'}

* def savedAvenger = response

Given path 'avengers', savedAvenger.id
When method get
Then status 200
And match $ == savedAvenger

Scenario: Creates a new Avenger without the required data

Given path 'avengers'
And request {name: 'Captain America'}
When method post
Then status 400

Scenario: Not found Avenger on delete

Given path 'avengers', 'avenger-not-found'
When method delete
Then status 404

Scenario: Delete a Avenger by Id

Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
When method delete
Then status 204

Scenario: Avenger not found on Update

Given path 'avengers', 'avenger-not-found'
And request {name: 'Captain Americas', secretIdentity: 'Steves Roger'}
When method put
Then status 404

Scenario: Update a Avenger by Id

Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
And request {name: 'Captain Americas', secretIdentity: 'Steves Roger'}
When method put
Then status 200
And match response == {id: '#string', name: '#string', secretIdentity: '#string'}

Scenario: Update a Avenger by Id and get Bad Request

Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
And request {secretIdentity: 'Steves Roger'}
When method put
Then status 400





