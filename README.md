# vf-test

This is a simple REST API generated with api-platform.
There is only one simple end-point protected by a single token.

## Use the API

Launch the environnement with the following command:
```
make install
```

At this point, the documentation is already available at `http://localhost/api/docs`, but the API is still unusable.

Then create the database with the following command:
```
make create-database
```

The API can now be used.
It is available at `http://localhost/api/widgets` and can be accessed by your favorite tool.

## Testing the API

Launch the automated tests with the following command:
```
make behat
```

> To test with [Postman](https://www.postman.com/downloads/), there is a collection available for loading.
> Import the file `vf-test.postman_collection.json` from Postman to load it and start playing with it.

## FAQ

**Why did I choose api-platform**  
It's the most efficient way of generating a REST API that I know of.
It helps focussing on what is important in an application.
There is no need to spend time on the implementation details of a POST or GET request since it's basically always identical.
Thus freeing some time for business logic.

**Why did I used behat instead of phpunit**  
In that particular use-case, there is no value to write unit test (I am not saying that it never has value) since the specific classes are reduced to their minimum.
There is no business logic in those classes that needs to be contained and validated.
Here, the testing makes more sense to be made at a higher level to validate the API output.
But even there, I am basically testing that api-platform is doing it's job properly.

**Why the X-Day header is not tested**  
There is a discrepancy between Behat and Symfony on the dependency injection system.
Thus preventing the use of internal classes to create `Context` test classes.
There is an open issue for that particular problem.

**Why my data vanished**  
At the moment, there is only one database shared between the different environnements.
Thus, its content is dropped by behat tests.
In a real environment, this needs to be addressed to be able to work with confidence.

**Why my containers do not start**  
If the ports used in the `docker-compose.yml` file are already in use, you need to change the port routing before restarting.
You'll need to change the API and the documentation URLs accordingly.

**Why my make rules are not working**  
I've tested those rules only on GNU/Linux (Arch Linux).
If you are using a different system, they might be broken.
You need to open the `Makefile` file and run the rule's commands one by one.

**How do I change the API token**  
You need to change the `API_TOKEN` token value in the `.env` file.
You can do that as well for the `.env.test` file but this will break behat tests.
