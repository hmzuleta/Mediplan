Feature: View patient sign up page
  In order to signup
  As a patient
  I want to be able to submit my data
  Scenario: View patient signup
    Given I am on "/page/pat_signup"
    Then I should see "Registrarse como paciente"
    And I should not see "Cerrar sesión"

  Scenario: Fill out patient signup form
    Given I am on "/page/pat_signup"
    When I fill in "name" with "Patient Test Cucumber"
    And I fill in "cedula" with "1002003004"
    And I fill in "cedulaconfirm" with "1002003004"
    And I click "Registrarse"
    Then I should see "Se registró con éxito al sistema." or "No se pudo crear su cuenta."