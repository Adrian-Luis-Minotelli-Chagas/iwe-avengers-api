Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://xaree38kjb.execute-api.us-east-1.amazonaws.com/dev/'

 * def getToken =
"""
function() {
 var TokenGenerator = Java.type('com.iwe.avengers.test.authorization.TokenGenerator');
 var sg = new TokenGenerator();
 return sg.getToken();
}
"""
* def token = call getToken

Scenario: Should return non-authenticated access

Given path 'avengers', 'anyid'
When method get
Then status 401

Scenario: Avenger not found

Given path 'avengers', 'avenger-not-found'
And header Authorization = 'Bearer ' + token
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
And header Authorization = 'Bearer ' + token
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

Scenario: Deletes the Avenger by Id

#Create a new Avenger
Given path 'avengers'
#And header Authorization = 'Bearer ' + token
And request {name: 'Hulk', secretIdentity: 'Bruce Banner'}
When method post
Then status 201

* def avengerToDelete = response

#Delete the Avenger
Given path 'avengers', avengerToDelete.id
#And header Authorization = 'Bearer ' + token
When method delete
Then status 204

#Search deleted Avenger
Given path 'avengers', avengerToDelete.id
And header Authorization = 'Bearer ' + token
When method get
Then status 404

#Scenario: Delete a Avenger by Id
#
#Given path 'avengers'
#And request {name: 'Captain America', secretIdentity: 'Steves Rogers'}
#When method post
#Then status 201 
#And match response == {id: '#string', name: 'Captain America', secretIdentity: 'Steves Rogers'}
#
#* def savedAvenger = response
#
#Given path 'avengers', savedAvenger.id
#When method delete
#Then status 204
#
#Given path 'avengers', savedAvenger.id
#When method get
#Then status 404

Scenario: Avenger not found on Update

Given path 'avengers', 'avenger-not-found'
And request {name: 'Captain Americas', secretIdentity: 'Steves Roger'}
When method put
Then status 404

Scenario: Updates the Avenger data

#Create a new Avenger
Given path 'avengers'
#And header Authorization = 'Bearer ' + token
And request {name: 'Captain', secretIdentity: 'Steve'}
When method post
Then status 201

* def avengerToUpdate = response

#Updates Avenger
Given path 'avengers', avengerToUpdate.id
#And header Authorization = 'Bearer ' + token
And request {name: 'Captain America', secretIdentity: 'Steve Rogers'}
When method put
Then status 200
And match $.id ==  avengerToUpdate.id
And match $.name == 'Captain America'
And match $.secretIdentity == 'Steve Rogers'

#Scenario: Update a Avenger by Id
#
#Given path 'avengers'
#And request {name: 'Captain', secretIdentity: 'Steve'}
#When method post
#Then status 201 
#And match response == {id: '#string', name: 'Captain', secretIdentity: 'Steve'}
#
#* def createdAvenger = response
#
#Given path 'avengers', createdAvenger.id
#And request {name: 'Captain America', secretIdentity: 'Steves Rogers'}
#When method put
#Then status 200
#And match $.id == createdAvenger.id
#And match $.name == 'Captain America'
#And match $.secretIdentity == 'Steves Rogers'
#
#* def updatedAvenger = $
#
#Given path 'avengers', updatedAvenger.id
#When method get
#Then status 200
#And match $ == updatedAvenger

Scenario: Update a Avenger by Id and get Bad Request

Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
And request {secretIdentity: 'Steves Roger'}
When method put
Then status 400





