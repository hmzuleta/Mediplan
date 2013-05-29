Feature: View admin login
  In order to enter my page
  As a admin
  I want to be able to login
  Scenario: View admin login
    Given I am on "/page/admin_login"
    Then I should see "Ingresar como Jefe de Consulta Externa"

  Scenario: View login form
    Given I am on "/page/admin_login"
    Then I should see "Entrar" in a button

  Scenario: Fill out admin login form
    Given I am on "/page/admin_login"
    When I fill in "pass" with "admin"
    And I click "Entrar"
    Then I should see "Opciones"
    And I should see "Cerrar sesión"
      #Ver consultorios
      Given I am on "/page/admin_page"
      When I click "Ver Consultorios"
      Then I should see "Listado de Consultorios"
      And I should see "Inscribir Consultorio" in a button
    #Generar citas
      Given I am on "/page/admin_page"
      When I click "Generar Citas"
      Then I should see "Se generaron"
    #Terminar mes
      Given I am on "/page/admin_page"
      When I click "Terminar Mes"
      Then I should see "¡El mes fue terminado con éxito!" or "Aún no es fin de mes. No se pudo terminar el mes."
    #Logout
      Given I am on "/page/admin_page"
      And I click "Cerrar sesión"
      Then I should see "Gracias por usar nuestros servicios"
      And I should see "Usted será redirigido a la página principal."
      And I should not see "Cerrar sesión"

  Scenario: Fill out admin wrong login form
    Given I am on "/page/admin_login"
    #ingresa cualquier cosa diferente de admin
    When I fill in "pass" with "adminA"
    And I click "Entrar"
    Then I should see "No admin :("
