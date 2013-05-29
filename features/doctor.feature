Feature: View doctor login
  In order to enter my page
  As a doctor
  I want to be able to login
  Scenario: View doctor login
    Given I am on "/page/doc_login"
    Then I should see "Ingresar como Médico"
    And I should see "Ingrese sus credenciales:"
    And I should see "Entrar" in a button


  Scenario: Fill out doctor login form
    Given I am on "/page/doc_login"
    When I fill in "name" with "Brown"
    And I fill in "pID" with "2000000"
    And I click "Entrar"
    Then I should see "Dr. Brown"
    And I should see "Próximas citas"
    And I should see "Cerrar sesión"
  #Logout
    Given I am on "/page/doc_page"
    And I click "Cerrar sesión"
    Then I should see "Gracias por usar nuestros servicios"
    And I should see "Usted será redirigido a la página principal."
    And I should not see "Cerrar sesión"

  Scenario: Fill out doctor login form wrong
    Given I am on "/page/doc_login"
    When I fill in "name" with "Brown"
    And I fill in "pID" with "20000001"
    #cualquier password mala
    And I click "Entrar"
    Then I should see "Login Incorrecto"
    And I should see "Volver" in a button