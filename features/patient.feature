Feature: View patient login
  In order to enter my page
  As a patient
  I want to be able to login
  Scenario: View patient login
    Given I am on "/page/pat_login"
    Then I should see "Ingresar como paciente"
    And I should see "Ingrese sus credenciales"
    And I should see "Entrar" in a button

  Scenario: Fill out patient login form
    Given I am on "/page/pat_login"
    When I fill in "name" with "Andres Fernandez"
    And I fill in "pID" with "1014259416"
    And I click "Entrar"
    Then I should see "Andres Fernandez"
    And I should see "Listado de citas"
    And I should see "Cerrar sesión"
    #Ver la pagina de reservar citas
      Given I am on "/page/pat_page"
      And I click "Reservar nueva cita"
      Then I should see "Reservar una cita"
    #Logout
      Given I am on "/page/pat_page"
      And I click "Cerrar sesión"
      Then I should see "Gracias por usar nuestros servicios"
      And I should see "Usted será redirigido a la página principal."
      And I should not see "Cerrar sesión"
      And I should not see "Paciente Prueba"