## Users

- Users
	- Creating a user
	- Updating an existing user
	- Checking if an email exists in the system
- Companies

### Creating a user

Sample request:

```
POST '/api/users'
```
```ruby
{
	first_name: 'Andrew',
	last_name: 'Sinner',
	email: 'andrew@example.com',
	password: 'l33th@x'
}
```

A description of the parameters:

- `first_name` *string* **required** The first name of the user
- `last_name` *string* **required** The last name of the user 
- `email` *string* **required** The email address of the user
- `password` *string* **required** The user's password

Example response for success:

```
Status code: 200
```

```ruby
{
	id: 1,
	first_name: 'Andrew',
	last_name: 'Sinner',
	email: 'andrew@example.com'
}
```

A description of the response:

- `id` *integer* The unique ID of user
- `first_name` *string* The first name of the user
- `last_name` *string* The last name of the user 
- `email` *string* The email address of the user

### Updating an existing user

Example request to update an existing user:

```
POST '/api/users/:id'
```
```ruby
{
	first_name: 'Andrew',
	last_name: 'Sinner',
	email: 'andrew@example.com',
}
```
Note you cannot update the password at this endpoint. You can only udpdate the parameters listed above.

A description of the parameters:

- `first_name` *string* **(optional)** The first name of the user
- `last_name` *string* **(optional)** The last name of the user 
- `email` *string* **(optional)** The email address of the user. Must be a valid email.

### Checking if an email exists in the system

Example request:

```
GET '/api/users/email'
```
```ruby
{
	email: 'bill@microsoft.com'
}
```