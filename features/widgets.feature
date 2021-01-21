Feature: Widget API
    In order to manipulate widgets, as an API consumer,
    I must be able to add, modify, list and delete widgets.

    Constraints are:
        - content must be in JSON
        - name is mandatory and its max length is 20 characters.
        - description is optional and its max length is 100 characters.

    @createSchema
    Scenario: listing widgets
        Given I send a "GET" request to "api/widgets"
        Then the response status code should be 401

        Given I add "X-AUTH-TOKEN" header equal to "unknown"
        And I send a "GET" request to "api/widgets"
        Then the response status code should be 401

        Given I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "GET" request to "api/widgets"
        Then the response status code should be 200
        And the response should be in JSON
        And the JSON should be equal to:
        """
        []
        """

    Scenario: creating a new widget
        Given I add "content-type" header equal to "application/json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "POST" request to "api/widgets" with body:
        """
        {
            "name": null
        }
        """
        Then the response status code should be 400
        And the response should be in JSON
        And the JSON node "detail" should be equal to 'The type of the "name" attribute must be "string", "NULL" given.'

        Given I add "content-type" header equal to "application/json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "POST" request to "api/widgets" with body:
        """
        {
            "description": "Missing name"
        }
        """
        Then the response status code should be 400
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | violations[0].propertyPath | name |
        | violations[0].message | This value should not be blank. |
        | violations[1].propertyPath | name |
        | violations[1].message | This value should not be null. |

        Given I add "content-type" header equal to "application/json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "POST" request to "api/widgets" with body:
        """
        {
            "name": ""
        }
        """
        Then the response status code should be 400
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | violations[0].propertyPath | name |
        | violations[0].message | This value should not be blank. |
        
        Given I add "content-type" header equal to "application/json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "POST" request to "api/widgets" with body:
        """
        {
            "name": "Name is really long!!!!!!!!!!!!!!!!!!!!!"
        }
        """
        Then the response status code should be 400
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | violations[0].propertyPath | name |
        | violations[0].message | The widget name must contain at most 20 characters. |

        Given I add "content-type" header equal to "application/json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "POST" request to "api/widgets" with body:
        """
        {
            "name": "Name w/description",
            "description": "Description is way to long!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        }
        """
        Then the response status code should be 400
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | violations[0].propertyPath | description |
        | violations[0].message | The widget description must contain at most 100 characters. |

        Given I add "content-type" header equal to "application/json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "POST" request to "api/widgets" with body:
        """
        {
            "name": "Name w/ description",
            "description": "Description"
        }
        """
        Then the response status code should be 201
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | id | 1 |
        | name | Name w/ description |
        | description | Description |

        Given I add "content-type" header equal to "application/json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "POST" request to "api/widgets" with body:
        """
        {
            "name": "Name wo/ description"
        }
        """
        Then the response status code should be 201
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | id | 2 |
        | name | Name wo/ description |

    Scenario: listing widgets
        Given I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "GET" request to "api/widgets"
        Then the response status code should be 200
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | [0].id | 1 |
        | [0].name | Name w/ description |
        | [0].description | Description |
        | [1].id | 2 |
        | [1].name | Name wo/ description |

        Given I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "GET" request to "api/widgets/1"
        Then the response status code should be 200
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | id | 1 |
        | name | Name w/ description |
        | description | Description |

        Given I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "GET" request to "api/widgets/2"
        Then the response status code should be 200
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | id | 2 |
        | name | Name wo/ description |

        Given I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "GET" request to "api/widgets/3"
        Then the response status code should be 404
        And the response should be in JSON

    Scenario: Updating widgets
        Given I add "content-type" header equal to "application/merge-patch+json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "PATCH" request to "api/widgets/1" with body:
        """
        {
            "name": "New name"
        }
        """
        Then the response status code should be 200
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | id | 1 |
        | name | New name |
        | description | Description |

        Given I add "content-type" header equal to "application/merge-patch+json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "PATCH" request to "api/widgets/1" with body:
        """
        {
            "description": null
        }
        """
        Then the response status code should be 200
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | id | 1 |
        | name | New name |
        And the JSON node 'description' should not exist

        Given I add "content-type" header equal to "application/merge-patch+json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "PATCH" request to "api/widgets/1" with body:
        """
        {
            "description": "New description"
        }
        """
        Then the response status code should be 200
        And the response should be in JSON
        And the JSON nodes should be equal to:
        | id | 1 |
        | name | New name |
        | description | New description |

        Given I add "content-type" header equal to "application/merge-patch+json"
        And I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "PATCH" request to "api/widgets/3" with body:
        """
        {
            "description": "New description"
        }
        """
        Then the response status code should be 404

    Scenario: Deleting widgets
        Given I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "DELETE" request to "api/widgets/2"
        Then the response status code should be 204

        Given I add "X-AUTH-TOKEN" header equal to "behat"
        And I send a "DELETE" request to "api/widgets/2"
        Then the response status code should be 404
        And the response should be in JSON
