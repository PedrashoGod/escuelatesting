@regresion
Feature: Automatizar el backed de Pet Store

  Background:
    * url apiPetStore
    * def jsonCrearMascota = read('classpath:examples/jsonData/crearMascota.json')

  @TEST-1 @happypath
  Scenario: Verificar la creación de una nueva macota en Pet Store - Ok
    Given path 'pet'
    And request jsonCrearMascota
    And print jsonCrearMascota
    When method post
    Then status 200
    And match response.id == 12050373382523
    And match response.name == 'Torchic'
    And match response.status == 'available'
    And print response
    * def idPet = response.id
    And print idPet

  @TEST-10
  Scenario: Verificar busqueda por id - Ok
    * def idMascota = call read('classpath:examples/users/users.feature@crearMascota')
    Given path 'pet/findByStatus'
    When method get
    Then status 200
    And print response

  @TEST-2
  Scenario: Verificar el listado de mascotas segun su estado - Ok
    Given path 'pet/findByStatus'
    And param status = 'available'
    When method get
    Then status 200
    And print response

  @TEST-3
  Scenario: Verificar el listado de mascotas segun su estado - Ok
    Given path 'pet/findByStatus'
    And param status = 'sold'
    When method get
    Then status 200
    And print response

  @TEST-4
  Scenario: Verificar el listado de mascotas segun su estado - Ok
    Given path 'pet/findByStatus'
    And param status = 'pending'
    When method get
    Then status 200
    And print response

  @TEST-5
  Scenario Outline: Verificar el estado de la mascota <estado>
    Given path 'pet/findByStatus'
    And param status = '<estado>'
    When method get
    Then status 200
    And print response
    And match each response[*].status == '<estado>'

    Examples:
      | estado    |
      | available |
      | sold      |
      | pending   |

  @TEST-6
  Scenario: Verificar la actualización de una macota previamente registrada en Pet Store - Ok
    Given path 'pet'
    And request jsonCrearMascota.id = '12050373382522'
    And request jsonCrearMascota.name = 'Boby'
    And request jsonCrearMascota
    When method put
    Then status 200
    And print response

  @TEST-7
  Scenario Outline: Verificar la mascota por el id - OK
    Given path 'pet/' + '<idPet>'
    When method get
    Then status 200
    And print response

    Examples:
      | idPet |
      | 12050373382523 |

  @TEST-8
  Scenario Outline: Eliminar la mascota por el id - OK
    Given path 'pet/' + '<idPet>'
    When method delete
    Then status 200
    And print response

    Examples:
      | idPet |
      | 1 |

  @TEST-9
  Scenario: Verificar que se suba una imagen mediante el id de una mascota - Ok
    Given path 'pet', 1 , 'uploadImage'
    And multipart file file = { read: 'orugon.png', filename: 'orugon.png', contentType: 'image/png' }
    When method post
    Then status 200
    And print response
