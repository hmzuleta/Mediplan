Feature: View index
  In order to read the page
  As a viewer
  I want to see the index of my app
  Scenario: View index
    Given I am on "/"
    Then I should see "Soy paciente"
    And I should see "Iniciar sesión"
    And I should see "Aún no tengo cuenta"

  Scenario: Find heading on the index
    Given I am on "/"
    Then I should see "Bienvenido a Mediplan:"
